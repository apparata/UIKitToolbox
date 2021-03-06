//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

private let memoryCacheCapacity = megabyte(128)
private let diskCacheCapacity = megabyte(128)

private let urlSession = AsyncImageURLSessionFactory.makeURLSession()
private let urlCache = URLCache(memoryCapacity: memoryCacheCapacity,
                                diskCapacity: diskCacheCapacity,
                                diskPath: "asyncImageViewCache")

public class AsyncImageView: UIImageView {
    
    public enum Error: Swift.Error {
        case failedToLoad(underlying: Swift.Error)
        case invalidImageData(data: Data?)
    }
    
    public typealias ErrorHandler = (AsyncImageView, URL, Error) -> Void
    
    #if DEBUG
    public static var isDebugModeEnabled = false
    #endif
    
    private var imageURLRequest: URLRequest?
    private weak var loadTask: URLSessionDataTask?
    private let loadLock = NSLock()
    
    public static func flushCache() {
        urlCache.removeAllCachedResponses()
    }
    
    public func loadImage(url: URL, errorHandler: ErrorHandler? = nil) {
        
        let request = URLRequest(url: url)
        
        #if DEBUG
        if AsyncImageView.isDebugModeEnabled {
            logCacheStatus(for: request)
        }
        #endif
        
        if let cachedResponse = urlCache.cachedResponse(for: request) {
            loadLock.lock()
            imageURLRequest = request
            loadLock.unlock()
            handleLoadImageResult(data: cachedResponse.data,
                                  error: nil,
                                  url: url,
                                  errorHandler: errorHandler)
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.handleLoadImageResult(data: data, error: error, url: url, errorHandler: errorHandler)
            }
        }
        
        loadLock.lock()
        
        imageURLRequest = request
        loadTask?.cancel()
        loadTask = task
        task.resume()
        
        loadLock.unlock()
    }
    
    private func handleLoadImageResult(data: Data?, error: Swift.Error?, url: URL, errorHandler: ErrorHandler?) {
        if let error = error {
            if !isCancellationError(error) {
                errorHandler?(self, url, Error.failedToLoad(underlying: error))
            }
            return
        }
        
        guard let imageData = data, let image = UIImage(data: imageData) else {
            errorHandler?(self, url, Error.invalidImageData(data: data))
            return
        }
        
        loadLock.lock()
        let isLatestRequestedImage = (url == imageURLRequest?.url)
        loadLock.unlock()
        
        if isLatestRequestedImage {
            self.image = image
        }
    }
    
    #if DEBUG
    private func logCacheStatus(for request: URLRequest) {
        // swiftlint:disable force_unwrapping
        if urlCache.cachedResponse(for: request) == nil {
            print("❌ \(request.url!)")
        } else {
            print("✅ \(request.url!)")
        }
        // swiftlint:enable force_unwrapping
    }
    #endif
}

// MARK: - Helpers

private func megabyte(_ multiplier: Int) -> Int {
    return multiplier * 1024 * 1024
}

private class AsyncImageURLSessionFactory: NSObject {
    
    private static let shared = AsyncImageURLSessionFactory()
    
    fileprivate static func makeURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.urlCache = urlCache
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
}

private func isCancellationError(_ error: Error) -> Bool {
    if (error as NSError).code == NSURLErrorCancelled {
        return true
    }
    return false
}

#endif

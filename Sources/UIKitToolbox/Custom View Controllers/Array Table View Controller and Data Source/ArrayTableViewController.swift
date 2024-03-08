//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

open class ArrayTableViewController<Item, Cell: UITableViewCell & NibBacked>: UITableViewController {
    
    public typealias SectionIndex = ArrayDataSource<Item, Cell>.SectionIndex
    public typealias ItemIndex = ArrayDataSource<Item, Cell>.ItemIndex
    public typealias Section = ArrayDataSourceSection<Item>
    
    public let dataSource: ArrayDataSource<Item, Cell>
    
    public var configureCell: ((Cell, Item, Section, SectionIndex, ItemIndex) -> Void)? {
        didSet {
            dataSource.configureCell = configureCell
        }
    }
    
    public var didSelectItem: ((Item, Section, SectionIndex, ItemIndex) -> Void)?
    public var didDeselectItem: ((Item, Section, SectionIndex, ItemIndex) -> Void)?
    public var willDisplayItem: ((Item, Section, Cell, SectionIndex, ItemIndex) -> Void)?
    public var didEndDisplayingItem: ((Item, Section, Cell, SectionIndex, ItemIndex) -> Void)?
    public var didScroll: ((_ tableView: UITableView, _ y: CGFloat) -> Void)?
    
    private var configureHeaderForSection: ((UITableViewHeaderFooterView, Section, SectionIndex) -> Void)?
    private var headerReuseIdentifier: String?
    private var headerHeight: CGFloat?
    
    public static func make(items: [Item], configureCell: ((Cell, SectionIndex, ItemIndex) -> Void)? = nil) -> ArrayTableViewController {
        let viewController = ArrayTableViewController(items: items)
        return viewController
    }

    public static func make(sections: [ArrayDataSourceSection<Item>], configureCell: ((Cell, SectionIndex, ItemIndex) -> Void)? = nil) -> ArrayTableViewController {
        let viewController = ArrayTableViewController(sections: sections)
        return viewController
    }
    
    public init(items: [Item], configureCell: ((Cell, Item, Section, SectionIndex, ItemIndex) -> Void)? = nil) {
        dataSource = ArrayDataSource(items: items)
        super.init(nibName: nil, bundle: nil)
        self.configureCell = configureCell
        dataSource.configureCell = configureCell
    }
    
    public init(sections: [ArrayDataSourceSection<Item>], configureCell: ((Cell, Item, Section, SectionIndex, ItemIndex) -> Void)? = nil) {
        dataSource = ArrayDataSource(sections: sections)
        super.init(nibName: nil, bundle: nil)
        self.configureCell = configureCell
        dataSource.configureCell = configureCell
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        Cell.registerNib(with: tableView)
    }
    
    public subscript(section: SectionIndex) -> ArrayDataSourceSection<Item> {
        return dataSource.sections[section]
    }
    
    public func registerHeader<HeaderView: UITableViewHeaderFooterView & NibBacked & CellReuseIdentifier>(
        _ type: HeaderView.Type,
        height: CGFloat = 44,
        configureHeader: @escaping (HeaderView, Section, SectionIndex) -> Void) {
        tableView.register(HeaderView.associatedNib,
                           forHeaderFooterViewReuseIdentifier: HeaderView.cellReuseIdentifier)
        headerReuseIdentifier = HeaderView.cellReuseIdentifier
        headerHeight = height
        dataSource.isSectionHeaderTitlesEnabled = false
        configureHeaderForSection = { headerView, section, sectionIndex in
            configureHeader(headerView as! HeaderView, section, sectionIndex)
        }
    }
    
    // MARK: - Table View Delegate
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let item = section.items[indexPath.row]
        didSelectItem?(item, section, indexPath.section, indexPath.row)
    }
    
    open override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let item = section.items[indexPath.row]
        didDeselectItem?(item, section, indexPath.section, indexPath.row)
    }
    
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let item = section.items[indexPath.row]
        willDisplayItem?(item, section, cell as! Cell, indexPath.section, indexPath.row)
    }
    
    open override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let item = section.items[indexPath.row]
        didEndDisplayingItem?(item, section, cell as! Cell, indexPath.section, indexPath.row)
    }
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reuseIdentifier = headerReuseIdentifier else {
            return nil
        }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) else {
            return nil
        }
        configureHeaderForSection?(headerView, dataSource.sections[section], section)
        return headerView
    }
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight ?? 44
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView as! UITableView, scrollView.contentOffset.y)
    }
}

#endif

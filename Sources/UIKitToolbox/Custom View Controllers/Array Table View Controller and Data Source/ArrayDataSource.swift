//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

#if canImport(UIKit) && os(iOS)

import UIKit

public struct ArrayDataSourceSection<Item> {
    public let name: String?
    public let items: [Item]
    
    public init(name: String?, items: [Item]) {
        self.name = name
        self.items = items
    }
}

public class ArrayDataSource<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
    
    public typealias SectionIndex = Int
    public typealias ItemIndex = Int
    public typealias Section = ArrayDataSourceSection<Item>
    
    public let sections: [ArrayDataSourceSection<Item>]
    
    public var configureCell: ((Cell, Item, ArrayDataSourceSection<Item>, SectionIndex, ItemIndex) -> Void)?
    
    public var isSectionHeaderTitlesEnabled: Bool = true
    
    public init(items: [Item], configureCell: ((Cell, Item, Section, SectionIndex, ItemIndex) -> Void)? = nil) {
        self.sections = [ArrayDataSourceSection(name: nil, items: items)]
        isSectionHeaderTitlesEnabled = false
        self.configureCell = configureCell
    }
    
    internal init(sections: [Section], enableHeaderTitles: Bool = true, configureCell: ((Cell, Item, Section, SectionIndex, ItemIndex) -> Void)? = nil) {
        self.sections = sections
        isSectionHeaderTitlesEnabled = enableHeaderTitles
        self.configureCell = configureCell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueCell(for: indexPath)
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        configureCell?(cell, item, section, indexPath.section, indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSectionHeaderTitlesEnabled {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    
}

public class ArrayDataSourceAndDelegate<Item, Cell: UITableViewCell>: ArrayDataSource<Item, Cell>, UITableViewDelegate {
    
    public var didSelectItem: ((Item, Section, SectionIndex, ItemIndex) -> Void)?
    public var didDeselectItem: ((Item, Section, SectionIndex, ItemIndex) -> Void)?
    public var willDisplayItem: ((Item, Section, Cell, SectionIndex, ItemIndex) -> Void)?
    public var didEndDisplayingItem: ((Item, Section, Cell, SectionIndex, ItemIndex) -> Void)?
    public var didScroll: ((_ tableView: UITableView, _ y: CGFloat) -> Void)?
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        didSelectItem?(item, section, indexPath.section, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        didDeselectItem?(item, section, indexPath.section, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        willDisplayItem?(item, section, cell as! Cell, indexPath.section, indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        didEndDisplayingItem?(item, section, cell as! Cell, indexPath.section, indexPath.row)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView as! UITableView, scrollView.contentOffset.y)
    }
}

#endif

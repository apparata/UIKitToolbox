//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@MainActor
public class TableViewConfigurator {
    
    private let tableView: UITableView
    
    public init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    
    @discardableResult
    public func automaticRowHeight(estimated rowHeight: CGFloat = 44.0) -> TableViewConfigurator {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = rowHeight
        return self
    }

    @discardableResult
    public func automaticSectionHeaderHeight(estimated headerHeight: CGFloat = 44.0) -> TableViewConfigurator {
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = headerHeight
        return self
    }
    
    @discardableResult
    public func automaticSectionFooterHeight(estimated footerHeight: CGFloat = 44.0) -> TableViewConfigurator {
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = footerHeight
        return self
    }
    
    @discardableResult
    public func hideSeparatorsBetweenUnusedCells() -> TableViewConfigurator {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return self
    }
    
    @discardableResult
    public func hideSeparators() -> TableViewConfigurator {
        tableView.separatorStyle = .none
        return self
    }
    
    @discardableResult
    public func hideTopGroupPadding() -> TableViewConfigurator {
        if tableView.style == .grouped {
            // avoid the 35pt top margin in grouped table views
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat.leastNormalMagnitude))
        }
        return self
    }
}

#endif

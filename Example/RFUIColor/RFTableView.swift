//
//  RFTableView.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-11-11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "cell"

protocol RFTableViewDelegate: AnyObject {
    func numberOfColors(in tableView: RFTableView) -> Int
    func tableView(_ tableView: RFTableView, colorInfoFor index: Int) -> RFColorInfo?
}

class RFTableView: UITableView {

    weak var rfDelegate: RFTableViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        dataSource = self
    }

    func highlight(cellFor index: Int) {
        if let cell = cellForRow(at: IndexPath(item: index, section: 0)) {
            cell.layer.borderWidth = 2.0
        }
    }
}

extension RFTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rfDelegate = rfDelegate, let rfTableView = tableView as? RFTableView else {
            return 0
        }
        return rfDelegate.numberOfColors(in: rfTableView)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let rfDelegate = rfDelegate, let rfTableView = tableView as? RFTableView else {
            return cell
        }
        let colorInfo = rfDelegate.tableView(rfTableView, colorInfoFor: indexPath.item)
        cell.contentView.backgroundColor = colorInfo?.color

        cell.textLabel?.text = colorInfo?.name
        cell.textLabel?.textColor = colorInfo?.textColor
        cell.detailTextLabel?.text = colorInfo?.color.hexValue
        cell.detailTextLabel?.textColor = colorInfo?.textColor

        cell.layer.borderColor = colorInfo?.textColor.cgColor
        cell.layer.borderWidth = 0.0
        return cell
    }
}

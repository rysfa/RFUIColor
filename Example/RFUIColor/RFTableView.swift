//
//  RFTableView.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-11-11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "RFTableViewReuseIdentifier"

struct RFTableViewCellData {

    var color: UIColor
    var name: String
    var textColor: UIColor
    var isSelected: Bool

    init(color color1: UIColor,
         name name1: String,
         textColor textColor1: UIColor,
         isSelected isSelected1: Bool = false) {
        color = color1
        name = name1
        textColor = textColor1
        isSelected = isSelected1
    }
}

class RFTableView: UITableView {

    weak var viewModel: RFViewModel?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RFTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfColors ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let data = viewModel?.colorCellData(for: indexPath.item) {
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = data.isSelected ? 2.0 : 0.0
            cell.contentView.backgroundColor = data.color
            cell.textLabel?.text = data.name
            cell.textLabel?.textColor = data.textColor
        }
        return cell
    }
}

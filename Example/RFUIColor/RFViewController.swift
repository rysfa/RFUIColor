//
//  RFViewController.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-11-11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class RFViewController: UIViewController {

    @IBOutlet weak var textField: RFTextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var tableView: RFTableView!
    let viewModel = RFViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.downloadSampleColorsAndSegments()

        textField.rfDelegate = self
        tableView.rfDelegate = self
    }
}

extension RFViewController: RFViewModelDelegate {

    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingColors success: Bool, withError error: Error?) {
        if success {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension RFViewController: RFTextFieldDelegate {

    func textField(_ textField: RFTextField, updateColorTo color: UIColor) {
        colorButton.backgroundColor = color
        let index = viewModel.indexForBestMatch(for: color)
        tableView.scrollToRow(at: IndexPath(item: index, section: 0), at: .middle, animated: false)
        tableView.highlight(cellFor: index)
    }
}

extension RFViewController: RFTableViewDelegate {

    func numberOfColors(in tableView: RFTableView) -> Int {
        return viewModel.numberOfColors
    }

    func tableView(_ tableView: RFTableView, colorInfoFor index: Int) -> RFColorInfo? {
        return viewModel.colorInfo(for: index)
    }
}

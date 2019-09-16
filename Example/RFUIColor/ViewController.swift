//
//  ViewController.swift
//  RFUIColor
//
//  Created by rysfa on 09/02/2019.
//  Copyright (c) 2019 rysfa. All rights reserved.
//

import UIKit
import RFUIColor

fileprivate let reuseIdentifier = "RFColorLibraryTableViewCell"

class ViewController: UIViewController {

    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var groupedSwitch: UISwitch!

    @IBOutlet weak var colorGradientView: UIView!
    fileprivate var colorGradientLayer = CAGradientLayer()

    @IBOutlet weak var colorLibraryTableView: UITableView!
    @IBOutlet weak var colorLibraryTopFadeView: UIView!
    @IBOutlet weak var colorLibraryBottomFadeView: UIView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorLibraryTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        groupedSwitch.isEnabled = false

        activityIndicatorView.hidesWhenStopped = true

        downloadSampleColorsAndSegments()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildColorLibraryFades()

        colorGradientLayer.transform = CATransform3DMakeRotation(-.pi/2, 0.0, 0.0, 1.0)
        colorGradientLayer.frame = colorGradientView.bounds
        colorGradientView.layer.insertSublayer(colorGradientLayer, at: 0)
    }

    @IBAction func didChangeOrderValue(_ sender: UISegmentedControl) {
        updateColorLibrary()
    }

    @IBAction func didChangeSortByValue(_ sender: UISegmentedControl) {
        updateColorLibrary()
    }

    @IBAction func didChangeGroupedValue(_ sender: UISwitch) {
        updateColorLibrary()
    }

    fileprivate func updateColorLibrary() {
        if groupedSwitch.isOn {
            sortBySegmentedControl.isEnabled = false
            RFColorLibrary.main.sortBy = .segment
        } else {
            sortBySegmentedControl.isEnabled = true
            switch sortBySegmentedControl.selectedSegmentIndex {
            case 0:
                RFColorLibrary.main.sortBy = .hue
                break
            case 1:
                RFColorLibrary.main.sortBy = .brightness
                break
            default:
                break
            }
        }
        RFColorLibrary.main.ascending = orderSegmentedControl.selectedSegmentIndex == 0
        colorLibraryTableView.reloadData()
        colorLibraryTopFadeView.alpha = 0.0
        colorLibraryBottomFadeView.alpha = 1.0
    }

    fileprivate func updateGradientView() {
        var gradientColors = [CGColor]()
        for colorHexValue in RFColorLibrary.main.rawSegments {
            if let color = colorHexValue.color {
                gradientColors.append(color.cgColor)
            }
        }
        colorGradientLayer.colors = gradientColors
    }

    fileprivate func downloadSampleColorsAndSegments() {
        activityIndicatorView.startAnimating()
        RFColorLibrary.main.downloadSampleColorsAndSegments(withColors: { [weak self] (success: Bool, error: Error?) in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
            }
            if success {
                DispatchQueue.main.async {
                    self?.updateColorLibrary()
                }
            }
        }) { [weak self] (success: Bool, error: Error?) in
            if success {
                DispatchQueue.main.async {
                    self?.groupedSwitch.isEnabled = true
                    self?.updateGradientView()
                }
            }
        }
    }

    fileprivate func buildColorLibraryFades() {
        let topFadeGradientLayer = CAGradientLayer()
        topFadeGradientLayer.frame = colorLibraryTopFadeView.bounds
        topFadeGradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        colorLibraryTopFadeView.layer.insertSublayer(topFadeGradientLayer, at: 0)

        let bottomFadeGradientLayer = CAGradientLayer()
        bottomFadeGradientLayer.frame = colorLibraryBottomFadeView.bounds
        bottomFadeGradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        colorLibraryBottomFadeView.layer.insertSublayer(bottomFadeGradientLayer, at: 0)
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RFColorLibrary.main.colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let colorHexValue = RFColorLibrary.main.colors[indexPath.item]
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        if let color = colorHexValue.color {
            cell.contentView.backgroundColor = color
            cell.textLabel?.text = RFColorLibrary.main.rawColors[colorHexValue]
            cell.textLabel?.textColor = color.brightness > 0.5 ? UIColor.black : UIColor.white
        }
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y < colorLibraryTopFadeView.bounds.height {
            colorLibraryTopFadeView.alpha = scrollView.contentOffset.y / colorLibraryTopFadeView.bounds.height
        } else {
            colorLibraryTopFadeView.alpha = 1.0
        }

        let lowerBound = scrollView.contentSize.height - scrollView.bounds.height - colorLibraryBottomFadeView.bounds.height
        if scrollView.contentOffset.y > lowerBound {
            colorLibraryBottomFadeView.alpha = 1.0 - ((scrollView.contentOffset.y - lowerBound) / colorLibraryBottomFadeView.bounds.height)
        } else {
            colorLibraryBottomFadeView.alpha = 1.0
        }
    }
}

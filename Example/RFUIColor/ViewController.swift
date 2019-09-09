//
//  ViewController.swift
//  RFUIColor
//
//  Created by rysfa on 09/02/2019.
//  Copyright (c) 2019 rysfa. All rights reserved.
//

import UIKit
import RFUIColor

fileprivate let reuseIdentifier = "RFColorLibraryCollectionViewCell"

class ViewController: UIViewController {

    @IBOutlet weak var colorLibraryCollectionView: UICollectionView!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateColorLibrary()
        RFColorLibrary.main.downloadSampleColorsAndSegments(withColors: { [weak self] (success: Bool, error: Error?) in
            DispatchQueue.main.async {
                self?.colorLibraryCollectionView.reloadData()
            }
        })
    }

    @IBAction func didChangeSortByValue(_ sender: UISegmentedControl) {
        updateColorLibrary()
        colorLibraryCollectionView.reloadData()
    }

    fileprivate func updateColorLibrary() {
        switch sortBySegmentedControl.selectedSegmentIndex {
        case 0:
            RFColorLibrary.main.sortBy = .hue
            break
        case 1:
            RFColorLibrary.main.sortBy = .brightness
            break
        default:
            RFColorLibrary.main.sortBy = .segment
            break
        }
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RFColorLibrary.main.colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let colorHexValue = RFColorLibrary.main.colors[indexPath.item]
        if let color = colorHexValue.color {
            cell.backgroundColor = color
        }
        return cell
    }
}

//
//  RadioView.swift
//  AIC Utilities People
//
//  Created by toannt on 5/6/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

enum RadioCellMode {
    case choose
    case multipleSelect
}

class RadioView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: BaseCollectionView!
    
    private let spacingCell: CGFloat = 12
    
    var mode: RadioCellMode = .choose {
        didSet {
            collectionView.allowsMultipleSelection = mode == .multipleSelect
        }
    }
    
    var listData: [RadioItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        guard let view = UINib(nibName: "RadioView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        backgroundColor = .clear
        
        collectionView.registerNibCellFor(type: RadioCell.self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func getListSelected() -> [RadioItem] {
        return listData.filter(){ $0.state == true }
    }
}

extension RadioView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.reusableCell(type: RadioCell.self, indexPath: indexPath)!
        cell.mode = mode
        cell.radioItem = listData[indexPath.row]
        return cell
    }
}

extension RadioView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (bounds.width - spacingCell)/2, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingCell
    }
}

extension RadioView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mode == .choose {
            listData.forEach(){ $0.state = false }
        }
        listData[indexPath.row].state = !listData[indexPath.row].state
    }
}

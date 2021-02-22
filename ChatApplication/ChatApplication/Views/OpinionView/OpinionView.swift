//
//  OpinionView.swift
//  AIC Utilities People
//
//  Created by TiemLV on 6/10/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class OpinionView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var opinionValueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - View's life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetData()
    }
    
    private func setupUI() {
        guard let view = UINib(nibName: "OpinionView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        self.backgroundColor = .white
    }
    
    func bindingData(color: String, opinionValue: Int, name: String) {
        if let splitColor = color.split(separator: "#").first {
            self.colorView.backgroundColor = UIColor(String(splitColor))
        }
        self.opinionValueLabel.text = "\(opinionValue)"
        self.nameLabel.text = name
    }
    
    private func resetData() {
        colorView.backgroundColor = .clear
        opinionValueLabel.text = ""
        nameLabel.text = ""
    }
}

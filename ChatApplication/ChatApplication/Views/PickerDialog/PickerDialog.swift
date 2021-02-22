//
//  PickerDialog.swift
//  AIC Utilities People
//
//  Created by toannt on 5/10/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol PickerDialogDelegate: class {
    func didSelected(title: String)
}

class PickerDialog: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var csHeightDialog: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    
    // MARK: - Properties
    var listTitle: [String] = []
    var listData: [String] = [] {
        didSet {
            csHeightDialog.constant = CGFloat((listData.count + 2) * 50)
            tableView.reloadData()
        }
    }
    
    // MARK: - Delegates
    weak var delegate: PickerDialogDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listData = listTitle
        tableView.setup(input: self)
        tableView.registerCellClass(UITableViewCell.self)
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: - Actions
    @IBAction func pressClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            listData = listTitle.filter({ $0.localizedStandardContains(text) })
        }
    }
}

// MARK: - UITableViewDataSource
extension PickerDialog: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(type: UITableViewCell.self)!
        cell.textLabel?.text = listData[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PickerDialog: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            self.delegate?.didSelected(title: self.listData[indexPath.row])
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

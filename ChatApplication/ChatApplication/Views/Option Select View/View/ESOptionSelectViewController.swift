//
//  ESOptionSelectViewController.swift
//  E-Office
//
//  Created by VietHD-D3 on 4/8/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

class ESOptionSelectViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tbvOption: UITableView!
    @IBOutlet weak var tableViewHeighContraint: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    
    // MARK: - Properties
    var presenter = ESOptionSelectPresenter()
    let optionTableMinHeight = 168
    let optionTableMaxHeight = 280
    
    // MARK: - Closures
    var didSelectCompletion: (([Int]) -> ())?
    
    // MARK: - View's life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter.delegate = self
        setupTableview()
        setupUi()
    }
    
    func setupUi() {
        tfSearch.placeholder = "L10n.Optionselect.searchPlaceholder"
        refreshOptionTableView(updateTableHeigh: true)
    }
    
    func setupTableview() {
        tbvOption.register(ESOptionTableViewCell.nib(), forCellReuseIdentifier: ESOptionTableViewCell.name)
        tbvOption.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    @IBAction func onSearchTextFieldValueChanged(_ sender: Any) {
        presenter.filterOption(condition: (sender as! UITextField).text ?? "")
    }
    
    @IBAction func onFinishSelectButtonClicked(_ sender: Any) {
        let selectedItems = presenter.selectedItemIdList
        didSelectCompletion?(selectedItems)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onCloseButtonClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

// MARK: - UItableView Delegates
extension ESOptionSelectViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filterdItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ESOptionTableViewCell.name, for: indexPath) as! ESOptionTableViewCell
        let itemData = presenter.dataForCellAt(indexPath: indexPath)
        cell.setItemTitleAndSelectState(title: itemData.title, isSelected: itemData.isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ESOptionTableViewCell
        let itemData = presenter.toggleSelectionForItemAt(indexPath: indexPath)
        cell.setItemTitleAndSelectState(title: itemData.title, isSelected: itemData.isSelected )
        let selectedItems = presenter.selectedItemIdList
        didSelectCompletion?(selectedItems)
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension ESOptionSelectViewController : ESOptionSelectDelegate {
    func refreshOptionTableView(updateTableHeigh: Bool) {
        tbvOption.reloadData()
        if (updateTableHeigh) {
            let contentHeigh = tbvOption.contentSize.height
            tableViewHeighContraint.constant = min(CGFloat(optionTableMaxHeight), max(contentHeigh, CGFloat(optionTableMinHeight)))
            let optionCount = presenter.filterdItems.count
            tbvOption.bounces = optionCount > 5
        }
    }
}

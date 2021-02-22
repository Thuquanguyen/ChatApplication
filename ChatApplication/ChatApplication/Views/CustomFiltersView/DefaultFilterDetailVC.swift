//
//  DefaultFilterDetailVC.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol FilterDetailCellModeling {
    var title: String? { get }
}

class DataFilterDetail {
    var id: Int
    var selected = false
    var item: FilterDetailCellModeling?
    
    init(id: Int = -1, selected: Bool = false, item: FilterDetailCellModeling? = nil) {
        self.id = id
        self.selected = selected
        self.item = item
    }
}

class DefaultFilterDetailVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var headerView: DefaultFilterHeaderView!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var tfSearch: InsetTextField!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var constrainConfirm: NSLayoutConstraint!
    @IBOutlet weak var constrainSearch: NSLayoutConstraint!
    
    // MARK: - Properties
    private var dataOrignal: [DataFilterDetail] = []
    var filterCell: FilterCellModeling?
    var didPassFilterDetail:((_ filterCell: FilterCellModeling?) -> ())?
    var isMultiSelect: Bool = false
    var isShowAllAtTop: Bool = true
    private var mTime: Timer?
    let dataSource = TableDataSource<DataFilterDetail, DefaultFilterDropdownDetailTableViewCell>()
    var heightKeyboard: CGFloat = 0
    var heightView: CGFloat = 0
    var type: String?
    
    // MARK: - Closures
    var didSelectRow:((_ row: Int?) -> ())?
    
    // MARK: - ViewController's life cycles
    deinit {
        mTime?.invalidate()
        print("deinit DefaultFilterDetailVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataFilter()
        configSubviews()
        
         headerView.didPressCloseView = {[unowned self] in
            self.didPassFilterDetail?(self.filterCell)
            self.destroy()
        }
        
        if type == "gui_y_kien"
        {
            searchContainerView.isHidden = true
            viewConfirm.isHidden = true
            constrainSearch.constant = 0
            constrainConfirm.constant = 0
            headerView.lbRight.text = "Đặt lại"
            headerView.didPressRightButton = {[unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height  -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height += keyboardSize.height
        }
    }

    func setupDataFilter() {
        guard let item = filterCell else { return }
        let indexs = item.indexSelecteds
        dataOrignal.append(DataFilterDetail(selected: indexs.isEmpty))
        dataOrignal += item.arrItems.enumerated().map {i, it in DataFilterDetail(id: i, selected: indexs.contains(i), item: it)}
    }
    

    @objc func editingChangedTf() {
        mTime?.invalidate()
        mTime = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: false)
    }
    
    @objc func timerCallback() {
        if let text = tfSearch.text, !text.isEmpty {
            let lower = text.lowercased().replace(string: " ", with: "")
            let data = dataOrignal.filter {
                if let title = $0.item?.title {
                    return title.contains(text) || title.convertSpecialTextToNormalForSearching().contains(lower)
                }
                return false
            }
            labelWarning.isHidden = !data.isEmpty
            dataSource.setupData(data)
        } else {
            labelWarning.isHidden = true
            dataSource.setupData(dataOrignal)
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func acceptedAction(_ sender: UIButton) {
        filterCell?.indexSelecteds = dataOrignal.filter { $0.selected && $0.id >= 0 }.map { $0.id }
        didPassFilterDetail?(self.filterCell)
        destroy()
    }
}

extension DefaultFilterDetailVC: SubviewsConfiguable {
    func configSubviews() {
        tfSearch.addTarget(self, action: #selector(editingChangedTf), for: .editingChanged)
        headerView.iconClose = UIImage()
        headerView.title = filterCell?.title
        headerView.btnRight.isHidden = true
        
        
        dataSource.setupData(dataOrignal)
        tableView.setup(source: dataSource, registerNibCells: [DefaultFilterDropdownDetailTableViewCell.self])
        
        dataSource.bindingCell = {cell, data, row in cell.setupData(data) }
        dataSource.didSelectRowAt = {[unowned self]item, row in
            self.clickedItem(item: item, row: row)
        }
    }
    
    func clickedItem(item: DataFilterDetail, row: Int) {
        if isMultiSelect {
            dataOrignal[0].selected = false
            item.selected = true
        } else {
            dataOrignal.forEach { $0.selected = false }
            item.selected = true
            self.didSelectRow?(row - 1)
            if type == "gui_y_kien"
            {
                self.destroy()
            }
        }
        tableView.reloadData()
    }
}

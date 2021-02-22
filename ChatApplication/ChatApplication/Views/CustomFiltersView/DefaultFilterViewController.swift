//
//  DefaultFilterViewController.swift
//  AIC Utilities People
//
//  Created by TrungHD-D1 on 6/3/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import UIKit

protocol DefaultFilterViewControllerDelegate: class {
    func didSetFilter(filterCells: [FilterCellModeling])
    func didPressResetButton(filterCells:[FilterCellModeling]) -> [FilterCellModeling]?
    func didUpdateUI(_ index: Int)
    func rowChanged(_ row: Int, _ filterCells: [FilterCellModeling]) -> [FilterCellModeling]?
}

extension DefaultFilterViewControllerDelegate {
    func didPressResetButton(filterCells: [FilterCellModeling]) -> [FilterCellModeling]? {
        return nil
    }
    
    func didSetFilter(filterCells: [FilterCellModeling]) {
        
    }
    
    func didUpdateUI(_ index: Int) {
        
    }
    
    func rowChanged(_ row: Int, _ lilterCells: [FilterCellModeling]) -> [FilterCellModeling]? {
        return nil
    }
}

protocol FilterCellModeling {
    var title: String? { get set }
    var type: FilterType { get set }
    var optionType: FilterOptionType { get set }
    var arrItems: [FilterDetailCellModeling] { get set }
    var indexSelecteds: [Int] { get set }
}

enum FilterType {
    case rangeSeek
    case boxDropdown
    case twoOptions, fourOptions
    case tick
    case separator
}

enum FilterOptionType {
    case province, district, industry
    case level, state, branch
    case year, quarter
    case unknown
    case rangeSeek
    case time, fields
    case status
    case career
    case statusTranslate, extensionTranslate
    case publishAgency, separator
}

struct FilterCellBoxDropDown: FilterCellModeling {
    var indexSelecteds: [Int]
    var optionType: FilterOptionType
    var title: String?
    var type: FilterType
    var arrItems: [FilterDetailCellModeling] = []
    var hasDefaultCase: Bool
    
    init(indexSelecteds: [Int] = [],
         optionType: FilterOptionType,
         title: String?,
         type: FilterType,
         arrItems: [FilterDetailCellModeling] = [],
         maxValue: CGFloat? = nil,
         minValue: CGFloat? = nil,
         hasDefaulCase: Bool = true
    ) {
        self.indexSelecteds = indexSelecteds
        self.optionType = optionType
        self.title = title
        self.type = type
        self.arrItems = arrItems
        self.hasDefaultCase = hasDefaulCase
    }
    
}

struct FilterCellTick: FilterCellModeling {
    var arrItems: [FilterDetailCellModeling]
    var indexSelecteds: [Int]
    var optionType: FilterOptionType
    var title: String?
    var type: FilterType
    
    var icon: UIImage?
    var id: Int
}

struct FilterCellRangeSlider: FilterCellModeling {
    var title: String?
    var type: FilterType
    var optionType: FilterOptionType
    var arrItems: [FilterDetailCellModeling]
    var indexSelecteds: [Int]
    
    var maxValue: CGFloat
    var minValue: CGFloat
    var selectedMaxValue: CGFloat?
    var selectedMinValue: CGFloat?
}

class DefaultFilterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: DefaultFilterHeaderView!
    @IBOutlet weak var showResultButtonView: DefaultFilterShowResultButtonView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constraints
    @IBOutlet weak var constraintHeightBtnShowResult: NSLayoutConstraint!
    
    // MARK: - Properties
    var filterCells: [FilterCellModeling] = []
    var heightPresentView: CGFloat = 0
    
    // MARK: - Delegates
    weak var delegate: DefaultFilterViewControllerDelegate?
    
    // MARK: - ViewController's life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupAutolayoutForSubviews()
        addGestureForSubviews()
        configSubviews()
        
        headerView.didPressCloseView = {[unowned self] in
            self.dismisVC()
        }
        
        headerView.didPressRightButton = {[unowned self] in
            self.resetData()
            if let list = self.delegate?.didPressResetButton(filterCells: self.filterCells) {
                self.filterCells = list
            }
            self.tableView.reloadData()
        }
        
        showResultButtonView.didPressButton = {[unowned self] in
            self.checkInterNet()
        }
    }
    
    deinit {
        print("deinit DefaultFilterViewController")
    }
    
    func resetData() {
        for (index, value) in self.filterCells.enumerated() {
            var tamp = value
            
            if tamp.type == .fourOptions {
                // case four option --> touch reset button -->> set default index = 0 ( Tất cả )
                tamp.indexSelecteds = [0]
            } else {
                if tamp.type == .rangeSeek {
                    if var tmp = tamp as? FilterCellRangeSlider {
                        tmp.indexSelecteds = []
                        tmp.selectedMaxValue = nil
                        tmp.selectedMinValue = nil
                        tamp = tmp
                    }
                } else {
                    tamp.indexSelecteds = []
                }
            }
            
            self.filterCells[index] = tamp
        }
    }
    
    func loadData() {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc2 = self.navigationController?.presentationController as? BaseFilterVC {
            if vc2.heightPresentView != self.heightPresentView {
                vc2.updateHeightFilter = self.heightPresentView
            }
            
        }
    }
    func checkInterNet() {
        IndicatorViewer.show()
        if APIUtilities.hasInternet {
            IndicatorViewer.hide()
            self.delegate?.didSetFilter(filterCells: self.filterCells)
            destroy()
        } else {
            IndicatorViewer.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        let title = "alert_no_connection".localized
        let message = "alert_no_connection_try".localized
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "place_ratting_vote_try_again".localized, style: .default, handler: { _ in
            self.checkInterNet()
        } )
        let closeAction = UIAlertAction(title: "alert.default_login_close".localized, style: .default, handler: { _ in
            self.pop()
        })
        
        alertVC.addAction(retryAction)
        alertVC.addAction(closeAction)
        present(alertVC, animated: true, completion: nil)
    }
}


extension DefaultFilterViewController: SubviewsLayoutable {
    func addSubviews() {
        
    }
    
    func setupAutolayoutForSubviews() {
        
    }
    
    func addGestureForSubviews() {
        
    }
}


extension DefaultFilterViewController: SubviewsConfiguable {
    func configSubviews() {
        tableView.registerCellNib(DefaultFilterDropdownTableViewCell.self)
        tableView.registerCellNib(DefaultFilterOptionsTableViewCell.self)
        tableView.registerCellNib(DefaultFilterFourOptionsCell.self)
        tableView.registerCellNib(RangeSeekFillterCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension DefaultFilterViewController {
    func dismisVC() {
        dismiss(animated: true, completion: nil)
    }
}


extension DefaultFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let filterCell = filterCells[indexPath.row] as? FilterCellBoxDropDown {
            
            if filterCell.type == .boxDropdown {
                let cell = tableView.dequeueCell(with: DefaultFilterDropdownTableViewCell.self, for: indexPath)
                
                cell.title = filterCell.title
                
                var selectedIndex: Int?
                
                selectedIndex = filterCell.indexSelecteds.first
                
                if let index = selectedIndex {
                    cell.content = filterCell.arrItems[index].title
                } else {
                    if filterCell.hasDefaultCase == true {
                        cell.content = "economicreport_all".localized
                    } else {
                        cell.content = filterCell.arrItems[0].title
                    }
                }
                
                return cell
            }
            
            if filterCell.type == .twoOptions {
                let cell = tableView.dequeueCell(with: DefaultFilterOptionsTableViewCell.self, for: indexPath)
                
                cell.title = filterCell.title
                
                var selectedIndex: Int?
                
                selectedIndex = filterCell.indexSelecteds.first
                
                cell.resultOptionChange = {[unowned self] result in
                    for (index, value) in self.filterCells.enumerated() {
                        var tamp = value
                        if tamp.optionType == filterCell.optionType {
                            tamp.indexSelecteds = [result]
                        }
                        
                        self.filterCells[index] = tamp
                    }
                }
                
                if let index = selectedIndex {
                    cell.bindingData(filterCell.arrItems, index: index)
                } else {
                    cell.bindingData(filterCell.arrItems)
                }
                
                return cell
            }
            
            if filterCell.type == .fourOptions {
                
                let cell = tableView.dequeueCell(with: DefaultFilterFourOptionsCell.self, for: indexPath)
                
                cell.title = filterCell.title
                
                var selectedIndex: Int?
                
                selectedIndex = filterCell.indexSelecteds.first
                
                cell.resultOptionChange = {[unowned self] result in
                    for (index, value) in self.filterCells.enumerated() {
                        var tamp = value
                        if tamp.optionType == filterCell.optionType {
                            tamp.indexSelecteds = [result]
                        }
                        
                        self.filterCells[index] = tamp
                    }
                }
                
                if let index = selectedIndex {
                    cell.bindingData(filterCell.arrItems, index: index)
                } else {
                    cell.bindingData(filterCell.arrItems)
                }
                
                return cell
            }
        } else if var filterCell = filterCells[indexPath.row] as? FilterCellRangeSlider {
            if filterCell.type == .rangeSeek {
                let cell = tableView.dequeueCell(with: RangeSeekFillterCell.self, for: indexPath)
                cell.setDataRangeSlider(minValue: filterCell.minValue, maxValue: filterCell.maxValue, title: filterCell.title, selectedMinValue: filterCell.selectedMinValue, selectedMaxValue: filterCell.selectedMaxValue)
                cell.resultOptionChange = { (min,max) in
                    filterCell.selectedMinValue = min
                    filterCell.selectedMaxValue = max
                    self.filterCells[indexPath.row] = filterCell
                }
                return cell
            }
        }
        
        let cell = tableView.dequeueCell(with: DefaultFilterDropdownTableViewCell.self, for: indexPath)
        
        return cell
    }
}

extension DefaultFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterCell = self.filterCells[indexPath.row]
        if filterCell.type == .boxDropdown {
            self.openDefaultFilterDetailVC(row: indexPath.row, filterCell: filterCell)
        }
    }
}


extension DefaultFilterViewController {
    func openDefaultFilterDetailVC(row: Int, filterCell: FilterCellModeling) {
        let vc = DefaultFilterDetailVC()
        vc.filterCell = filterCell
        let indexSelected = filterCell.indexSelecteds.first
        vc.didPassFilterDetail = {[unowned self] returnFilterCell in
            if let returnFilterCell = returnFilterCell {
                if returnFilterCell.indexSelecteds.first != indexSelected {
                    self.filterCells[row] = returnFilterCell
//                    if let newValues = self.delegate?.rowChanged(row, self.filterCells) {
//                        self.filterCells = newValues
//                    }
                    self.tableView.reloadData()
                }
            }
        }
        if let vc2 = self.navigationController?.presentationController as? BaseFilterVC {
            vc2.updateHeightFilter = ScreenUtils.screenHeight - ScreenUtils.statusBarHeight
        }
        VCService.push(controller: vc, fromController: self, prepare: nil, animated: false, completion: nil)
    }
}

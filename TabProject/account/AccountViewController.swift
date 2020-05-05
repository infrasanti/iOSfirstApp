//
//  AccountViewController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 02/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    fileprivate let viewModel = ProfileViewModel()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = viewModel
        tableView.allowsSelection = false

        tableView.register(TestViewCell.nib, forCellReuseIdentifier: TestViewCell.identifier)
        tableView.register(SimpleViewCell.nib, forCellReuseIdentifier: SimpleViewCell.identifier)
        tableView.register(DoubleViewCell.nib, forCellReuseIdentifier: DoubleViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

    }
    

}

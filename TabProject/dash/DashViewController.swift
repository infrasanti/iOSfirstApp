//
//  DashViewController.swift
//  TabProject
//
//  Created by Santiago Ramirez on 29/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class DashViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {

    private static let animDuration: TimeInterval = 0.5
    private let weatherApi: WeatherApi = WeatherApi()
    private var items = [CityData]()
    @IBOutlet var cityDetailsView: CityDetailsView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var expandButton: UIButton!
    @IBOutlet var bottomPanel: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var expandedConstrain: NSLayoutConstraint!
    
    private var expanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        HorizontalCityViewCell.register(tableView: tableView)
        tableView.dataSource = self
        tableView.allowsSelection = false
        expandButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapExpandButton(_:))))
        requestData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func tapExpandButton(_ sender: UITapGestureRecognizer?) {
          if (expanded) {
              expanded = false
            
            UIView.animate(withDuration: DashViewController.animDuration, animations: {
                self.collectionView.alpha = 1
                self.tableView.alpha = 0
                self.expandedConstrain.priority = UILayoutPriority(rawValue: 250)
                self.view.layoutIfNeeded()
            }, completion: {
                if ($0) {
                    self.expandButton.setTitle("show all", for: .normal)
                }
            })
              
          } else {
            expanded = true
            UIView.animate(withDuration: DashViewController.animDuration, animations: {
                self.collectionView.alpha = 0
                self.tableView.alpha = 1
                self.expandedConstrain.priority = UILayoutPriority(rawValue: 1000)
                self.view.layoutIfNeeded()
            }, completion: {
                if ($0) {
                    self.expandButton.setTitle("close", for: .normal)
                }
            })
          }
    }
    
    @objc func tapCity(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)

        if let index = indexPath {
            onCitySelected(index.row)
        }
    }
    
    @objc func tapHorizontalCity(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: location)
        tapExpandButton(nil)
        if let index = indexPath {
            onCitySelected(index.row)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as? CityViewCell {
            cell.setCity(items[indexPath.row])
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCity(_:))))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalCityViewCell.reuseIdentifier, for: indexPath) as? HorizontalCityViewCell {
            cell.setCity(items[indexPath.row])
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHorizontalCity(_:))))
            return cell
        }
        return UITableViewCell()
    }
    
    private func onCitySelected(_ index: Int) {
        let city = items[index]
        view.backgroundColor = city.icon.getColor()
        bottomPanel.backgroundColor = city.icon.getColor()
        cityDetailsView.setCity(city)
    }
    
    private func onCitiesReady(_ cities: [City]) {
        items = cities.map {CityData(city: $0)}
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
            if (!self.items.isEmpty) {
                self.onCitySelected(0)
            }
        }
    }
    
    private func onError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func requestData() {
        
        weatherApi.request() { (response, error) -> Void in
            if let cities = response?.list {
                self.onCitiesReady(cities)
            } else if let error = error {
                self.onError(error)
            }
        }
    }
}

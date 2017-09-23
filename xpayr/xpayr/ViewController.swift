//
//  ViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import SwipeCellKit

class ViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var addButton: UIBarButtonItem!

    // MARK: - Properties
    var items: [Item]?
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.item = items?[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.remove(at: indexPath.row)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }

    // TODO: (dunyakirkali) Move to presenter
    public func add(item: Item) {
        self.items?.append(item)
        saveData()
    }

    // TODO: (dunyakirkali) Move to presenter
    public func remove(at: Int) {
        self.items?.remove(at: at)
        saveData()
        tableView.reloadData()
    }

    // TODO: (dunyakirkali) Move to presenter
    private func saveData() {
        NSKeyedArchiver.archiveRootObject(self.items ?? [], toFile: filePath)
    }

    // TODO: (dunyakirkali) Move to presenter
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
            items = ourData
        } else {
            items = [Item]()
        }
    }
}


//
//  ViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import SwipeCellKit
import Disk

class ViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var addButton: UIBarButtonItem!

    // MARK: - Properties
    var items: [Item]?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        reloadWithAnimation()
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tCell = cell as! ItemCell
        tCell.delegate = self
        tCell.item = items?[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
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
        reloadWithAnimation()
    }
    
    private func reloadWithAnimation() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }

    // TODO: (dunyakirkali) Move to presenter
    private func saveData() {
        do {
            try Disk.save(items, to: .documents, as: "items.json")
        } catch {
            print("Could not save data")
        }
    }

    // TODO: (dunyakirkali) Move to presenter
    private func loadData() {
        do {
            items = try Disk.retrieve("items.json", from: .documents, as: [Item].self)
        } catch {
            items = [Item]()
        }
    }
}


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
import UserNotifications

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "toForm", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.remove(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC: CreationViewController = segue.destination as! CreationViewController

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            destVC.item = self.items?[selectedIndexPath.row]
        } else {
            destVC.item = Item(name: "", imagePath: nil, expirationDate: Date())
        }
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let sourceViewController = sender.source as? CreationViewController, let item = sourceViewController.item {
                self.update(item: item, at: selectedIndexPath)
            }
        } else {
            if let sourceViewController = sender.source as? CreationViewController, let item = sourceViewController.item {
                let newIndexPath = IndexPath(row: items!.count, section: 0)
                self.add(item: item, at: newIndexPath)
            }
        }
    }
    
    // TODO: (dunyakirkali) Move to presenter
    private func update(item: Item, at: IndexPath) {
        self.items?[at.row] = item
        tableView.reloadRows(at: [at], with: .none)
        saveData()
    }
    
    // TODO: (dunyakirkali) Move to presenter
    private func add(item: Item, at: IndexPath) {
        self.items?.append(item)
        tableView.insertRows(at: [at], with: .automatic)
        prepareNotification(for: item)
        saveData()
    }

    // TODO: (dunyakirkali) Move to presenter
    public func remove(at: IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Sure?", preferredStyle: .actionSheet)
        let cell = self.tableView.cellForRow(at: at) as! SwipeTableViewCell
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            cell.hideSwipe(animated: true)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            cell.hideSwipe(animated: true)
            self.items?.remove(at: at.row)
            self.tableView.deleteRows(at: [at], with: .fade)
            self.saveData()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
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
    
    private func prepareNotification(for item: Item) {
        let content: UNNotificationContent = item.notificationContent
        let date = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
}


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
import Lottie
import Crashlytics

class ViewController: UITableViewController, SwipeTableViewCellDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var addButton: UIBarButtonItem!

    // MARK: - Properties
    var items: [Item] = [Item]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loadData), name: NSNotification.Name(rawValue: "ShouldRefresh"), object: nil)

        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        loadData()
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            let animationView = LOTAnimationView(name: "empty_box")
            animationView.contentMode = .scaleAspectFit
            animationView.loopAnimation = true
            animationView.play()
            tableView.backgroundView = animationView
        } else {
            tableView.backgroundView = nil
        }
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tCell = cell as! ItemCell
        tCell.delegate = self
        tCell.item = items[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toForm", sender: self)
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
            destVC.item = self.items[selectedIndexPath.row]
        } else {
            destVC.item = Item(name: "", imagePath: nil, expirationDate: Date(), UUID: UUID().uuidString)
        }
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let sourceViewController = sender.source as? CreationViewController, let item = sourceViewController.item {
                self.update(item: item, at: selectedIndexPath)
            }
        } else {
            if let sourceViewController = sender.source as? CreationViewController, let item = sourceViewController.item {
                let newIndexPath = IndexPath(row: items.count, section: 0)
                self.add(item: item, at: newIndexPath)
            }
        }
    }
    
    // TODO: (dunyakirkali) Move to presenter
    private func update(item: Item, at: IndexPath) {

        removeNotification(for: item)
        prepareNotification(for: item)

        self.items[at.row] = item
        tableView.reloadRows(at: [at], with: .none)

        saveData()
    }
    
    // TODO: (dunyakirkali) Move to presenter
    private func add(item: Item, at: IndexPath) {
        self.items.append(item)
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
        
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { action in
            cell.hideSwipe(animated: true)
            let item = self.items[at.row]
            self.removeNotification(for: item)
            self.items.remove(at: at.row)
            self.tableView.deleteRows(at: [at], with: .fade)
            guard let imgPath = item.imagePath else { return }
            
            do {
                try Disk.remove(imgPath, from: .documents)
            } catch let error {
                Crashlytics.sharedInstance().recordError(error)
            }
            self.saveData()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
    }
    
    // TODO: (dunyakirkali) Move to presenter
    private func saveData() {
        do {
            try Disk.save(items, to: .documents, as: "items.json")
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    // TODO: (dunyakirkali) Move to presenter
    @objc private func loadData() {
        do {
            items = try Disk.retrieve("items.json", from: .documents, as: [Item].self).sorted(by: {(left: Item, right: Item) -> Bool in
                (left.expirationDate.compare(right.expirationDate) == .orderedAscending)
            })
        } catch {
            items = [Item]()
        }
        tableView.reloadData()
    }

    private func removeNotification(for item: Item) {
        if item.hasExpired { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.UUID])
    }

    private func prepareNotification(for item: Item) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        do {
           let imageURL = try? Disk.getURL(for: "Album/\(item.UUID)", in: .documents)
            if (imageURL != nil) {
                let attachment = try? UNNotificationAttachment(identifier: "image", url: imageURL!, options: [:])
                content.attachments = [attachment!]
            }
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
        }

        content.title = item.notificationTitle
        content.body = item.notificationBody
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "ItemCategory"

        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: item.expirationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: item.UUID, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
}


//
//  NoMatchesListTableVC.swift
//  GlowMe
//
//  Created by chaithra Kumar on 3/29/17.
//  Copyright © 2017 Henry Mason. All rights reserved.
//

import UIKit

class NoMatchesListTableVC: UITableViewController {
    
    var listArray:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissMe))
        self.clearsSelectionOnViewWillAppear = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: "NOMATCHES") as? Data
        if decoded != nil {
            let favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [String]
            if favoritesArray.count > 0 {
                print(favoritesArray.count)
                self.listArray = favoritesArray
                self.tableView.reloadData()
            }
        }
        
    }
    
    func dismissMe () {
        self.dismiss(animated: true, completion: {
            //self.assetResultsarray.removeAll()
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
          return listArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.contentView.backgroundColor = UIColor.black
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = listArray[indexPath.row]
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listArray.remove(at: indexPath.row)

            let userDefaults = UserDefaults.standard
            let decoded  = userDefaults.object(forKey: "NOMATCHES") as? Data
//            if decoded != nil {
//                let favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [String]
//                if favoritesArray.count > 0 {
//                    print(favoritesArray.count)
//                    self.listArray = favoritesArray
//                    self.tableView.reloadData()
//                }
//            }

            
            
            
            
            if decoded != nil {
                var favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? [String]
                if (favoritesArray?.count)! > 0 {
                    favoritesArray?.remove(at: indexPath.row)
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                    userDefaults.set(encodedData, forKey: "NOMATCHES")
                    userDefaults.synchronize()
                    
                }   else {
                    userDefaults.set(nil, forKey: "NOMATCHES")
                    userDefaults.synchronize()
                    
                }
            }
            
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

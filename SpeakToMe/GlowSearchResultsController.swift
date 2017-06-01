//
//  GlowSearchResultsController.swift
//  GlowMe
//
//  Created by Chaithra Kumar on 3/12/17.
//  Copyright © 2017 Henry Mason. All rights reserved.
//

import UIKit

class GlowSearchResultsController: UITableViewController {
    
    
     var assetResultsarray = Array<Asset>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.clear
       self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationController?.navigationBar.tintColor = UIColor.black
       let  cellnib = UINib.init(nibName: "ContentListCell", bundle: nil)
       self.tableView.register(cellnib, forCellReuseIdentifier: "listcell")
     
        self.title = "RESULTS";
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissMe))
        
        

    }
    
    
    func dismissMe () {
        self.dismiss(animated: true, completion: {
        self.assetResultsarray.removeAll()
        
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
        return self.assetResultsarray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 108
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath)  as? ContentListCell
        
        let assetObj =  self.assetResultsarray[indexPath.row]
        
        if let title = assetObj.title {
            cell?.titleLable.text  = title
            
        }
        
        if let genretext = assetObj.genre {
             cell?.genreLabel.text = "Genre:\(genretext)"
        }
        
        if let typetext = assetObj.type {
             cell?.TypeLabel.text = typetext.capitalized
            
        }
        
        if let servicesText = assetObj.services {
            
            cell?.serviceLabel.text = "Available on:\(servicesText)"
        }
        
        
        
        
        // Configure the cell...

        return cell!
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

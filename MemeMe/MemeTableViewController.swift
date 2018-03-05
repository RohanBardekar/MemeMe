//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Rohan Bardekar on 05/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//
import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    // MARK: Count Memes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    // MARK: Meme Data Storage
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Dequeue cell for reuse of each meme
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.topText?.text = meme.topText
        cell.bottomText?.text = meme.bottomText
        cell.memedImage?.image = meme.memedImage
        
        return cell
    }
    
    // MARK: Show Meme Data Storage
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.memes = memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }

}

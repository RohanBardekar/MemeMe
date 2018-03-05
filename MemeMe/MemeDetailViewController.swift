//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Rohan Bardekar on 05/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//
import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memedImage: UIImageView!
    
    //memes of Struct Meme type
    var memes: Meme!
    
    // MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        memedImage.image = memes.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Action Button Dismiss View
    @IBAction func share(_ sender: Any) {
        
        let activityViewController = UIActivityViewController(activityItems: [memes.memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            
            if completed == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
       
        present(activityViewController, animated: true, completion: nil)
    }
}

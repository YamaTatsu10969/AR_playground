//
//  CollectionViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/16.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backCollectButton(_ sender: Any) {
        self.performSegue(withIdentifier: "collectSegue", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

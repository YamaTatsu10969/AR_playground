//
//  CollectionViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/16.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
        returnButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        // Do any additional setup after loading the view.
    }

    
    
    @IBOutlet weak var marioImage: UIImageView!
    @IBOutlet weak var captainFalconImage: UIImageView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var luigiImage: UIImageView!
    
    func setImage(){
        if marioGetFlag == 1 {
            marioImage.image = UIImage(named: "mario_result")
        }
        if luigiGetFlag == 1 {
            luigiImage.image = UIImage(named: "luigi_result")
        }
        if linkGetFlag == 1 {
            linkImage.image = UIImage(named: "link_result")
        }
        if captainFalconGetFlag == 1 {
            captainFalconImage.image = UIImage(named: "captainFalcon_result")
        }
    }
    
    
    @IBAction func goBackCollecting(_ sender: Any) {
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

//
//  TitleDescriptionViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/17.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class TitleDescriptionViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 20.0
        descriptionLabel.layer.cornerRadius = 1.0
        //表示可能最大行数を指定
        descriptionLabel.numberOfLines = 5
        //contentsのサイズに合わせてobujectのサイズを変える
        descriptionLabel.sizeToFit()
        
        //LineSpaceStyle.lineSpacing = 20.0
        
        descriptionLabel.text = "1. 散らばった仲間を見つけ出そう！\n    地球の周りに捕まった仲間のヒントがあるぞ\n2. 下のタブと一致した画像を見つけよう！\n3. 全ての仲間を助け出そう！\n    地球の周りに捕まった仲間のヒントがあるぞ"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchedButton(_ sender: Any) {
        performSegue(withIdentifier: "gameStartSegue", sender: self)
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

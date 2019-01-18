//
//  marioViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/14.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MarioViewController: UIViewController, ARSCNViewDelegate  {
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var changeViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.changeViewButton.isHidden = true
        
        changeViewButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
    }
    
    @IBAction func changeViewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toMarioGet", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources-mario", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Images...")
        }
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            //認識した画像に薄く青をつける
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            //マリオを立たせる
            if let marioScene = SCNScene(named: "art.scnassets/Mario/mario.scn") {
                
                if let marioNode = marioScene.rootNode.childNodes.first {
                    //画像の前に立つように
                    marioNode.eulerAngles.x = .pi / 8
                    //自分の方を向くように
                    marioNode.eulerAngles.z = .pi / 3 / 4
                    planeNode.addChildNode(marioNode)
                    
                    //5秒経ったらボタンを表示
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.changeViewButton.isHidden = false
                        marioGetFlag = 1
                    }
                }
            }
        }
        return node
    }
    
    func changeView() {                                                                //
        self.performSegue(withIdentifier: "toMarioGet", sender: nil)                        //
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

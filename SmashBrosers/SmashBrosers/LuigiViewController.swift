//
//  LuigiViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/16.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class LuigiViewController: UIViewController, ARSCNViewDelegate  {
    
    
   
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources-luigi", bundle: Bundle.main) {
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
            if let luigiScene = SCNScene(named: "art.scnassets/Luigi/luigi.obj") {
                
                if let luigiNode = luigiScene.rootNode.childNodes.first {
                    //画像に立つように
                    luigiNode.eulerAngles.x = .pi / 2
                    //自分の方を向くように
                    luigiNode.eulerAngles.z = .pi / 3 / 4
                    planeNode.addChildNode(luigiNode)
                    //5秒経ったら画面を遷移させる
                    //                    var timer:Timer = Timer()
                    //                    timer = Timer.scheduledTimer(timeInterval: 5.0,
                    //                                                                   target: self,
                    //                                                                   selector: Selector("changeView"),
                    //                                                                   userInfo: nil,
                    //                                                                   repeats: false)
                }
            }
        }
        return node
    }
    
    func changeView() {                                                                //
        self.performSegue(withIdentifier: "toGetLuigi", sender: nil)                        //
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

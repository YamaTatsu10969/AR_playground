# AR_playground

#完成品　「大捜査スマッシュブラザーズ」
![smashBrothersAR.gif](https://qiita-image-store.s3.amazonaws.com/0/326574/c4d75f9e-ca29-487e-d809-7d1a2d3fc321.gif)

# はじめに
やっと作品を作ることができたので備忘録として、作品として記録するために、本記事を書いております！(本作品はSwift始めて1.5ヶ月目に2週間もかけて作成しました。)
アウトプットがとても大切だということを多くの先輩エンジニアがおっしゃっているので、
これからアウトプットしていきます。

面白そうと思っていただけたらぜひいいねを押していただけたらと思います！

## 今回参考にした記事
タイトルがとても面白い上にとても参考になりました。
非常にありがたかったです。
「休日2日を生け贄に青眼の白龍を召喚！」　＠shunp さん
https://qiita.com/shunp/items/4289660b912d90536ece
## 技術・環境
Xcode Version 10.1 (10B61)
Swift 4.2
iOS 12.1

## 概要
・オブジェクトをどのように表示しているか
・画像認識について
・ゲーム性
について記述させていただきます。

## Xcodeの準備
プロジェクトを作成するときは、必ず「Argmented Reality App」を選択して始めましょう。
![スクリーンショット 2019-02-17 16.33.58.png](https://qiita-image-store.s3.amazonaws.com/0/326574/53baa2bb-e795-e9a9-53b5-b597ce790b5e.png)

## 3Dオブジェクトの用意
上記で紹介させていただいた記事と同様に、３Dオブジェクトを以下のサイトからダウンロードします。
表示させたいモデルの画面に行き、Download this Model をクリックするとダウンロードできます。
https://www.models-resource.com/nintendo_64/supersmashbros/

ダウンロードができたら以下のようにして、ファイルを Xcode に入れましょう。
Ship.scn があるところです。
![スクリーンショット 2019-02-17 16.27.36.png](https://qiita-image-store.s3.amazonaws.com/0/326574/32926d1c-0d0f-dd29-e16e-2ad5d0b7244f.png)

mario.obj ファイルを選択し、下の画像のようにマリオが表示されていたら成功です。
表示されていなかったら、mario.obj を選択し、上のツールバーから Editor → Convert to SceneKit scene file format(.scn)を押して、.scnファイルに変換してください。
それでもうまく表示されなかったら、諦めて他のキャラクターをダウンロードしましょう！
ちなみに私はヨッシーが表示できませんでした。。。
![スクリーンショット 2019-02-17 16.40.31.png](https://qiita-image-store.s3.amazonaws.com/0/326574/7c1854a2-8013-d21a-7d5b-179b8a684b1d.png)

## 画像認識に利用する画像をプロジェクトに入れる。
assets.xcassets の中で、右クリックをし、New AR Resource Groupを選択し、そこに画像認識したい画像を入れると準備OKです！

私は複数の画像を読み込ませたいので、標準では「AR Resource」の名前のものを
「AR Resource-mario」と名前を変更いたしました。

![スクリーンショット 2019-02-17 16.46.29.png](https://qiita-image-store.s3.amazonaws.com/0/326574/aef539dd-9ea7-c9f8-ab58-cc5b6146bc8c.png)


## 画像認識させて、マリオを表示させる

以下がマリオ探索＋表示用のViewControllerの全文です！
コメントアウトにて解説を入れております。

```swift:marioViewController.swift
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
　　　　 //　画面遷移のボタンを隠す
        self.changeViewButton.isHidden = true
        changeViewButton.layer.cornerRadius = 10.0 // ボタンの角丸のサイズ
    }
    // ボタンを押したらViewが変わる
    @IBAction func changeViewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toMarioGet", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration 名前の通り、画像をトラッキングしてくれるインスタンスを作成
        let configuration = ARImageTrackingConfiguration()
        // AR Resources-mario に入れた画像を上の行で作ったconfiguration に入れて、何枚まで画像を読み込むかを指定している。
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources-mario", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session　インスタンスをSceneViewに入れて Run している
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // 画像認識をするメソッド　
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            //認識した画像に薄く青をつける
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            //マリオのオブジェクトを読み込ませる。
            if let marioScene = SCNScene(named: "art.scnassets/Mario/mario.scn") {
                // マリオのオブジェクトが持つ位置情報を、marioNodeに入れる
                if let marioNode = marioScene.rootNode.childNodes.first {
                    //画像の前に立つように角度を調整
                    marioNode.eulerAngles.x = .pi / 8
                    //自分の方を向くように角度を調整
                    marioNode.eulerAngles.z = .pi / 3 / 4
                    //planeの位置情報にmarioの位置情報を入れ、画像の上にマリオオブジェクトを表示。
                    planeNode.addChildNode(marioNode)
                    //5秒経ったら下に遷移用のボタンを表示
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.changeViewButton.isHidden = false
                        marioGetFlag = 1
                    }
                }
            }
        }
        return node
    }
    // 結果画面への遷移
    func changeView() {                                                                //
        self.performSegue(withIdentifier: "toMarioGet", sender: nil)                        //
    }
}

```

sceneViewをviewControllerに配置し、コードにsceneViewを紐付けておく必要があります。
(画像を載せたかったのですが、最初の投稿なので、投稿の画像の制限が２Mらしいです。。。ここの画像は割愛させていただきます。)

####ここまできたら、画像を見つけたら、マリオが出てくる！！！:v:
![marioAR.gif](https://qiita-image-store.s3.amazonaws.com/0/326574/1c8867ee-20e1-20cc-1f30-adcd65db9270.gif)

##ゲーム性について
最初のGIFをみてもらうとわかる通り、４つの画像を見つけるとクリアできる仕様にしています！
グローバル関数として、marioGetFlag,linkGetFlag....etc を地球が回っている画面のViewControllerに持たせています。
画像を読み込んだらフラグを立てて、地球儀の周りのモデルを消したり、結果画面の画像を表示したりできました！

ちなみに、最初の「大捜査スマッシュブラザーズ」のロゴは手作りで story.board上で作成しています。
このロゴを作るためにStackViewを駆使して、1時間ほどかけて作成しました。笑

##ここまでの道のり
Javaで業務システムの保守運用を行なっていますがほぼコードを書きません。（システムについては理解が深まりました）
あまりプログラミングが上達している実感もなく、自分のプロダクトを作り、上達したいと強く思うようになりました。
そこで、独学 + G's AcademyというスクールでSwiftを学んでいます。
スクールに入って2.5ヶ月でやっと１つのプロダクトを作成できたと思っております。
プログラミングは何回も挫折仕掛けましたが、コードを書いていて楽しいとやっと思えるようになりました！:relaxed:

##最後に
初めての投稿なので分かりにくい点が多々あると思います。
コードの書き方もおかしいところもあると思います。
お気付きのところがあればぜひアドバイスください！！！

コードをレビューしていただくことがほとんどないので、
このようにアウトプットして、 皆さんのレビューをいただければと思っております。

最後までお読みいただきありがとうございました！




# Completed item "Major Investigation Smash Brothers"
[smashBrothersAR.gif] (https://qiita-image-store.s3.amazonaws.com/0/326574/c4d75f9e-ca29-487e-d809-7d1a2d3fc321.gif)

# Introduction
Since I could finally make a work, I wrote this article to record it as a work as a memorandum! (This work has been created in Swift for 1.5 weeks and 2 weeks.)
As many senior engineers say that output is very important,
I will continue to output.

If you think it would be interesting, I would like to press a good one!

# # An article I referenced this time
The title was very interesting and very helpful.
I was very grateful.
"Summon the Blue-eyed White Dragon to Sacrifice Holiday 2nd!" @Shunp
https://qiita.com/shunp/items/4289660b912d90536ece
## Technology / Environment
Xcode Version 10.1 (10B61)
Swift 4.2
iOS 12.1

## Overview
・ How is the object displayed?
・ About image recognition
・ Game nature
I will write about it.

## Preparation of Xcode
When creating a project, be sure to select "Armented Reality App" to start.
[Screenshot 2019-02-17 16.33.58.png] (https://qiita-image-store.s3.amazonaws.com/0/326574/53baa2bb-e795-e9a9-53b5-b597ce790b5e.png)

## Preparation of 3D objects
Download the 3D object from the following site as well as the article introduced above.
You can download it by going to the screen of the model you want to display and clicking Download this Model.
https://www.models-resource.com/nintendo_64/supersmashbros/

After downloading, put the file into Xcode as follows.
It is where Ship.scn is located.
[Screenshot 2019-02-17 16.27.36.png] (https://qiita-image-stor.3.amazonaws.com/0/326574/32926d1c-0d0f-dd29-e16e-2ad5d0b7244f.png)

If you select the mario.obj file and you see Mario like the image below, it is a success.
If it is not displayed, select mario.obj, and convert it into an .scn file by pressing Editor-> Convert to SceneKit scene file format (.scn) from the toolbar above.
If you still do not see well, let's give up and download other characters!
By the way, I could not display Yoshi. . .
[Screenshot 2019-02-17 16.40.31.png] (https://qiita-image-store.s3.amazonaws.com/0/326574/7c1854a2-8013-d21a-7d5b-179b8a684b1d.png)

## Add an image to be used for image recognition in the project.
Right-click in assets.xcassets, select New AR Resource Group, insert the image you want to recognize the image in it, and you are ready!

I want to load multiple images, so by default the one named "AR Resource"
The name has been changed to "AR Resource-mario".

[Screenshot 2019-02-17 16.46.29.png] (https://qiita-image-stor.3.amazonaws.com/0/326574/aef539dd-9ea7-c9f8-ab58-cc5b6146bc8c.png)


# # Recognize the image and display Mario

Below is the full text of ViewController for Mario Search + Display!
Comment is put in the comment out.

```
swift: marioViewController.swift

import UIKit
import SceneKit
import ARKit

class MarioViewController: UIViewController, ARSCNViewDelegate {
    
    @ IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var changeViewButton: UIButton!
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
// hide the screen transition button
        self.changeViewButton.isHidden = true
        changeViewButton.layer.cornerRadius = 10.0 // size of the corner of the button
    }
    // View changes when button is pressed
    @ IBAction func changeViewButton (_ sender: Any) {
        self.performSegue (withIdentifier: "toMarioGet", sender: nil)
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear (animated)
        
        // Create a session configuration As the name suggests, create an instance that will track the image
        let configuration = ARImageTrackingConfiguration ()
        // The images placed in AR Resources-mario are placed in the configuration created in the above line, and it is specified how many images are read.
        if let imageToTrack = ARReferenceImage.referenceImages (inGroupNamed: "AR Resources-mario", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session instance into SceneView
        sceneView.session.run (configuration)
    }
    
    override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear (animated)
        
        // Pause the view's session
        sceneView.session.pause ()
    }
    
    // Method for image recognition
    func renderer (_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor)-> SCNNode? {
        let node = SCNNode ()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            // Add light blue to the recognized image
            let plane = SCNPlane (width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial? .diffuse.contents = UIColor (red: 0, green: 0, blue: 1.0, alpha: 0.5)
            let planeNode = SCNNode (geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode (planeNode)
            
            // Load Mario object.
            if let marioScene = SCNScene (named: "art. scnassets / Mario / mario.scn") {
                // Put the position information of the Mario object into marioNode
                if let marioNode = marioScene.rootNode.childNodes.first {
                    // Adjust the angle to stand in front of the image
                    marioNode.eulerAngles.x = .pi / 8
                    // Adjust the angle to face yourself
                    marioNode.eulerAngles.z = .pi / 3/4
                    // put the mario position information in the plane position information, and display the Mario object on the image.
                    planeNode.addChildNode (marioNode)
                    After 5 seconds, display transition button below
                    DispatchQueue.main.asyncAfter (deadline: .now () + 5.0) {
                        self.changeViewButton.isHidden = false
                        marioGetFlag = 1
                    }}
            }
        }
        return node
    }
    // Transition to result screen
    func changeView () {//
        self.performSegue (withIdentifier: "toMarioGet", sender: nil) //
    }
}

```

You need to place sceneView in viewController and attach code to sceneView.
(I wanted to put an image, but because it is the first post, the limit of the image of the post seems to be 2 M. ... The image here will be omitted.)

# # # # If you come here, Mario will come out when you find the image! ! ! : v:
[marioAR.gif] (https://qiita-image-store.s3.amazonaws.com/0/326574/1c8867ee-20e1-20cc-1f30-adcd65db9270.gif)

# # About the game nature
As you can see from the first GIF, it has specifications that can be cleared by finding four images!
We have marioGetFlag, linkGetFlag .... etc as a global function in ViewController of the screen on which the earth is turning.
After loading the image, I could set the flag, erase the model around the globe, or show the image of the result screen!

By the way, the logo of the first "Major Smash Bros." is handmade and created on story.board.
It took about an hour to create this logo using StackView. Lol

# # The way to here
I am doing maintenance operation of the business system with Java and write almost no code. (The system was better understood)
I didn't really feel that I was proficient in programming, so I made a strong desire to make and improve my own products.
So I'm learning Swift at a school called Self Education + G's Academy.
I think that I was able to finally create one product in 2.5 months after entering the school.
Programming has been frustrated a number of times, but writing code has finally made it seem fun! : relaxed:

##Finally
I think that there are a lot of confusing points because it is the first post.
I think there are some strange ways to write code.
Please advise if you find something! ! !

There is almost no need to review the code.
I hope this output and your review.

Until the end Thank you for reading!

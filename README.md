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

//
//  ViewController.swift
//  Quiz Game
//
//  Created by Johannes Ruof on 13/11/2016.
//  Copyright © 2016 Rume Academy. All rights reserved.
//

import UIKit
import AVFoundation
import FacebookLogin
import FBSDKLoginKit
import Google
import GoogleSignIn
import Social

var backgroundMusicPlayer: AVAudioPlayer = AVAudioPlayer()
var wrongMusicPlayer: AVAudioPlayer = AVAudioPlayer()
var correctMusicPlayer: AVAudioPlayer = AVAudioPlayer()

class MenuViewController: UIViewController {
    
    //facebook sign up button
    var dict : [String : AnyObject]!
    private let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    
//    //google sign up button
//    private let googleSignInButton = GIDSignInButton()
    
    //quiz game views
    private let loginView = UIView()
    private let loginImageView = UIImageView()
    private let contentView = UIView()
    private let logoView = UIImageView()
    private let goToQuizButton = UIButton()
    private let buttonView = UIView()
    private var gameButtons = [RoundedButton]()
    private let scoreView = UIView()
    private let titleLabel = UILabel()
    private let recentScoreLabel = UILabel()
    private let highscoreLabel = UILabel()
   // @IBOutlet weak var labelUserEmail:UILabel!
    
    private let titles = [
        "Multiple Choice",
        "Image Quiz",
        "Right or Wrong",
        //"Emoji Riddle"
    ]
    
    private var recentScores = [Int]()
    private var highscores = [Int]()
    private var scoreIndex = 0
    private var timer = Timer()
    
    private var midXConstraints: [NSLayoutConstraint]!
    private var leftConstraints: [NSLayoutConstraint]!
    private var rightConstraints: [NSLayoutConstraint]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharingButton = UIButton(type: UIButtonType.system) as UIButton
        sharingButton.frame = CGRect(x:280, y:0, width:87, height:28)
        sharingButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        sharingButton.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 125/255, alpha: 1.0)
        sharingButton.setTitle("Share", for: UIControlState.normal)
        sharingButton.addTarget(self, action:#selector(MenuViewController.buttonAction(_:)), for: .touchUpInside)
        
        self.view.addSubview(sharingButton)
//        //error object google sign up process..
//        var error : NSError?
//
//        //setting the error
//        GGLContext.sharedInstance().configureWithError(&error)
//
//        //if any error stop execution and print error
//        if error != nil{
//            print(error ?? "google error")
//            return
//        }
//        //adding the delegates
//        GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
//        GIDSignIn.sharedInstance().delegate = self as! GIDSignInDelegate
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        layoutView()
        
        let backgroundURL = Bundle.main.url(forResource: "background", withExtension: "wav")
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: backgroundURL!)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        let wrongURL = Bundle.main.url(forResource: "wrong", withExtension: "aiff")
        wrongMusicPlayer = try! AVAudioPlayer(contentsOf: wrongURL!)
        wrongMusicPlayer.prepareToPlay()
        
        let correctURL = Bundle.main.url(forResource: "correct", withExtension: "mp3")
        correctMusicPlayer = try! AVAudioPlayer(contentsOf: correctURL!)
        correctMusicPlayer.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        updateScores()
    }
    
    func updateScores() {
        recentScores = [
            UserDefaults.standard.integer(forKey: multipleChoiceRecentscoreIdentifier),
            UserDefaults.standard.integer(forKey: imageQuizRecentscoreIdentifier),
            UserDefaults.standard.integer(forKey: rightWrongRecentscoreIdentifier),
            //UserDefaults.standard.integer(forKey: emojiRecentscoreIdentifier)
        ]
        
        highscores = [
            UserDefaults.standard.integer(forKey: multipleChoiceHighscoreIdentifier),
            UserDefaults.standard.integer(forKey: imageQuizHighscoreIdentifier),
            UserDefaults.standard.integer(forKey: rightWrongHighscoreIdentifier),
            //UserDefaults.standard.integer(forKey: emojiHighscoreIdentifier)
        ]
    }
    
    func layoutView() {
        //
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginView)
//        //
//        loginImageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(loginImageView)
//        loginImageView.image = UIImage(named:"steve-wallpaper.jpg")
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        
        //
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        //adding it to view
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
//        //
//        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
//        googleSignInButton.center = view.center
//        view.addSubview(googleSignInButton)
        
        
        //
        logoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoView)
        logoView.image = UIImage(named: "logo")
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonView)
        
        for (index,title) in titles.enumerated() {
            let button = RoundedButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonView.addSubview(button)
            button.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
            gameButtons.append(button)
        }
        
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        recentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highscoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreView.addSubview(titleLabel)
        scoreView.addSubview(recentScoreLabel)
        scoreView.addSubview(highscoreLabel)
        
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = UIColor.white
        recentScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        recentScoreLabel.textColor = UIColor.white
        highscoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        highscoreLabel.textColor = UIColor.white
        
        titleLabel.text = titles[scoreIndex]
        recentScoreLabel.text = "Recent: " + String(UserDefaults.standard.integer(forKey: multipleChoiceRecentscoreIdentifier))
        highscoreLabel.text = "Highscore: " + String(UserDefaults.standard.integer(forKey: multipleChoiceHighscoreIdentifier))
        
        let constraints = [
            contentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8.0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            logoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            buttonView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20.0),
            buttonView.bottomAnchor.constraint(equalTo: scoreView.topAnchor, constant: -20.0),
            buttonView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            buttonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gameButtons[0].topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 8.0),
            gameButtons[0].bottomAnchor.constraint(equalTo: gameButtons[1].topAnchor, constant: -8.0),
            gameButtons[0].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[0].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[1].bottomAnchor.constraint(equalTo: gameButtons[2].topAnchor, constant: -8.0),
            gameButtons[1].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[1].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
//            gameButtons[2].bottomAnchor.constraint(equalTo: gameButtons[3].topAnchor, constant: -8.0),
//            gameButtons[2].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
//            gameButtons[2].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[2].bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -8.0),
            gameButtons[2].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[2].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[0].heightAnchor.constraint(equalTo: gameButtons[1].heightAnchor),
            gameButtons[1].heightAnchor.constraint(equalTo: gameButtons[2].heightAnchor),
//            gameButtons[2].heightAnchor.constraint(equalTo: gameButtons[3].heightAnchor),
            scoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40.0),
            scoreView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            scoreView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            titleLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: recentScoreLabel.topAnchor, constant: -8.0),
            recentScoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            recentScoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            recentScoreLabel.bottomAnchor.constraint(equalTo: highscoreLabel.topAnchor, constant: -8.0),
            highscoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            highscoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            highscoreLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -8.0),
            titleLabel.heightAnchor.constraint(equalTo: recentScoreLabel.heightAnchor),
            recentScoreLabel.heightAnchor.constraint(equalTo: highscoreLabel.heightAnchor)
        ]
        
        midXConstraints = [scoreView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)]
        leftConstraints = [scoreView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor)]
        rightConstraints = [scoreView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)]
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate(midXConstraints)
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextScores), userInfo: nil, repeats: true)
    }
    
    func buttonHandler(sender: RoundedButton) {
        var vc: UIViewController?
        switch sender.tag {
        case 0:
            //Multiple Choice
            vc = MultipleChoiceViewController()
        case 1:
            vc = ImageQuizViewController()
        case 2:
            vc = RightWrongQuizViewController()
//        case 3:
//            vc = EmojiQuizViewController()
//
        default:
            break
        }
        if let newVC = vc {
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    func nextScores() {
        scoreIndex = scoreIndex < (recentScores.count - 1) ? scoreIndex + 1 : 0
        UIView.animate(withDuration: 1.0, animations: { 
            NSLayoutConstraint.deactivate(self.midXConstraints)
            NSLayoutConstraint.activate(self.leftConstraints)
            self.view.layoutIfNeeded()
        }) { (completion: Bool) in
                self.titleLabel.text = self.titles[self.scoreIndex]
                self.recentScoreLabel.text = "Recent: " + String(self.recentScores[self.scoreIndex])
                self.highscoreLabel.text = "Highscore: " + String(self.highscores[self.scoreIndex])
                NSLayoutConstraint.deactivate(self.leftConstraints)
                NSLayoutConstraint.activate(self.rightConstraints)
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 1.0, animations: { 
                    NSLayoutConstraint.deactivate(self.rightConstraints)
                    NSLayoutConstraint.activate(self.midXConstraints)
                    self.view.layoutIfNeeded()
                })
        }
    }
    
    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
//    //when the signin complets
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        //if any error stop and print the error
//        if error != nil{
//            print(error ?? "google error")
//            return
//        }
//
//        //if success display the email on label
//        labelUserEmail.text = user.profile.email
//    }
    
    //sharing button action function...
    func buttonAction(_ sender: UIButton!){
        //Alert
        let alert = UIAlertController(title: "Share", message: "Share the poem of the day!", preferredStyle: .actionSheet)
        
        //First action
        let actionOne = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            
            //Checking if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
                post.setInitialText("Quiz App!!!")
                post.add(UIImage(named: "steve-wallpaper.jpg"))
                
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Facebook")}
        }
        
        //Second action
        let actionTwo = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
            
            //Checking if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("Quiz App!!!")
                post.add(UIImage(named: "apple.jpg"))
                
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Twitter")}
        }
        
        let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Add action to action sheet
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        alert.addAction(actionThree)
        
        //Present alert
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(service:String)
    {
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

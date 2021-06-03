//
//  LandingController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/23/21.
//

import UIKit
import AVKit


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class LandingController: UIViewController {

    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    var videoPlayer: AVPlayer!
    var videoPlayerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        setupVideo()  // Set up video layout and play it
        navigationItem.backButtonTitle = ""
        tabBarController?.tabBar.isHidden = true
        Helper.styleFilledButton(signupButton)
        view.alpha = 0  // View begins transparent
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension LandingController {
    override func viewDidAppear(_ animated: Bool) {  // Fade in the view
        UIView.animate(withDuration: 1.0) {
            self.view.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {  // Keeps the navigation bar hidden
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {  // Keeps the navigation bar hidden
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// ######################################################
//MARK: VIDEO DELEGATE METHOD(S)
// ######################################################

extension LandingController {
    
    func setupVideo() {
        guard let path = Bundle.main.path(forResource: "boba", ofType:"mp4") else {  // Video is from local bundle
            exit(1)
        }
        let landingVideoURL = URL(fileURLWithPath: path)
        let item = AVPlayerItem(url: landingVideoURL)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)  // Video does not cancel background audio
            try AVAudioSession.sharedInstance().setActive(true)
       } catch {
            let ac = Helper.createAlert(title: "Error", message: error.localizedDescription)
            present(ac, animated: true)
       }
        videoPlayer = AVPlayer(playerItem: item)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)  // Configure the video layer
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        videoPlayer?.playImmediately(atRate: 1.0)
        loopVideo(videoPlayer: videoPlayer)  // Loops the video player
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
}

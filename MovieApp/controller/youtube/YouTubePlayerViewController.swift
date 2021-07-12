//
//  YouTubePlayerViewController.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 11/07/2021.
//

import UIKit
import YouTubePlayer

class YouTubePlayerViewController: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    
    var youtubeId : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let  id = youtubeId{
            videoPlayer.loadVideoID(id)
            videoPlayer.play()
            
        }else{
            print("Youtube key Invalid")
        }
        
    }
    
    
    
    
}



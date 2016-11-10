//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Luís Machado on 08/11/16.
//  Copyright © 2016 LuisMachado. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, MPMediaPickerControllerDelegate {

    var mediaPicker: MPMediaPickerController!
    var myMusicPlayer: MPMusicPlayerController?
    var isPlaying:Bool = false
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var musicName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
            let nowPlayingTitle=nowPlayingItem.title
            self.musicName.text=nowPlayingTitle
        } else {
            self.musicName.text="Nothing Played"
        }

        
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        /*for mpMediaItem in mediaItemCollection.items {
            print("Add \(mpMediaItem) to a playlist, prep the player, etc.")
        }*/
        self.dismiss(animated: true, completion: nil)
        
        myMusicPlayer = MPMusicPlayerController()
        
        if let player = myMusicPlayer{
            player.beginGeneratingPlaybackNotifications()
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.nowPlayingItemIsChanged), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
            
            player.setQueue(with: mediaItemCollection)
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
            isPlaying = true
        }
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("canceled")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPause(_ sender: Any) {
        
        if let player = myMusicPlayer {
            if isPlaying {
                player.pause()
                playPauseButton.setTitle("Play", for: .normal)
            } else {
                player.play()
                playPauseButton.setTitle("Pause", for: .normal)
            }
            isPlaying = !isPlaying
        }
        
    }

    @IBAction func nextMusic(_ sender: Any) {
        myMusicPlayer?.skipToNextItem()
    }
    
    @IBAction func previousMusic(_ sender: Any) {
        myMusicPlayer?.skipToPreviousItem()
    }
    
    @IBAction func stop(_ sender: Any) {
        myMusicPlayer?.stop()
        playPauseButton.setTitle("Play", for: .normal)
        isPlaying = !isPlaying
        
    }
    
    func createMediaPicker() {
        mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.showsCloudItems = false
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = true
        self.present(mediaPicker!, animated: true, completion: nil)
    }

    @IBAction func openLibrary(_ sender: Any) {
        createMediaPicker()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


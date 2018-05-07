//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Juan Carlos Granda Ramos on 7/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var audiorecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
    }
    
    func setupRecorder(){
        
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioUrl = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("**************************")
            print(audioUrl!)
            print("**************************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audiorecorder = try AVAudioRecorder(url: audioUrl!, settings: settings)
            audiorecorder!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if audiorecorder!.isRecording{
            audiorecorder?.stop()
            recordButton.setTitle("Grabar", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            audiorecorder?.record()
            recordButton.setTitle("Detener", for: .normal)
            playButton.isEnabled = false
            //addButton.isEnabled = false
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioUrl!)
            audioPlayer!.play()
        }catch{
        
        
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf:audioUrl!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }

}

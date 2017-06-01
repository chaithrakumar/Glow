/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The primary view controller. The speach-to-text engine is managed an configured here.
*/

import UIKit
import Speech
import SwiftyJSON

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    var contentArray  = Array<Asset>()
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
        recordButton.layer.cornerRadius =  recordButton.frame.width/2
        recordButton.backgroundColor = UIColor.green
        recordButton.layer.shadowColor = UIColor.green.cgColor
        //recordButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
       // recordButton.layer.shadowRadius = 5.0
        
        
        
        recordButton.layer.borderWidth = 2.0;
        recordButton.layer.borderColor = UIColor.green.cgColor
        
        recordButton.layer.shadowColor = UIColor.green.cgColor
        recordButton.layer.shadowOpacity = 1.0
        recordButton.layer.shadowRadius = 1.0
        recordButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)

        
        
        
     }
    
    
    
    @IBAction func showMatches(_ sender: UIButton) {
        let matchesScreen = matchesListTableVC()
      //  assetListScreen.assetResultsarray = self.contentArray
        let navController = UINavigationController(rootViewController: matchesScreen)
        self.present(navController, animated: true, completion: {
            print("Done")
        })
    }
    
    
    
    @IBAction func showNoMatches(_ sender: UIButton) {
        let matchesScreen = NoMatchesListTableVC()
        //  assetListScreen.assetResultsarray = self.contentArray
        let navController = UINavigationController(rootViewController: matchesScreen)
        self.present(navController, animated: true, completion: {
            print("Done")
        })
 
        
    }
    
    
    
    override public func viewWillAppear(_ animated: Bool) {
         textView.text = "(Go ahead, I'm listening)"
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
                The callback may not be called on the main thread. Add an
                operation to the main queue to update the record button's state.
            */
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.recordButton.isEnabled = true

                    case .denied:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)

                    case .restricted:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)

                    case .notDetermined:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    private func startRecording() throws {

        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
               
                   if result.bestTranscription.formattedString.characters.count > 0 {
                       //self.getListOfShows(showname: result.bestTranscription.formattedString)
                    }
                

                
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start", for: [])
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textView.text = "(Go ahead, I'm listening)"
    }

    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Start", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        
        self.getListOfShows(showname:"handmaids tale")
        
        
        
 /*       if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
        } else {
            try! startRecording()
            let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(ViewController.timerEnded), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .commonModes)
            recordButton.setTitle("Recording", for: [])
        }*/
        
     }
    
    
    func timerEnded() {
        
        // print("result::::\(self.textView.text)")
        
        if  self.textView.text.characters.count > 0  {
            
            var searchString = self.textView.text
           //  let arr1 = searchString?.characters.split(separator: " ").map(String.init)
          //  let res = arr1?.joined()
            print("result::::\(searchString)")
            self.getListOfShows(showname: searchString!)
        }
        
        
        //print(self.textView.text)
        
    }
    
    
    //MARK: Glow API
    
    func getListOfShows(showname : String) {
        
        
        
        let requestMgr = NetworkManager.sharedInstance
        requestMgr.getAssetsBySearchString ({
            
            (_ responseDataArray  : [JSON], _ error : NSError?) in
            
             //
            
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.recordButton.isEnabled = false
            
            if error == nil {
                self.contentArray.removeAll()
                let contentarray = responseDataArray[0].array
                if (contentarray?.count)! > 0 {
                    for item in contentarray! {
                        let assetObj  = Asset.init(item)
                        self.contentArray.append(assetObj)
                    }
                    
                    if self.contentArray.count == 1{
                        print(self.contentArray[0])
                        self.saveMatchesString(seachStr: self.contentArray[0])
                    }
                    
                    let assetListScreen = GlowSearchResultsController()
                    assetListScreen.assetResultsarray = self.contentArray
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Stopping", for: .disabled)
                    
                    let navController = UINavigationController(rootViewController: assetListScreen)
                   self.present(navController, animated: true, completion: {
                        self.recordButton.isEnabled = true

                    })
                }
            } else {
                //Show error to User
                self.saveNoMatchesString(searchStr: showname)
                
                let alert = UIAlertController.init(title: "Sorry!", message: "0 Results Found!", preferredStyle: .alert )
                let defaultAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                    NSLog("0 results")
                } // 8
                alert.addAction(defaultAction) // 9
                self.present(alert, animated: true, completion:{
                    self.textView.text = "(Go ahead, I'm listening)"
                     self.recordButton.isEnabled = true
})
                
            }
        },  searchString: showname)

        
    }
    
    
    func saveNoMatchesString(searchStr : String) {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: "NOMATCHES") as? Data
        
        if decoded != nil {
            var favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [String]
            favoritesArray.append(searchStr)
            print(favoritesArray)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray)
            userDefaults.set(encodedData, forKey: "NOMATCHES")
            userDefaults.synchronize()
        } else {
            let favorites = [searchStr]
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favorites)
            userDefaults.set(encodedData, forKey: "NOMATCHES")
            userDefaults.synchronize()
            
        }
    }
    
    
    func saveMatchesString(seachStr : Asset){
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: "MATCHES") as? Data
        if decoded != nil {
            let favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as? NSMutableArray
            favoritesArray?.add(seachStr)
            print(favoritesArray ?? 0)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
            userDefaults.set(encodedData, forKey: "MATCHES")
            userDefaults.synchronize()
        } else {
            let favorites = NSMutableArray()
            favorites.add(seachStr)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favorites)
            userDefaults.set(encodedData, forKey: "MATCHES")
            userDefaults.synchronize()
            
        }
        
    }
    
    
    
    
    
    
    
}


//
//  SpeechToTextView.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import Speech

@available(iOS 10.0, *)
class SpeechToTextView: UIView, SFSpeechRecognizerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblRecordingState: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    //MARK: Closure
    var btnFoundText: ((String) -> ())?
    var btnCloseTapped: (() -> ())?
    
    //MARK: Variables
    var searchText = ""
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var timer = Timer()
    
    //MARK: View Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        // make corner radius
        Utilities.decorateView(self.vwContainer.layer, cornerRadius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, borderWidth: 0, borderColor: UIColor.clear)
        // make shadow
        self.vwContainer.dropShadow(color: UIColor.CustomColor.ShadowColor, opacity: 1 , offSet: CGSize(width: 0, height: DeviceConstant.isDeviceTypeIpad() ? 10 : 5), radius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, scale: true)
    }
    
    override func didMoveToSuperview() {
        // set up view
        self.setupView()
    }
    
    //MARK:- Private Methods
    func setupView(){
        microphoneButton.isEnabled = false
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
                self.microphoneTapped(self.microphoneButton)
            }
        }
    }
    
    //MARK:- IBAction Methods
    func RecognizationCompleted() {
        if searchText == "" {
            self.lblRecordingState.text = "Try again"
        }else{
            if btnFoundText != nil{
                btnFoundText!(searchText)
            }
            self.removeFromSuperview()
        }
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            self.stopRecording()
        } else {
            self.setTimer()
            startRecording()
//            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    @IBAction func btnClose_Clicked(_ sender: UIButton) {
        self.stopRecording()
        if btnCloseTapped != nil{
            btnCloseTapped!()
        }
        self.removeFromSuperview()
    }
    
    //Stop recording
    func stopRecording(){
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
//            microphoneButton.setTitle("Start Recording", for: .normal)
        }
    }
    
    //Start recording
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.record.rawValue), mode: AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
//        guard let inputNode = audioEngine.inputNode else {
//            fatalError("Audio engine has no input node")
//        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                self.searchText = result?.bestTranscription.formattedString ?? ""  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
            if isFinal {
                self.microphoneButton.isEnabled = true
                self.invalidateTimer()
                self.stopRecording()
                self.RecognizationCompleted()
            }
            else {
                if error == nil {
                    self.setTimer()
                }else {
                    self.lblRecordingState.text = "Try again"
                    self.microphoneButton.isEnabled = true
                    self.invalidateTimer()
                    self.stopRecording()
                }
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        lblRecordingState.text = "Listening..."
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    //MARK: Private Methods
    func setTimer(){
        self.invalidateTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.delayTimerFired), userInfo: nil, repeats: false)
    }
    
    func invalidateTimer(){
        self.timer.invalidate()
    }
    
    @objc func delayTimerFired(){
        self.stopRecording()
    }
}

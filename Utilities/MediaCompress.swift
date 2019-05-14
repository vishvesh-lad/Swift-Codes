//
//  MediaCompress.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import AVFoundation
import AssetsLibrary
import Photos

class MediaCompress: NSObject {

    // Variables
    var assetWriter:AVAssetWriter?
    var assetReader:AVAssetReader?
    let bitrate:NSNumber = NSNumber(value:3000000)

    //Shared Instance class
    static let sharedInstance = MediaCompress()

    override init() {
        super.init()
    }

    // video Compress
    func compressVideo(inputVideoURL: URL,outputVideoURL: URL,completion:@escaping (URL)->Void){
        // Store Original Video In Gallary
//        let _ = ALAssetsLibrary().writeVideoAtPath(toSavedPhotosAlbum: inputVideoURL, completionBlock: nil)
        self.checkFileSize(sizeUrl: inputVideoURL, message: "Original video size : ")

        self.compressFile(urlToCompress: inputVideoURL, outputURL: outputVideoURL, completion: {[unowned self] (url) in
            AWSS3Manager.sharedInstance.removeFile(inputVideoURL)
            print("Final Output URL: \(url)")
            self.checkFileSize(sizeUrl: url, message: "After Complete Compress : ")
            // Store Compress Video In Gallary
            //            let _ = ALAssetsLibrary().writeVideoAtPath(toSavedPhotosAlbum: url, completionBlock: nil)
            DispatchQueue.main.async {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }) { completed, error in
                    if completed {
                        print("Video is saved!")
                    }
                }
            }

            DispatchQueue.main.async {
                completion(url)
            }
        }, failure: {
            print("Final Output URL: \(inputVideoURL)")
            self.checkFileSize(sizeUrl: inputVideoURL, message: "After Complete Compress : ")
            completion(inputVideoURL)
        })
    }

    // compress file audio / video
    func compressFile(urlToCompress: URL, outputURL: URL, completion:@escaping (URL)->Void, failure:@escaping ()->Void){
        //video file to make the asset

        var audioFinished = false
        var videoFinished = false

        let asset = AVAsset(url: urlToCompress);
        //create asset reader
        do{
            assetReader = try AVAssetReader(asset: asset)
        } catch{
            assetReader = nil
        }

        guard let reader = assetReader else{
            print("Could not initalize asset reader probably failed its try catch")
            failure()
            return
        }

        guard let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else{
            print("videoTrack is nil")
            failure()
            return
        }
        guard let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first else{
            print("audioTrack is nil")
            failure()
            return
        }

        let videoReaderSettings: [String:Any] = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32ARGB]

        // ADJUST BIT RATE OF VIDEO HERE
        let videoSettings:[String:Any] = [
            AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey:self.bitrate],
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoHeightKey: videoTrack.naturalSize.height,
            AVVideoWidthKey: videoTrack.naturalSize.width
        ]

        let assetReaderVideoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)
        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)

        if reader.canAdd(assetReaderVideoOutput){
            reader.add(assetReaderVideoOutput)
        }else{
            print("Couldn't add video output reader")
            failure()
            return
        }

        if reader.canAdd(assetReaderAudioOutput){
            reader.add(assetReaderAudioOutput)
        }else{
            print("Couldn't add audio output reader")
            failure()
            return
        }

        let audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)
        let videoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
        videoInput.transform = videoTrack.preferredTransform
        //we need to add samples to the video input

        let videoInputQueue = DispatchQueue(label: "videoQueue")
        let audioInputQueue = DispatchQueue(label: "audioQueue")

        do{
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mov)
        }catch{
            assetWriter = nil
        }
        guard let writer = assetWriter else{
            print("assetWriter was nil")
            failure()
            return
        }

        writer.shouldOptimizeForNetworkUse = true
        writer.add(videoInput)
        writer.add(audioInput)

        writer.startWriting()
        reader.startReading()
        writer.startSession(atSourceTime: CMTime.zero)

        let closeWriter:()->Void = {
            if (audioFinished && videoFinished){
                self.assetWriter?.finishWriting(completionHandler: {

                    self.checkFileSize(sizeUrl: (self.assetWriter?.outputURL)!, message: "The file size of the compressed file is : ")

                    completion((self.assetWriter?.outputURL)!)
                })
                self.assetReader?.cancelReading()
            }
        }

        audioInput.requestMediaDataWhenReady(on: audioInputQueue) {
            while(audioInput.isReadyForMoreMediaData){
                let sample = assetReaderAudioOutput.copyNextSampleBuffer()
                if (sample != nil){
                    audioInput.append(sample!)
                }else{
                    audioInput.markAsFinished()
                    DispatchQueue.main.async {
                        audioFinished = true
                        closeWriter()
                    }
                    break;
                }
            }
        }

        videoInput.requestMediaDataWhenReady(on: videoInputQueue) {
            //request data here

            while(videoInput.isReadyForMoreMediaData){
                let sample = assetReaderVideoOutput.copyNextSampleBuffer()
                if (sample != nil){
                    videoInput.append(sample!)
                }else{
                    videoInput.markAsFinished()
                    DispatchQueue.main.async {
                        videoFinished = true
                        closeWriter()
                    }
                    break;
                }
            }
        }
    }

    // Check Meadia File Size
    func checkFileSize(sizeUrl: URL, message:String){
//        let data = try? Data(contentsOf: sizeUrl)
//        print(message, (Double(data?.count ?? 0) / 1048576.0), " mb")
    }
}


//
//  MyMessageTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 13/04/2021.
//

import UIKit
import AVFoundation
class MyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageTime: UILabel!
    private var audioPlayer:AVAudioPlayer?
    private var timer:Timer?
    
    func setData(message:ChatMessage,image:String) {
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatterGet.date(from: message.created_at ?? ""){
            let newDateFormatter = DateFormatter()
            newDateFormatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
            newDateFormatter.dateFormat = "dd MMMM hh:mm a"
            messageTime.text = newDateFormatter.string(from: date)
        }
        
        messageImage.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(image)"), placeholderImage: #imageLiteral(resourceName: "personalImage"))
        if message.type! == "text"{
            audioSlider.isHidden = true
            playButton.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message.message ?? ""
            
        }else if message.type! == "audio"{
            audioSlider.isHidden = false
            playButton.isHidden = false
            messageLabel.isHidden = true
            // add sound and to allow play it

            let urlstring = "http://tawseel.pal-dev.com\(message.message!)"
            let url = URL(string: urlstring)
            downloadFileFromURL(url: url!)
               
            
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying{
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }else{
                if let timer = timer {
                    timer.invalidate()
                }
                audioPlayer.stop()
                playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            }
        }
    }
    
    
    @IBAction func audioSliderAction(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            let wasPlaying = audioPlayer.isPlaying
            audioPlayer.stop()
            audioPlayer.currentTime = TimeInterval(audioSlider.value)
            if wasPlaying{
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        }
        
    }
    
    @objc private func updateSlider(){
        audioSlider.value = Float(audioPlayer?.currentTime ?? 0)
        if audioSlider.value == audioSlider.minimumValue{
            if let timer = timer {
                timer.invalidate()
            }
            self.audioPlayer!.stop()
            playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        }
    }
    
    
    private func play(url:URL) {
        do {
            let x = try AVAudioPlayer(contentsOf: url)
            DispatchQueue.main.async {
                self.audioPlayer = x
                self.audioSlider.maximumValue = Float(self.audioPlayer!.duration)
            }
        } catch {
            
        }
    }
    
    
    private func downloadFileFromURL(url:URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](urll, response, error) -> Void in
            self?.play(url: urll!)
        })
        downloadTask.resume()
    }
}


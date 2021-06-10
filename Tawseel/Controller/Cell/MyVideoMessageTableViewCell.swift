//
//  MyVideoMessageTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 10/06/2021.
//

import UIKit
import AVFoundation
import AVKit

class MyVideoMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var vedioView: UIViewCustomCornerRadius!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var vedioPlayer:AVPlayer!
    private var playerLayer:AVPlayerLayer!
    public var delegate:VideoMessageProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vedioView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVideo)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(message:ChatMessage,image:String){
        userImageView.sd_setImage(with: URL(string: "http://tawseel.pal-dev.com\(image)"), placeholderImage: #imageLiteral(resourceName: "personalImage"))
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatterGet.date(from: message.created_at ?? ""){
            let newDateFormatter = DateFormatter()
            newDateFormatter.locale = Locale(identifier: L102Language.currentAppleLanguage())
            newDateFormatter.dateFormat = "dd MMMM hh:mm a"
            timeLabel.text = newDateFormatter.string(from: date)
        }
        
        vedioPlayer = AVPlayer(url: URL(string: "http://tawseel.pal-dev.com\(message.message!)")!)
        playerLayer = AVPlayerLayer(player: vedioPlayer)
        playerLayer.frame = vedioView.bounds
        vedioView.layer.addSublayer(playerLayer)
    }
    
    @objc private func playVideo(){
        
        let vc = AVPlayerViewController()
        vc.player = vedioPlayer
        if let delegate = delegate {
            delegate.showPlayerVC(vc:vc)
        }
    }
    
}

protocol VideoMessageProtocol {
    func showPlayerVC(vc:AVPlayerViewController)
}

//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblScore: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }

    func config(post: Post) {
        let placeholder = UIImage(named: "launch_bg")
        imgPicture.kf.setImage(with: URL(string: post.data.url), placeholder: placeholder) { result in

        }
        lblTitle.text = post.data.title
        lblScore.text = String(post.data.score)
    }
    
}

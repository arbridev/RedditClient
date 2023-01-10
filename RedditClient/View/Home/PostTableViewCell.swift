//
//  PostTableViewCell.swift
//  RedditClient
//
//  Created by Armando Brito on 8/1/23.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak private var vwInnerContent: UIView!
    @IBOutlet weak private var imgPicture: UIImageView!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblScore: UILabel!
    @IBOutlet weak private var lblCommentCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        vwInnerContent.layer.cornerRadius = Constant.standardCornerRadius
        vwInnerContent.addShadow()

        imgPicture.layer.cornerRadius = Constant.standardCornerRadius
        imgPicture.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }

    func config(post: Post) {
        let placeholder = UIImage.Background.defaultStyle
        KF.url(URL(string: post.data.url))
          .placeholder(placeholder)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.25)
          .set(to: imgPicture)
        lblTitle.text = post.data.title
        lblScore.text = String(post.data.score)
        lblCommentCount.text = String(post.data.numComments)
    }

}

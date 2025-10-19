//
//  BookmarkCell.swift
//  Reader
//
//  Created by juber99 on 19/10/25.
//

import UIKit


class BookmarkCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with article: BookmarkArticle) {
           titleLabel.text = article.title
           thumbnailImageView.layer.cornerRadius = 5
           thumbnailImageView.layer.borderWidth = 1
          thumbnailImageView.layer.borderColor = UIColor.systemBlue.cgColor
           authorLabel.text = article.author ?? "Unknown"
           if let url = URL(string: article.urlToImage ?? "") {
               URLSession.shared.dataTask(with: url) { data, _, _ in
                   guard let data = data else { return }
                   DispatchQueue.main.async {
                       self.thumbnailImageView.image = UIImage(data: data)
                   }
               }.resume()
           } else {
               thumbnailImageView.image = UIImage(systemName: "photo")
           }
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ArticleDetailsViewController.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import UIKit
import SafariServices

class ArticleDetailsViewController: UIViewController {
    
    var article: Article?
    var viewModel: ArticleListViewModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var imgThumbnail: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        configure()
    }
    
    private func configure() {
        titleLabel.text = article?.title
        bodyLabel.text = article?.description
        publishedDate.text = viewModel?.convertDatetoString(article: article!)
        if let s = article?.urlToImage, let url = URL(string: s) {
            // if SDWebImage: imageView.sd_setImage(with: url)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let img = UIImage(data: data) else { return }
                DispatchQueue.main.async { self.imgThumbnail.image = img }
            }.resume()
        } else {
            self.imgThumbnail.image = UIImage(systemName: "photo")
        }
        
        updateBookmarkButton()
    }
    
    func updateBookmarkButton() {
        let imageName = (viewModel?.checkBookmarkArticle(article!))! ? "bookmark.fill" : "bookmark"
        btnBookmark.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    @IBAction func btnBookmarkPressed(_ sender: UIButton) {
        // Code to execute when the button is tapped
        let isBookmarkedArticle = viewModel?.checkBookmarkArticle(article!) as? Bool ?? false
        if isBookmarkedArticle == false {
            btnBookmark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            viewModel?.saveBookmarkArticle(article!)
            let alert = UIAlertController(title: "Bookmarked", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            viewModel?.deleteBookmarkArticle(article!)
            btnBookmark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
       
    }
    
    @IBAction func btnOpenArticlePressed(_ sender: UIButton) {
        // Code to execute when the button is tapped
        if let urlStr = article?.url, let url = URL(string: urlStr) {
            present(SFSafariViewController(url: url), animated: true)
        }
    }
}

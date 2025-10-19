//
//  BookmarkViewController.swift
//  Reader
//
//  Created by juber99 on 19/10/25.
//

import UIKit

class BookmarkViewController: UIViewController {
    @IBOutlet weak var bookmarkTable: UITableView!
    @IBOutlet weak var nodataLable: UILabel!
    var arrBookMarkArticles = [BookmarkArticle]()
    private let viewModel = ArticleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Bookmark"
    }
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
        fetchBookmarkArticle()
    }
    private func setupTableView() {
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
    }
    
    private func fetchBookmarkArticle() {
        arrBookMarkArticles = viewModel.fetchBookMarkArticle()
        if arrBookMarkArticles.count == 0 {
            nodataLable.alpha = 1
        }else {
            nodataLable.alpha = 0
        }
        bookmarkTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrBookMarkArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCell else {
            return UITableViewCell()
        }
        cell.configure(with: arrBookMarkArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    
}

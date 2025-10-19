//
//  ArticleViewController.swift
//  Reader
//
//  Created by juber99 on 18/10/25.
//

import UIKit


class ArticleViewController: UIViewController {
    //articleCell
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    private let viewModel = ArticleListViewModel()
    private var searchController: UISearchController!

    //private let viewModel = ArticleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Top Headlines"
        setupTableView()
        setupSearch()
        bindViewModel()
        viewModel.loadArticles()
    }
    private func setupSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Articles"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        viewModel.loadArticles(forceRefresh: true)
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

extension ArticleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.articles[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: article)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let dest = segue.destination as? ArticleDetailsViewController,
           let article = sender as? Article {
            dest.article = article
            dest.viewModel = viewModel
        }
    }
}

extension ArticleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        if query.isEmpty {
            viewModel.loadArticles()
        } else {
            viewModel.search(query: query)
        }
    }
}

//
//  ViewController.swift
//  NewsApp
//
//  Created by 福永竜之 on 2021/05/15.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    var languageChangeButton: UIBarButtonItem!
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        fetchTopStories()
        createSearchBar()
        
        languageChangeButton = UIBarButtonItem(title: "Spanish", style: .done, target: self, action: #selector(languageChangeButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = languageChangeButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    @objc func languageChangeButtonTapped(_ sender: UIBarButtonItem) {
        if languageChangeButton.title == "Spanish" {
            APICaller.shared.getTopStories(with: "es") { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            languageChangeButton.title = "French"
        }
        else if languageChangeButton.title == "English" {
            APICaller.shared.getTopStories(with: "en") { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            languageChangeButton.title = "Spanish"
        }
        else if languageChangeButton.title == "French" {
            APICaller.shared.getTopStories(with: "fr") { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            languageChangeButton.title = "English"
        }
    }
    
    private func fetchTopStories() {
        APICaller.shared.getTopStories(with: "en") { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No Description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                       for: indexPath) as? NewsTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        if languageChangeButton.title == "Spanish" {
            APICaller.shared.search(with: "en", with: text) { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else if languageChangeButton.title == "French" {
            APICaller.shared.search(with: "es", with: text) { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else if languageChangeButton.title == "English" {
            APICaller.shared.search(with: "fr", with: text) { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchTopStories()
    }
    
}


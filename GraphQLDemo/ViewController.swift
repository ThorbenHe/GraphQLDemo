//
//  ViewController.swift
//  GraphQLDemo
//
//  Created by Thorben Hebbelmann on 28.12.21.
//

import UIKit

class ViewController: UIViewController,  UITableViewDataSource {
    
    var repositories = [RepositoryListQuery.Data.Search.Edge]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRepositories()
        
        let tableViewCell = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(tableViewCell, forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("Repositories: \(repositories)")
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        else {
            return UITableViewCell()
        }
        
        let repo = repositories[indexPath.row].resultMap["node"]!! as! Dictionary<String, Any?>
        
        cell.repoName?.text = repo["name"]!! as? String
        cell.starCount?.text = String((repo["stargazerCount"]!! as? Int)!)

        return cell
    }
    
    private func loadRepositories() {
        Network.shared.apollo
            .fetch(query: RepositoryListQuery()) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                defer {
                    self.tableView.reloadData()
                }
                
                switch result {
                case .success(let graphQLResult):
                    if let repoConnection = graphQLResult.data?.search.edges {
                        self.repositories = repoConnection.compactMap({ $0 })
                    }
                    if let errors = graphQLResult.errors {
                        let message = errors
                            .map { $0.localizedDescription }
                            .joined(separator: "\n")
                        self.showAlert(title: "GraphQL Error(s)",
                                       message: message)
                    }
                case .failure(let error):
                    self.showAlert(title: "Network Error", message: error.localizedDescription)
                }
            }
    }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
}


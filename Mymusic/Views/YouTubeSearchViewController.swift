import UIKit

class YouTubeSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private let viewModel = YouTubeSearchViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YouTube Search"
        setupUI()
    }
    
    private func setupUI() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "VideoCell")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.search(query: query) { [weak self] in
            self?.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfVideos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        let video = viewModel.video(at: indexPath.row)
        cell.textLabel?.text = video.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.sendVideoToServer(at: indexPath.row) { success in
            let alert = UIAlertController(title: success ? "Success" : "Error", message: success ? "Video sent to server" : "Failed to send", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

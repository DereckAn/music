import UIKit

class PlaylistsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = PlaylistsViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"
        setupTableView()
        fetchPlaylists()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaylistCell")
    }
    
    private func fetchPlaylists() {
        viewModel.fetchPlaylists { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfPlaylists
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        let playlist = viewModel.playlist(at: indexPath.row)
        cell.textLabel?.text = playlist.name
        return cell
    }
}

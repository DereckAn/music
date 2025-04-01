import UIKit
import AVKit

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel = SongsViewModel()
    private let tableView = UITableView()
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Songs"
        setupTableView()
        fetchSongs()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SongCell")
    }
    
    private func fetchSongs() {
        viewModel.fetchSongs { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSongs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        let song = viewModel.song(at: indexPath.row)
        cell.textLabel?.text = song.title + (song.isLocal ? " (Local)" : "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = viewModel.song(at: indexPath.row)
        if song.isLocal {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(song.title).mp3")
            player = AVPlayer(url: path)
        } else {
            player = AVPlayer(url: URL(string: song.url)!)
        }
        player?.play()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let downloadAction = UIContextualAction(style: .normal, title: "Download") { [weak self] _, _, completion in
            self?.viewModel.downloadSong(at: indexPath.row) {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [downloadAction])
    }
}

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let songsVC = SongsViewController()
        songsVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(systemName: "music.note.list"), tag: 0)
        
        let playlistsVC = PlaylistsViewController()
        playlistsVC.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let youtubeVC = YouTubeSearchViewController()
        youtubeVC.tabBarItem = UITabBarItem(title: "YouTube", image: UIImage(systemName: "video"), tag: 2)
        
        viewControllers = [songsVC, playlistsVC, youtubeVC].map { UINavigationController(rootViewController: $0) }
    }
}

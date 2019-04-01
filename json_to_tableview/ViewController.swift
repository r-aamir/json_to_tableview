import UIKit

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    private var dataSource = [User]() {
        didSet {
            self.tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        let url = URL(string: "https://test.netperformers.de/users.php")
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "An error occurred")
                return
            }
            
            DispatchQueue.main.async {
                self?.dataSource = try! JSONDecoder().decode([User].self, from: data)
            }
        }).resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        let user = self.dataSource[indexPath.row]
        cell.textLabel?.text = user.firstName
        return cell
    }
    
}

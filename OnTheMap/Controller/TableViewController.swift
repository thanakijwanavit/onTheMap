

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0
    var latestLocation = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latestLocation = LocationModel.latestLocation
        self.tableView.reloadData()
        self.latestLocation = LocationModel.latestLocation
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView is called")
        return self.latestLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
        
        let student = self.latestLocation[indexPath.row]
        
        cell.textLabel?.text = student.firstName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "StudentPlaceholder")
//        print("cell with \(indexPath.row) is set" )

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("row \(selectedIndex) selected")
        let app = UIApplication.shared
        if let toOpen = latestLocation[selectedIndex].mediaURL {
            guard let toOpenUrl:URL = URL(string: toOpen) else {
                print("error convertine string to URL")
                return
            }
                app.open(toOpenUrl, options: [:]) { (success) in
                //
            }
        } else {
            print("no url")
        }
    }
    
}

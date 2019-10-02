

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OnTheMapClient.logout { (success, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                print("logged out successful")
                self.navigationController?.dismiss(animated: true, completion: nil)
//                self.performSegue(withIdentifier: "fromListToLogin", sender: nil)
            }
        }
        
    }
    var selectedIndex = 0
    var latestLocation = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latestLocation = LocationModel.latestLocation
        self.tableView.reloadData()
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.scrollEdgeAppearance = nil
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        latestLocation = LocationModel.latestLocation
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

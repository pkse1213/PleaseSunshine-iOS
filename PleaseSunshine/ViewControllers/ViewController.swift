
import UIKit
import GooglePlaces
import GoogleMaps
class ViewController: UIViewController {
    var arrayAddress = [GMSAutocompletePrediction]()
    
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        return filter
    }()
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.attributedText = arrayAddress[indexPath.row].attributedFullText
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell!
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if searchStr == "" {
            self.arrayAddress = [GMSAutocompletePrediction]()
        }else {
            GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filter) { (result, error) in
                if error == nil && result != nil {
                    self.arrayAddress = result!
                }
            }
        }
        self.tableView.reloadData()
        return true 
    }
}

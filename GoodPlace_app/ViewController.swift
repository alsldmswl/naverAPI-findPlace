//
//  ViewController.swift
//  GoodPlace_app
//
//  Created by eun-ji on 2023/03/07.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: DataModel?
    var term = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func requestAPI() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        var baseUrl = URLComponents(string: "https://openapi.naver.com/v1/search/local")
        let term = URLQueryItem(name: "query", value: term)
        let display = URLQueryItem(name: "display", value: "100")
        
        baseUrl?.queryItems = [term, display]
        
        guard let url = baseUrl?.url else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Qm9tT_RktiCapoJtEQoU", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("OZs1rNRY4P", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        let task = session.dataTask(with: request) { data, response, error in
            print((response as! HTTPURLResponse).statusCode)
            
            if let hasData = data {
                do{
                    self.dataModel = try JSONDecoder().decode(DataModel.self, from: hasData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }


}

extension ViewController: UITableViewDataSource,  UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        let titleResult = self.dataModel?.items[indexPath.row].title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        cell.nameLabel.text = titleResult
        cell.addressLabel.text = self.dataModel?.items[indexPath.row].address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = UIStoryboard(name: "DetailVC", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        self.present(detailVC, animated: true)

        let titleResult = self.dataModel?.items[indexPath.row].title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        var baseUrl = URLComponents(string: "https://search.naver.com/search.naver")
        let term = URLQueryItem(name: "query", value: titleResult)

        baseUrl?.queryItems = [term]
        guard let url = baseUrl?.url else {return}
        var request = URLRequest(url: url)

        //loadRequest 메서드로 URL 로드
        detailVC.webView.loadRequest(request)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let hasText = searchBar.text else {return}
        
        term = hasText
        requestAPI()
        self.view.endEditing(true)
    }
}

//
//  HistoryViewController.swift
//  GoodPlace_app
//
//  Created by eun-ji on 2023/03/09.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Database.database().reference().child("searchHistory")
    var searchTerms: [SearchTerm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { snapshot in
            guard let searchHistory = snapshot.value as? [String: Any] else {return}
          //  let datas = Array(searchHistory.values)
            let data = try! JSONSerialization.data(withJSONObject:  Array(searchHistory.values), options: [])
          
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
            self.searchTerms = searchTerms.sorted(by: { (term1, term2) in
                return term1.timestamp > term2.timestamp
                // sort => self.searchTerms = searchTerms.sorted{$0.timestamp > $1.timestamp}
            })
            
            self.tableView.reloadData()
            print("\(data), \(searchTerms)")
            
          
            
        }
    }
}
extension HistoryViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
        else {
           return UITableViewCell()
        }
          cell.delete = { [unowned self] in
          // 1. DB 에서 요청 데이터 삭제하기
          //    db.child().removeValue()
          self.searchTerms.remove(at: indexPath.row)
          self.tableView.reloadData()
       }
        cell.searchTerm.text = searchTerms[indexPath.row].term
        return cell
    }
  
}


class HistoryCell: UITableViewCell {
    
    var delete: (() -> ()) = {}
    let db = Database.database().reference().child("searchHistory")
    
    @IBOutlet weak var searchTerm: UILabel!
    
    
    @IBAction func deleteBtn(_ sender: Any) {
      delete()
    }
    
    
}

struct SearchTerm : Codable {
    let term: String
    let timestamp: TimeInterval
}

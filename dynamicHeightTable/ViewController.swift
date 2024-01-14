//
//  ViewController.swift
//  dynamicHeightTable
//
//  Created by Arrax on 14/01/24.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data : [String : Pages]?
    
    var initialData : [String : Pages]?
    
    let customCellReuseIdentifier = "customCellReuseIdentifier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: String(describing: QuoteTableViewCell.self), bundle: nil), forCellReuseIdentifier: customCellReuseIdentifier)
        self.tableView.rowHeight  = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let wikiData = WikiDataFetch()
        
        wikiData.fetchData{ apiData in
            apiData.query.pages.values.forEach { val in
                print(val.title)
            }
            self.data = apiData.query.pages
            self.initialData = self.data
            // main thread reload data.
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{ data = initialData }
        else{
            data = data?.filter({ (key, page) in
                page.title.lowercased().contains(searchText.lowercased()) || page.extract.lowercased().contains(searchText.lowercased())
            })
        }
        DispatchQueue.main.async{ self.tableView.reloadData() }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellReuseIdentifier, for: indexPath) as! QuoteTableViewCell
        if let dataValues = data?.values, indexPath.row < dataValues.count {
            let dataArray = Array(dataValues)
            let wiki = dataArray[indexPath.row]
            cell.authorLabel.text = wiki.title
            cell.quoteLabel.text = wiki.extract
            if let imageURLString = wiki.thumbnail?.source, let imageURL = URL(string: imageURLString) {
                cell.wikiImage.loadImage(from: imageURL)
                cell.wikiImage.heightAnchor.constraint(equalToConstant: CGFloat(wiki.thumbnail?.height ?? 50)).isActive = true
                cell.wikiImage.widthAnchor.constraint(equalToConstant: CGFloat(wiki.thumbnail?.width ?? 50)).isActive = true
            }
            else{
                cell.wikiImage.isHidden = true
                cell.wikiImage.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
                cell.wikiImage.widthAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
            }
            
        }
        return cell
    }
}

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

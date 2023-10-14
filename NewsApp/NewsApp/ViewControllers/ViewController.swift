//
//  ViewController.swift
//  NewsApp
//
//  Created by Zeynep Uzunsoy on 25.08.2023.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    var parser: XMLParser!
    var news: [NewsItem] = []
    var element = ""
    var newsTitle = ""
    var link = ""
    var newsDescription = ""
    var imageUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Haberler"
        view.backgroundColor = .systemBackground
        
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NewsCell.self))
        
        parsingDataFromUrl()
    }
    
    
    func parsingDataFromUrl() {
        guard let url = URL(string: "https://www.haberturk.com/rss") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                self.news = []
                self.parser = XMLParser(data: data)
                self.parser.delegate = self
                self.parser.parse()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
    }


    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName
        
        if elementName == "item" {
            newsTitle = ""
            link = ""
            newsDescription = ""
            imageUrl = ""
      }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
            switch element {
            case "title":
                newsTitle += string
            case "link":
                link += string
            case "image":
                imageUrl += string
            case "description":
                newsDescription += string
            default:
                break
            }
        }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item" {
                let newsItem = NewsItem(title: newsTitle, link: link, image: imageUrl, description: newsDescription)
                news.append(newsItem)
            }
        }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsCell.self), for: indexPath) as! NewsCell
//        let currentNews = news[indexPath.row]
//        cell.newsTitle.text = currentNews.title
//        cell.newsDescription.text = currentNews.description
        
        let newsItem = news[indexPath.row]
          cell.configure(with: newsItem)
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        
        if let newsDetailVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as? NewsDetailVC {
            newsDetailVC.selectedNews = selectedNews // Set the selectedNews property if needed
            navigationController?.pushViewController(newsDetailVC, animated: true)
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173
    }
}

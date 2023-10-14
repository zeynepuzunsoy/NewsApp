//
//  NewsCell.swift
//  NewsApp
//
//  Created by Zeynep Uzunsoy on 25.08.2023.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        newsTitle.numberOfLines = 0
        newsTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        
        newsDescription.numberOfLines = 0
        newsDescription.font = .systemFont(ofSize: 17, weight: .light)
        
        
        
//        newsTitle.adjustsFontSizeToFitWidth = true // Metni genişliğe sığdırır
//        newsTitle.minimumScaleFactor = 0.5 // En küçük metin ölçeği
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with newsItem: NewsItem) {
        newsTitle.text = newsItem.title
        newsDescription.text = newsItem.description
        
        
        if let imageURL = URL(string: newsItem.image!) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.newsImage.image = UIImage(data: imageData)
                    }
                }
            }
            
        }
        
    }
}

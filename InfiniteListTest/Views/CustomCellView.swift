
import UIKit

class CustomCell: UICollectionViewCell {
    let cardImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let desc: UILabel = {
        let desc = UILabel()
        desc.textColor = cellDescColor
        desc.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    func setConstraints() {
        
        addSubview(cardImage)
        
        NSLayoutConstraint.activate([
            cardImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cardImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            cardImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            cardImage.heightAnchor.constraint(equalToConstant: 82)
        ])
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        addSubview(desc)
        
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            desc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            desc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

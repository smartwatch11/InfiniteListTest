
import UIKit

class CardImageViewController: UIViewController {
    
    var toFaivore: Bool = false
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let mainImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let starBtn: UIButton = {
        let star = UIButton()
        star.translatesAutoresizingMaskIntoConstraints = false
        star.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large)),  for: .normal)
        star.tintColor = starColor
        star.addTarget(self, action: #selector(toFaivorate),  for: .touchUpInside)
        return star
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    @objc func toFaivorate() {
        self.toFaivore.toggle()
        
        if self.toFaivore {
            self.starBtn.setImage(UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            self.starBtn.tintColor = starToFaivorite
        } else {
            self.starBtn.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            self.starBtn.tintColor = starColor
        }
    }
    
    func setConstraints() {
        view.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            iconImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            iconImage.widthAnchor.constraint(equalToConstant: 32),
            iconImage.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        view.addSubview(mainImage)
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            mainImage.widthAnchor.constraint(equalToConstant: 117),
            mainImage.heightAnchor.constraint(equalToConstant: 183)
        ])
        
        view.addSubview(starBtn)
        NSLayoutConstraint.activate([
            starBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            starBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            starBtn.widthAnchor.constraint(equalToConstant: 32),
            starBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
}


import UIKit

class CardViewController: UIViewController {
    
    var nameText: String? = ""
    var descText: String? = ""
    var mainUIImage: UIImage? = UIImage(systemName: "cart.fill")
    var iconUIImage: UIImage? = UIImage(systemName: "heart.circle.fill")
    
    let cardImage = CardImageViewController()
    
    let name: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let desc: UILabel = {
        let desc = UILabel()
        desc.textColor = cardTitleColor
        desc.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()
    
    let buyBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "pin"),  for: .normal)
        btn.setTitle("ГДЕ КУПИТЬ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.titleLabel?.textColor = .black
        btn.contentHorizontalAlignment = .center
        btn.layer.borderColor = buyBtnColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(buyBtnTapped),  for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtnTapped))
    }
    
    @objc
    func backBtnTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func buyBtnTapped() {
        print("buy item")
    }
    
    func setConstraints() {
        view.addSubview(cardImage.view)
        cardImage.view.translatesAutoresizingMaskIntoConstraints = false
        cardImage.iconImage.image = iconUIImage
        cardImage.mainImage.image = mainUIImage
        cardImage.mainImage.tintColor = .green
        cardImage.iconImage.tintColor = .green
        NSLayoutConstraint.activate([
            cardImage.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            cardImage.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardImage.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardImage.view.heightAnchor.constraint(equalToConstant: 215)
        ])
        
        view.addSubview(name)
        name.text = nameText
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: cardImage.view.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(desc)
        desc.text = descText
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            desc.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        view.addSubview(buyBtn)
        NSLayoutConstraint.activate([
            buyBtn.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 16),
            buyBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buyBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buyBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
}

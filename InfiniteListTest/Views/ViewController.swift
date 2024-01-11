
import UIKit

class ViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    var collectionView: UICollectionView!
    let search = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Препараты"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtnTapped))
        configSearchController()
    }
    
    @objc
    func refreshCollectionView(_ sender: Any) {
        self.presenter.apiHandler.fetchData(offset: nil, searchText: nil) { drugs in
            self.presenter.drugs!.removeAll()
            self.presenter.isSearch = false
            self.presenter.page = 0
            self.presenter.isFullLoad = false
            self.presenter.drugs = drugs
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configSearchController() {
        search.loadViewIfNeeded()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.enablesReturnKeyAutomatically = false
        search.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = nil
        search.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        search.searchBar.placeholder = "Введите название препарата"
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        if !searchText.isEmpty {
            self.presenter.isSearch = true
            self.presenter.apiHandler.fetchData(offset: nil, searchText: searchText) {drugs in
                self.presenter.drugs!.removeAll()
                self.presenter.page = 0
                self.presenter.drugs = drugs
                self.collectionView.reloadData()
            }
        } else {
            self.presenter.isSearch = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController = nil
        self.refreshCollectionView((Any).self)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.drugs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == presenter.drugs!.count - 1 && !presenter.isFullLoad{
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            loadingCell.shadowDecorate()
            loadingCell.backgroundColor = .white
            loadingCell.indicator.startAnimating()
            return loadingCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            cell.shadowDecorate()
            cell.backgroundColor = .white
            let drug = presenter.drugs?[indexPath.row]
            cell.title.heightAnchor.constraint(equalToConstant: heightForView(text: drug!.name, font: UIFont.systemFont(ofSize: 13, weight: .semibold), width: CGFloat(cell.frame.width-24))).isActive = true
            cell.desc.heightAnchor.constraint(equalToConstant: heightForView(text: drug!.description, font: UIFont.systemFont(ofSize: 12, weight: .medium), width: CGFloat(cell.frame.width-24))).isActive = true
            cell.cardImage.downloaded(from: URL(string: drug!.image)!, contentMode: .scaleAspectFit)
            cell.title.text = drug?.name
            cell.desc.text = drug?.description
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 292)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CardViewController()
        let drug = presenter.drugs?[indexPath.row]
        vc.nameText = drug?.name
        vc.descText = drug?.description
        vc.cardImage.mainImage.downloaded(from: drug!.image, contentMode: .scaleAspectFit)
        vc.cardImage.iconImage.downloaded(from: drug!.icon, contentMode: .scaleAspectFit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.presenter.drugs!.count - 1 && !self.presenter.isFullLoad{
            self.presenter.page += 1
            if self.presenter.isSearch {
                self.presenter.loadMoreDrugsForSearch(searchText: self.search.searchBar.text!)
                self.collectionView.reloadData()
            } else {
                self.presenter.loadMoreDrugs()
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc
    func backBtnTapped(){
        print("back")
    }
    
    @objc
    func searchBtnTapped(){
        self.navigationItem.searchController = search
        present(search, animated: true, completion: nil)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
}


extension ViewController: MainViewProtocol {
    
    func success() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: "loadingCell")
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
        refreshControl.tintColor = refreshControlColor
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка препаратов")
    }
}

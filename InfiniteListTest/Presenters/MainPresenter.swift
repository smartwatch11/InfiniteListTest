
import UIKit

protocol MainViewProtocol: AnyObject {
    func success()
}

protocol MainPresenterProtocol: AnyObject {
    init (view: MainViewProtocol, apiHandler: ApiFetchHandler)
    func getDrugs()
    func loadMoreDrugs()
    func loadMoreDrugsForSearch(searchText: String)
    var apiHandler: ApiFetchHandlerProtocol {get}
    var drugs: [DrugsModel]? {get set}
    var isSearch: Bool {get set}
    var page: Int {get set}
    var isFullLoad: Bool {get set}
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let apiHandler: ApiFetchHandlerProtocol
    var drugs: [DrugsModel]?
    var isSearch: Bool = false
    var page = 0
    var isFullLoad: Bool = false
    
    required init(view: MainViewProtocol, apiHandler: ApiFetchHandler) {
        self.view = view
        self.apiHandler = apiHandler
        getDrugs()
    }
    
    func getDrugs() {
        DispatchQueue.main.async {
            self.apiHandler.fetchData(offset: nil, searchText: nil) { [weak self] drugs in
                guard let self = self else {return}
                self.drugs = drugs
                self.view?.success()
            }
        }
    }
    
    func loadMoreDrugs() {
        self.apiHandler.fetchData(offset: 8*self.page-1, searchText: nil) { drugs in
            DispatchQueue.main.async {
                if drugs.isEmpty {
                    self.isFullLoad = true
                }
                self.drugs!.append(contentsOf: drugs)
            }
        }
    }
    
    func loadMoreDrugsForSearch(searchText: String) {
        self.apiHandler.fetchData(offset: 8*self.page-1, searchText: searchText) { drugs in
            if drugs.isEmpty {
                self.isFullLoad = true
            }
            self.drugs!.append(contentsOf: drugs)
        }
    }
    
}

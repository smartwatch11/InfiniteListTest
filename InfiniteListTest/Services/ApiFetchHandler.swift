
import UIKit

protocol ApiFetchHandlerProtocol {
    func fetchData(offset: Int?, searchText: String?, complition: @escaping ([DrugsModel])->())
}

class ApiFetchHandler: ApiFetchHandlerProtocol {
    
    func fetchData(offset: Int?, searchText: String?, complition: @escaping ([DrugsModel])->()) {
        let url = URL(string: "http://shans.d2.i-partner.ru/api/ppp/index/?offset=\(offset ?? 0)&limit=8&search=\(searchText ?? "")")
        var requiredDataArr: [DrugsModel] = []
        var errorOccured: Bool = false
        let task = URLSession.shared.dataTask(with:  url!) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [AnyObject]
                
                if json.isEmpty {
                    errorOccured = true
                    let resArr: [DrugsModel] = []
                    complition(resArr)
                }
                
                DispatchQueue.main.async {
                    if !errorOccured {
                        for i in stride(from: 0, through: json.count-1, by: 1) {
                            let drug =  json[i] as! [String: AnyObject]
                            let category =  drug["categories"] as! [String: AnyObject]
                            let image = drug["image"] as! String
                            let icon = category["icon"] as! String
                            requiredDataArr.append(DrugsModel(id: drug["id"] as! Int, image: "http://shans.d2.i-partner.ru/\(image)" , name: drug["name"] as! String, description: drug["description"] as! String, icon: "http://shans.d2.i-partner.ru\(icon)" ))
                        }
                        complition(requiredDataArr)
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType?.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {return}
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit){
        guard let url = URL(string: link) else {return}
        downloaded(from: url, contentMode: mode)
    }
}

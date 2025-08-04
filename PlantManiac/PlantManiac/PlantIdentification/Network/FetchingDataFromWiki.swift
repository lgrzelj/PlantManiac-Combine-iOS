import Foundation

class FetchingDataFromWiki {
    
    func fetchSummary(for plantName: String, completion: @escaping (String?) -> Void) {
        let formattedName = plantName.replacingOccurrences(of: " ", with: "_")
        guard let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(formattedName)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let extract = json["extract"] as? String else {
                completion(nil)
                return
            }

            completion(extract)
        }.resume()
    }
    
    func fetchWikidataID(for plantName: String, completion: @escaping (String?) -> Void) {
        let formattedName = plantName.replacingOccurrences(of: " ", with: "_")
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&prop=pageprops&titles=\(formattedName)&format=json"
        
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let query = json["query"] as? [String: Any],
                  let pages = query["pages"] as? [String: Any],
                  let first = pages.values.first as? [String: Any],
                  let props = first["pageprops"] as? [String: Any],
                  let wikidataID = props["wikibase_item"] as? String else {
                completion(nil)
                return
            }

            completion(wikidataID)
        }.resume()
    }
    
    func fetchStructuredData(for wikidataID: String, completion: @escaping ([String: Any]) -> Void) {
        let urlStr = "https://www.wikidata.org/wiki/Special:EntityData/\(wikidataID).json"
        guard let url = URL(string: urlStr) else {
            completion([:])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let entities = json["entities"] as? [String: Any],
                  let entity = entities[wikidataID] as? [String: Any],
                  let claims = entity["claims"] as? [String: Any] else {
                completion([:])
                return
            }

            completion(claims)
        }.resume()
    }
    
    func extractValue(from claim: Any?) -> String? {
        guard let claimArray = claim as? [[String: Any]],
              let first = claimArray.first,
              let mainsnak = first["mainsnak"] as? [String: Any],
              let datavalue = mainsnak["datavalue"] as? [String: Any],
              let value = datavalue["value"] else {
            return nil
        }

        if let str = value as? String {
            return str
        }

        if let amount = (value as? [String: Any])?["amount"] as? String {
            return amount
        }

        if let text = (value as? [String: Any])?["text"] as? String {
            return text
        }

        return nil
    }
}

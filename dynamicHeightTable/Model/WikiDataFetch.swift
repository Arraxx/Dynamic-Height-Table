//
//  WikiDataFetch.swift
//  dynamicHeightTable
//
//  Created by Arrax on 14/01/24.
//

import UIKit

struct WikiDataFetch {
    
    func fetchData(completion : @escaping(WikiModel) -> Void){
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&generator=search&gsrnamespace=0&gsrsearch=apple&gsrlimit=10&prop=pageimages%7Cextracts&pilimit=max&exintro&explaintext&exsentences=1&exlimit=max")
        else{ return }
        
        let dataTask = URLSession.shared.dataTask(with: url){ (data, _,error) in
            if let error = error{
                print("error fetching api: \(error.localizedDescription)")
            }
            
            print(data ?? "")
            
            guard let jsonData = data else{ return }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedData = try decoder.decode(WikiModel.self, from: jsonData)
                completion(decodedData)
            } catch let decodingError{
                print("Error decoding the data \(decodingError)")
            }
            
        }
        dataTask.resume()
    }
}

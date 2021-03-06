//
//  DataStore.swift
//  MoviesCatalog


import Foundation
import Alamofire

class DataStore {
    static var isPaginating = false
    
    static func getFilmsByGenresAndPages(pagination: Bool, page: Int, genreId: Int, completion: @escaping ([Result]) -> ()){
        if pagination {
            isPaginating = true
        }
        let params = ["api_key":"daf9f9e3d071bcb9d8028262fb015b8a", "include_adult":"false", "page": page, "with_genres":  genreId] as [String : Any]
        let filmListBaseUrl = "https://api.themoviedb.org/3/discover/movie"
        let request = AF.request(filmListBaseUrl, method: .get, parameters: params).validate()
        request.responseJSON {(myData) in
            switch myData.result {
            case .success(_):
                let filmList = try? JSONDecoder().decode(Movie.self, from: myData.data!)
                if filmList != nil{
                        completion(filmList!.results)
                        if pagination {
                            self.isPaginating = false
                        }
                    }else{
                        print("the problem occured while data loading")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

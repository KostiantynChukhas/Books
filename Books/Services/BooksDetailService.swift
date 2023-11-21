//
//  BooksDetailService.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 21.11.2023.
//

import Foundation
import FirebaseRemoteConfig

protocol BooksDetailServiceType: Service {
    func fetchBooksDetail(completion: @escaping SimpleClosure<BooksDetailModel>)
}

class BooksDetailService: BooksDetailServiceType {
    
    func fetchBooksDetail(completion: @escaping SimpleClosure<BooksDetailModel>) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        // Enable developer mode to make fetch requests more frequently (for testing purposes)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { (status, error) in
            if status == .success {
                print("Config fetched successfully!")
                remoteConfig.activate { (_, _) in
                    self.applyRemoteConfig(completion: completion)
                }
            } else {
                print("Config fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
   private func applyRemoteConfig(completion: @escaping SimpleClosure<BooksDetailModel>) {
        let yourJsonData = RemoteConfig.remoteConfig()["details_carousel"].stringValue ?? "{}"
        
        if let jsonData = yourJsonData.data(using: .utf8) {
            do {
                let bookDetailModel = try JSONDecoder().decode(BooksDetailModel.self, from: jsonData)
                completion(bookDetailModel)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        printDeinit(self)
    }
}

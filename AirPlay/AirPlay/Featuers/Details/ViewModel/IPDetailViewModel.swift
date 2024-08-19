//
//  IPDetailViewModel.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import Foundation

class IPDetailViewModel {
    var onComplete: ((Result<Bool, Error>) -> Void)?
    var onError: (() -> Void)?
    let dispatchGroup = DispatchGroup()
    var data : IPDetailsModel?
    
    func getIPAddress() {
        let manager = NetworkManager.shared
        let apiUrl = URL(string: APIEndPoints.urlIP)!
        let getRequest = manager.createRequest(url: apiUrl, method: .get)
        dispatchGroup.enter()
        manager.performRequest(request: getRequest) { [weak self] (result: Result<IPDetailsModel, Error>) in
            self?.dispatchGroup.leave()
            switch result {
            case .success(let data):
                if let ip = data.ip {
                    self?.getIPAddressDetils(ip)
                }
            case .failure(let error):
                self?.onComplete?(.failure(error))
                
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All network requests completed.")
        }
    }
    
    func getIPAddressDetils(_ ip: String) {
        let manager = NetworkManager.shared
        let urlString = APIEndPoints.urlDetailsIP + ip + APIConstants.geo
        let apiUrl = URL(string: urlString)!
        let getRequest = manager.createRequest(url: apiUrl, method: .get)
        dispatchGroup.enter()
        manager.performRequest(request: getRequest) { [weak self] (result: Result<IPDetailsModel, Error>) in
            self?.dispatchGroup.leave()
            switch result {
            case .success(let data):
                self?.data = data
                self?.onComplete?(.success(true))
            case .failure(let error):
                self?.onComplete?(.failure(error))
            }
        }
    }
}

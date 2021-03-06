//
//  ContentProvider.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import Foundation

protocol DataProviderProtocol: PostalCodeRepository {}

final class ContentProvider: DataProviderProtocol {
    
    private let api: APIProtocol
    
    init(api: APIProtocol = API(session: URLSession.shared)) {
        self.api = api
    }
    
    func getPostalCode(completion: @escaping (Result<[PostalCode], APIError>) -> ([PostalCode])) {
        let params = [String: String]()
        api.send(path: .postalCode, method: .GET, parameters: params, completion: completion)
    }
}


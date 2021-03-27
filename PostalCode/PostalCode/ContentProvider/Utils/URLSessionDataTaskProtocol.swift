//
//  URLSessionDataTaskProtocol.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

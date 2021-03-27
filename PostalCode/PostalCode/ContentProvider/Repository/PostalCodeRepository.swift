//
//  PostalCodeRepository.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import Foundation

protocol PostalCodeRepository {
  func getPostalCode(completion: @escaping (Result<[PostalCode], APIError>) -> ([PostalCode]))
}

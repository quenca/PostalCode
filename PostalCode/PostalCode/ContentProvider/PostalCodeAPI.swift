//
//  PostalCodeAPI.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 26/03/21.
//

import Foundation

enum APIError: Error {
  case unavailable
}

enum RequestType: String {
  case GET, POST, PUT, DELETE
}

enum PathType: String {
  case postalCode
}

protocol APIProtocol {
  func send(path: PathType,
                      method: RequestType, parameters: [String: String],
                      completion: @escaping (Result<[PostalCode], APIError>) -> ([PostalCode]))
}

public class API: APIProtocol {

  private let baseURL = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol) {
    self.session = session
  }

  private func buildRequest(path: PathType,
                            method: RequestType,
                            parameters: [String: String]) -> URLRequest {
    let url = baseURL
    guard var components = URLComponents(string: url) else {
      fatalError("Invalid URL")
    }

    components.queryItems = parameters.map { key, value in
      URLQueryItem(name: key, value: value)
    }

    var request = URLRequest(url: components.url!)
    request.httpMethod = method.rawValue
    return request
  }

  func send(path: PathType,
                      method: RequestType, parameters: [String: String],
                      completion: @escaping (Result<[PostalCode], APIError>) -> ([PostalCode]))
    {
      let request = buildRequest(path: path, method: method, parameters: parameters)
      var postalCodes = [PostalCode]()
      let task = self.session.dataTask(with: request) { data, _, _ in
        do {
            
            if let data = NSData(contentsOf: request.url!) {
                let dataString = String(decoding: data, as: UTF8.self)
                print(dataString)
                
                //split that string into an array of "rows" of data.  Each row is a string.
                var rows = dataString.components(separatedBy: "\n")

                //if you have a header row, remove it here
                rows.removeFirst()

                //now loop around each row, and split it into each of its columns
                for row in rows {
                    let columns = row.components(separatedBy: ",")

                    //check that we have enough columns
                    if columns.count == 17 {
                        _ = columns[0]
                        _ = columns[1]
                        _ = columns[2]
                            let nome_localidade = columns[3]
                        _ = columns[4]
                        _ = columns[5]
                        _ = columns[6]
                        _ = columns[7]
                        _ = columns[8]
                        _ = columns[9]
                        _ = columns[10]
                        _ = columns[11]
                        _ = columns[12]
                        _ = columns[13]
                            let num_cod_postal = columns[14]
                            let ext_cod_postal = columns[15]
                        _ = columns[16]
                        let codPostal = num_cod_postal + "-" + ext_cod_postal
                            let postalCode = PostalCode(nome_localidade: nome_localidade, num_cod_postal: codPostal)
                        postalCodes.append(postalCode)
                    }
                }
            }
            
            completion(.success(postalCodes))
        } catch {
          completion(.failure(APIError.unavailable))
        }
      }

      task.resume()
  }
}

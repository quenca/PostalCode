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
                            let cod_distrito = columns[0]
                            let cod_concelho = columns[1]
                            let cod_localidade = columns[2]
                            let nome_localidade = columns[3]
                            let cod_arteria = columns[4]
                            let tipo_arteria = columns[5]
                            let prep1 = columns[6]
                            let titulo_arteria = columns[7]
                            let prep2 = columns[8]
                            let nome_arteria = columns[9]
                            let local_arteria = columns[10]
                            let troco = columns[11]
                            let porta = columns[12]
                            let cliente = columns[13]
                            let num_cod_postal = columns[14]
                            let ext_cod_postal = columns[15]
                            let desig_postal = columns[16]

                            let postalCode = PostalCode(cod_distrito: cod_distrito, cod_concelho: cod_concelho, cod_localidade: cod_localidade, nome_localidade: nome_localidade, cod_arteria: cod_arteria, tipo_arteria: tipo_arteria, prep1: prep1, titulo_arteria: titulo_arteria, prep2: prep2, nome_arteria: nome_arteria, local_arteria: local_arteria, troco: troco, porta: porta, cliente: cliente, num_cod_postal: num_cod_postal, ext_cod_postal: ext_cod_postal, desig_postal: desig_postal)
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

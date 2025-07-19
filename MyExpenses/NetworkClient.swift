//
//  NetworkClient.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 13.07.2025.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case httpError(Int, Data?)
    case decodingError(Error)
    case encodingError(Error)
    case unknown(Error)
}

struct NetworkClient {
    let baseURL: URL
    let bearerToken: String
    private let urlSession: URLSession = .shared
    
    func request<RequestBody: Encodable, ResponseBody: Decodable>(
        endpoint: String,
        method: String = "GET",
        requestBody: RequestBody? = nil
    ) async throws -> ResponseBody {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
//        if let body = requestBody {
//            do {
//                //let jsonData = try JSONEncoder().encode(body)
//                //request.httpBody = jsonData
//            } catch {
//                throw NetworkError.encodingError(error)
//            }
//        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode, data)
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ResponseBody.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}



struct EmptyRequest: Encodable {}
struct EmptyResponse: Decodable {}

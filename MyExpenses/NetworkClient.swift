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

        if let body = requestBody, method != "GET" {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted

                let jsonData = try encoder.encode(body)
                request.httpBody = jsonData

                print(" URL: \(request.url?.absoluteString ?? "")")
                print(" Метод: \(method)")
                print(" Заголовки: \(request.allHTTPHeaderFields ?? [:])")
                print(" JSON Body:\n\(String(data: jsonData, encoding: .utf8) ?? "")")

            } catch {
                print(" Ошибка кодирования тела: \(error)")
                throw NetworkError.encodingError(error)
            }
        }


        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode, data)
            }

            do {
                return try JSONDecoder().decode(ResponseBody.self, from: data)
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

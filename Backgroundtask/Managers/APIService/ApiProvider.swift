//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

//
//  ApiProvider.swift
//  Bothofus
//
//  Created by Nitanta Adhikari on 6/28/21.
//

import Foundation
import Combine

class Container {
    /// Decoder used throughout the application
    static let jsonDecoder: JSONDecoder = JSONDecoder()
    
    /// Encoder used throughout the application
    static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
}

class APIProvider<Endpoint: EndpointProtocol> {
    
    // MARK: - Request data
    
    /// Get data for the endpoint
    /// - Parameter endpoint: endpoint
    /// - Returns: publisher containing either data or error
    func getData(from endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        guard let request = performRequest(for: endpoint) else {
            return Fail(error: APIProviderErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return loadData(with: request)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Request building
    
    /// Build the url request for the endpoint
    /// - Parameter endpoint: endpoint
    /// - Returns: urlrequest for the endpoint
    func performRequest(for endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.absoluteURL) else {
            return nil
        }
        
        var bodyData: Data?
        switch endpoint.encoding {
        case .url:
            urlComponents.queryItems = endpoint.params.compactMap({ param -> URLQueryItem in
                return URLQueryItem(name: param.key, value: param.value as? String)
            })
        case .json:
            if !endpoint.arrayParams.isEmpty {
                bodyData = try? JSONSerialization.data(withJSONObject: endpoint.arrayParams, options: .prettyPrinted)
            } else {
                bodyData = try? JSONSerialization.data(withJSONObject: endpoint.params, options: .prettyPrinted)
            }
        case .urlformencoded:
            urlComponents.queryItems = endpoint.params.compactMap({ param -> URLQueryItem in
                return URLQueryItem(name: param.key, value: param.value as? String)
            })
            bodyData = urlComponents.query?.data(using: .utf8)
            urlComponents = URLComponents(string: endpoint.absoluteURL)!
        default: break
        }

        guard let url = urlComponents.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = bodyData
        
        
        endpoint.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
    
    // MARK: - Getting data
    
    
    /// Perform network call and load data
    /// - Parameter request: url request
    /// - Returns: publisher containing either data or error
    private func loadData(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ error -> Error in
                return APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                return $0.data
            }
            .eraseToAnyPublisher()
    }
}

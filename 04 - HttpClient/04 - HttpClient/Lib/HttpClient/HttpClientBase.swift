//
//  HttpClientBase.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

struct HttpClientBase: IHttpClientBase {
    private let baseUrl: URL
    private let urlSession: URLSession
    private let urlRequestDecorators: [URLRequestDecorator]?
    
    init?(baseUrl: String, urlSession: URLSession = URLSession.shared, urlRequestDecorators: [URLRequestDecorator]? = nil) {
        guard let url = URL(string: baseUrl) else {
            return nil
        }
        self.baseUrl = url
        self.urlSession = urlSession
        self.urlRequestDecorators = urlRequestDecorators
    }
        
    func data<Output: Encodable, Input: Decodable>(
        _ type: Input.Type,
        path: String,
        httpMethod: HttpMethod,
        queryParameters: URLRequestQueryParameters? = nil,
        httpHeaders: URLRequestHttpHeaders? = nil,
        output: Output
    ) async -> Result<Input, HttpClientError> {
                
        var url = baseUrl.appending(path: path)
        
        if let queryParameters {
            url = url.appending(
                queryItems: queryParameters.map(
                    {(key, value) in
                        URLQueryItem(name: key, value: value)
                    }
                ))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let httpHeaders {
            for (key, value) in httpHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if output is HttpClientNoOutput {} else {
            do {
                request.httpBody = try JSONEncoder().encode(output)
                request.setValue(HttpContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
            } catch (let error) {
                return .failure(.outputEncodingFailed(error: error))
            }
        }
        
        if let urlRequestDecorators {
            urlRequestDecorators.forEach {
                request = $0(request)
            }
        }
        
        do {
            let (responseData, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.incorrectResponseType)
            }
            
            if (400..<500).contains(httpResponse.statusCode) {
                return .failure(.clientError(code: httpResponse.statusCode))
            }
            
            if (500..<600).contains(httpResponse.statusCode) {
                return .failure(.serverError(code: httpResponse.statusCode))
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(.incorrectResponseCode(code: httpResponse.statusCode))
            }
            
            guard type != HttpClientNoInput.self else {
                return .success(HttpClientNoInput(responseCode: httpResponse.statusCode) as! Input)
            }
                        
            do {
                return .success(try JSONDecoder().decode(type, from: responseData))
            } catch (let error) {
                return .failure(.inputDecodingFailed(error: error))
            }
            
        } catch (let error) {
            if Task.isCancelled {
                return .failure(.canceled)
            }
            
            if let error = error as? URLError {
                return .failure(.urlError(error: error))
            }
            
            return .failure(.unknown(error: error))
        }
    }
}

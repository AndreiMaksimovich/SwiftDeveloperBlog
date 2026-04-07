//
//  HttpClient.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

struct HttpClient: IHttpClient {
    
    private let baseHttpClient: any IHttpClientBase
    
    init(baseHttpClient: any IHttpClientBase) {
        self.baseHttpClient = baseHttpClient
    }
    
    func data<Output>(_ type: Output.Type, path: String, httpMethod: HttpMethod, queryParameters: URLRequestQueryParameters? = nil, httpHeaders: URLRequestHttpHeaders? = nil) async -> Result<Output, HttpClientError> where Output : Decodable {
        return await baseHttpClient.data(Output.self, path: path, httpMethod: httpMethod, queryParameters: queryParameters, httpHeaders: httpHeaders, output: HttpClientNoOutput())
    }
    
    func data(path: String, httpMethod: HttpMethod, queryParameters: URLRequestQueryParameters? = nil, httpHeaders: URLRequestHttpHeaders? = nil) async -> Result<Int, HttpClientError> {
        let result = await baseHttpClient.data(HttpClientNoInput.self, path: path, httpMethod: httpMethod, queryParameters: queryParameters, httpHeaders: httpHeaders, output: HttpClientNoOutput())
        return switch(result) {
            case .success(let noInput): .success(noInput.responseCode)
            case .failure(let error): .failure(error)
        }
    }
    
    func data<Output>(path: String, httpMethod: HttpMethod, queryParameters: URLRequestQueryParameters? = nil, httpHeaders: URLRequestHttpHeaders? = nil, output: Output) async -> Result<Int, HttpClientError> where Output : Encodable {
        let result = await baseHttpClient.data(HttpClientNoInput.self, path: path, httpMethod: httpMethod, queryParameters: queryParameters, httpHeaders: httpHeaders, output: output)
        return switch(result) {
            case .success(let noInput): .success(noInput.responseCode)
            case .failure(let error): .failure(error)
        }
    }
    
    func data<Output, Input>(_ type: Input.Type, path: String, httpMethod: HttpMethod, queryParameters: URLRequestQueryParameters? = nil, httpHeaders: URLRequestHttpHeaders? = nil, output: Output) async -> Result<Input, HttpClientError> where Output : Encodable, Input : Decodable {
        return await baseHttpClient.data(Input.self, path: path, httpMethod: httpMethod, queryParameters: queryParameters, httpHeaders: httpHeaders, output: output)
    }
}

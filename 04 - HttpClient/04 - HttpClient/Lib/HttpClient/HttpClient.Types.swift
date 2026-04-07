//
//  WebService.Types.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

nonisolated struct HttpClientNoOutput: Encodable {}
nonisolated struct HttpClientNoInput: Decodable { var responseCode: Int }

typealias URLRequestDecorator = (URLRequest) -> URLRequest
typealias URLRequestQueryParameters = [String:String]
typealias URLRequestHttpHeaders = [String:String]

enum HttpClientError: Error {
    case incorrectResponseType
    case unknown(error: Error)
    case canceled
    case clientError(code: Int)
    case serverError(code: Int)
    case incorrectResponseCode(code: Int)
    case outputEncodingFailed(error: Error)
    case inputDecodingFailed(error: Error)
    case urlError(error: URLError?)
}

protocol IHttpClientBase {
    func data<Output: Encodable, Input: Decodable>(
        _ inputType: Input.Type,
        path: String,
        httpMethod: HttpMethod,
        queryParameters: URLRequestQueryParameters?,
        httpHeaders: URLRequestHttpHeaders?,
        output: Output
    ) async -> Result<Input, HttpClientError>
}

protocol IHttpClient: IHttpClientBase {
    func data<Input: Decodable>(
        _ inputType: Input.Type,
        path: String,
        httpMethod: HttpMethod,
        queryParameters: URLRequestQueryParameters?,
        httpHeaders: URLRequestHttpHeaders?
    ) async -> Result<Input, HttpClientError>
    
    func data(
        path: String,
        httpMethod: HttpMethod,
        queryParameters: URLRequestQueryParameters?,
        httpHeaders: URLRequestHttpHeaders?
    ) async -> Result<Int, HttpClientError>
    
    func data<Output: Encodable>(
        path: String,
        httpMethod: HttpMethod,
        queryParameters: URLRequestQueryParameters?,
        httpHeaders: URLRequestHttpHeaders?,
        output: Output
    ) async -> Result<Int, HttpClientError>
}

enum HttpMethod: String, Identifiable, Equatable {
    var id: String {
        self.rawValue
    }
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HttpContentType: String, Identifiable, Equatable  {
    var id: String {
        self.rawValue
    }
    case text = "text/plain"
    case json = "application/json"
    case xml = "application/xml"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case pdf = "application/pdf"
    case zip = "application/zip"
}



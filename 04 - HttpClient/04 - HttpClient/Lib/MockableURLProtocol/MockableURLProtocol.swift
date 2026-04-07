//
//  MockableURLProtocol.swift
//  04 - HttpClient
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

nonisolated public enum URLProtocolMockResponse {
    case error(error: Error)
    case data(responseCode: Int, data: Data?, httpVersion: String?, headerFields: [String:String]?)
    
    public static func getData(responseCode: Int, data: Data? = nil, httpVersion: String? = nil, headerFields: [String:String]? = nil) -> URLProtocolMockResponse {
        .data(responseCode: responseCode, data: data, httpVersion: httpVersion, headerFields: headerFields)
    }
}

nonisolated public protocol IURLProtocolResponseMock {
    func isApplicable(for request: URLRequest) -> Bool
    func getResponse(for request: URLRequest) -> URLProtocolMockResponse
}

nonisolated public struct URLProtocolResponseMockSimple: IURLProtocolResponseMock {
    public let response: URLProtocolMockResponse
    public let url: URL

    public init(url: URL, response: URLProtocolMockResponse) {
        self.response = response
        self.url = url
    }
    
    public init(url: String, responseCode: Int, data: Data? = nil, httpVersion: String? = nil, headerFields: [String:String]? = nil) {
        self.url = URL(string: url)!
        self.response = .data(responseCode: responseCode, data: data, httpVersion: httpVersion, headerFields: headerFields)
    }
    
    public func isApplicable(for request: URLRequest) -> Bool {
        request.url == url
    }
    
    public func getResponse(for request: URLRequest) -> URLProtocolMockResponse {
        response
    }
}

nonisolated public struct URLProtocolResponseMockWildcard: IURLProtocolResponseMock {
    private let _isApplicable: (URLRequest) -> Bool
    private let _getResponse: (URLRequest) -> URLProtocolMockResponse
    
    init(isApplicable: @escaping (URLRequest) -> Bool, getResponse: @escaping (URLRequest) -> URLProtocolMockResponse) {
        self._isApplicable = isApplicable
        self._getResponse = getResponse
    }
    
    public func isApplicable(for request: URLRequest) -> Bool {
        _isApplicable(request)
    }
    
    public func getResponse(for request: URLRequest) -> URLProtocolMockResponse {
        _getResponse(request)
    }
}

nonisolated public class MockableURLProtocol: URLProtocol {
    private static let logTag = "MockableURLProtocol"
    
    nonisolated(unsafe) public static var wildcardResponseMocks: [any IURLProtocolResponseMock] = []
    nonisolated(unsafe) public static var urlResponseMocks: [URL: any IURLProtocolResponseMock] = [:]
    nonisolated(unsafe) public static var allowUnmockedRequest: Bool = false
    
    public static func clearResponseMocks() {
        urlResponseMocks.removeAll()
        wildcardResponseMocks.removeAll()
    }
    
    public static func registerWildcardMocks(_ mocks: any IURLProtocolResponseMock...) {
        mocks.forEach {mock in
            wildcardResponseMocks.append(mock)
        }
    }
    
    public static func registerUrlMocks(_ mocks: (url: URL, any IURLProtocolResponseMock)...) {
        mocks.forEach { (url, mock) in
            urlResponseMocks[url] = mock
        }
    }
    
    public static func registerSimpleMocks(_ mocks: URLProtocolResponseMockSimple...) {
        mocks.forEach {mock in
            urlResponseMocks[mock.url] = mock
        }
    }
    
    override public class func canInit(with request: URLRequest) -> Bool {
        print(MockableURLProtocol.logTag, "canInit", request)
        
        for mock in wildcardResponseMocks {
            if mock.isApplicable(for: request) {
               return true
            }
        }
        
        if let url = request.url {
            return urlResponseMocks[url] != nil
        }
        
        if !allowUnmockedRequest {
            print(logTag, "No mock for URLRequest", request)
            fatalError()
        }
        
        return true
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        print(MockableURLProtocol.logTag, "startLoading", request)
        
        guard
            let client = self.client,
            let url = self.request.url,
            let mock = MockableURLProtocol.urlResponseMocks[url] ?? MockableURLProtocol.wildcardResponseMocks.first(where: {$0.isApplicable(for: request)})
        else {
            print(MockableURLProtocol.logTag, "startLoading failed", request)
            fatalError()
        }
        
        let response = mock.getResponse(for: request)
                
        if case .error(let error) = response {
            client.urlProtocol(self, didFailWithError: error)
            client.urlProtocolDidFinishLoading(self)
            return
        }
        
        guard case .data(let responseCode, let data, let httpVersion, let headerFields) = response else {
            print(MockableURLProtocol.logTag, "Unable to decode mock response", request)
            fatalError()
        }
        
        guard let httpResponse = HTTPURLResponse(url: url, statusCode: responseCode, httpVersion: httpVersion, headerFields: headerFields) else {
            print(MockableURLProtocol.logTag, "Unable to create HTTPURLResponse", request)
            fatalError()
        }
        
        client.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
        
        if let data {
            client.urlProtocol(self, didLoad: data)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override public func stopLoading() {}
}

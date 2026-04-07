//
//  DemoApiMockBaseHttpClient.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 11/04/2026.
//

#if DEBUG

import Foundation

let demoApiMockBaseUrl = "mock://demo-api"

func instantiateDemoApiMockBaseHttpClient() -> any IHttpClientBase {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockableURLProtocol.self]
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    
    MockableURLProtocol.clearResponseMocks()
    MockableURLProtocol.allowUnmockedRequest = false
    
    MockableURLProtocol.registerSimpleMocks(
        .init(url: "\(demoApiMockBaseUrl)/posts/", responseCode: 200, data: demoApiMockHttpDataPosts),
        .init(url: "\(demoApiMockBaseUrl)/todos/", responseCode: 200, data: demoApiMockHttpDataToDos),
        .init(url: "\(demoApiMockBaseUrl)/albums/", responseCode: 200, data: demoApiMockHttpDataAlbums),
    )
    
    return HttpClientBase(baseUrl: demoApiMockBaseUrl, urlSession: .init(configuration: config))!
}

func instantiateDemoApiMockBasedOnFakeNetworkData() -> any IDemoAPI {
    DemoAPIClient(httpClient: HttpClient(baseHttpClient: instantiateDemoApiMockBaseHttpClient()))
}

#endif

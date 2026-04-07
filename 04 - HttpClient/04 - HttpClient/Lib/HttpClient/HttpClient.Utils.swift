//
//  HttpClient.Utils.swift
//  04 - HttpClient
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

func instantiateHttpClient(baseUrl: String) -> (any IHttpClient)? {
    if let baseHttpClient = HttpClientBase(baseUrl: baseUrl, urlSession: URLSession.shared) {
        return HttpClient(baseHttpClient: baseHttpClient)
    }
    
    return nil
}

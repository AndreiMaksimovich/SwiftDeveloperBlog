//
//  DemoAPIClient.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

struct DemoAPIClient: IDemoAPI {
    private let httpClient: any IHttpClient
    
    init(httpClient: any IHttpClient) {
        self.httpClient = httpClient
    }
        
    func fetchPosts() async throws -> [Post] {
        let result = await httpClient.data([Post].self, path: "posts/", httpMethod: .get, queryParameters: nil, httpHeaders: nil)
        switch result {
            case .success(let posts):
                return posts
            case .failure(let error):
                throw error
        }
    }
    
    func fetchAlbums() async throws -> [Album] {
        let result = await httpClient.data([Album].self, path: "albums/", httpMethod: .get, queryParameters: nil, httpHeaders: nil)
        switch result {
            case .success(let albums):
                return albums
            case .failure(let error):
                throw error
        }
    }
    
    func fetchToDos() async throws -> [ToDo] {
        let result = await httpClient.data([ToDo].self, path: "todos/", httpMethod: .get, queryParameters: nil, httpHeaders: nil)
        switch result {
            case .success(let todos):
                return todos
            case .failure(let error):
                throw error
        }
    }
}

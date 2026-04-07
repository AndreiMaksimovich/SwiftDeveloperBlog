//
//  DemoTypes.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

nonisolated struct Post: Codable {
    var userId: UInt
    var id: UInt
    var title: String
    var body: String
}

nonisolated struct ToDo: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

nonisolated struct Album: Codable {
    var userId: Int
    var id: Int
    var title: String
}

protocol IDemoAPI {
    func fetchPosts() async throws -> [Post]
    func fetchAlbums() async throws -> [Album]
    func fetchToDos() async throws -> [ToDo]
}



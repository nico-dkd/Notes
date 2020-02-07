//
//  Note.swift
//  App
//
//  Created by Nico Lassen on 07.02.20.
//

import Foundation
import Vapor
import FluentSQLite
import Authentication

final class Note: Codable {

    var id: Int?
    var headline: String
    var story: String
    var userID: User.ID
    
    init(headline: String, story: String, userID: User.ID) {
        
        self.headline = headline
        self.story = story
        self.userID = userID
    }
    
    final class PostableNote: Codable {
        
        var headline: String
        var story: String
    }
}

extension Note: Migration {
    
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
    
        return Database.create(self, on: conn) { (builder) in
        
            try addProperties(to: builder)
            builder.unique(on: \.id)
        }
    }
}

extension Note {
    
    var user: Parent<Note, User> {
        
        return parent(\.userID)
    }
}

extension Note: SQLiteModel {}
extension Note: Content {}
extension Note: Parameter {}
extension Note.PostableNote: Content {}

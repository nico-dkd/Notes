//
//  NoteController.swift
//  App
//
//  Created by Nico Lassen on 07.02.20.
//

import Foundation
import Vapor

final class NoteController { //: RouteCollection {
    
     static func createNote(_ req: Request) throws -> Future<Note> {
                
        let user = try req.requireAuthenticated(User.self)
                
        return try req.content.decode(Note.PostableNote.self).flatMap { postableNote in

            var id = 0
            if let userID = user.id {
                id = userID
            }

            let note = Note(headline: postableNote.headline, story: postableNote.story, userID: id)

            return note.create(on: req)
        }
    }
}

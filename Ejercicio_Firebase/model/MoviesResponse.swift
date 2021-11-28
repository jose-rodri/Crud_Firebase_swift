//
//  MoviesResponse.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 8/11/21.
//


import Foundation

// MARK: - UserResponse
struct MoviesResponse: Codable {
    let data: UserData
}

// MARK: - DataClass
struct UserData: Codable {
    let users: [User]
}

// MARK: - User
struct User: Codable {
    let id, name, email: String
}

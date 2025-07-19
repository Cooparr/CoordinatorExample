//
//  User.swift
//  CoordinatorExample
//
//  Created by Alexander Cooper on 19/07/2025.
//

import Foundation

struct User: Codable, Identifiable {
    private(set) var id = UUID()
    let name: String
    let email: String
    let age: Int
}

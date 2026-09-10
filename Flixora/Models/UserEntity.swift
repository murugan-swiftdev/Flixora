//
//  UserEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class UserEntity {

    @Attribute(.unique)
    var id: UUID

    var phoneNumber: String
    var email: String?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        phoneNumber: String,
        email: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.email = email
        self.createdAt = createdAt
    }
}

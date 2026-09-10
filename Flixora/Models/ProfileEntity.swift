//
//  ProfileEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class ProfileEntity {

    @Attribute(.unique)
    var id: UUID

    var name: String
    var avatarName: String
    var isKidsProfile: Bool
    var preferredLanguage: String

    init(
        id: UUID = UUID(),
        name: String,
        avatarName: String = "person.circle.fill",
        isKidsProfile: Bool = false,
        preferredLanguage: String = "English"
    ) {
        self.id = id
        self.name = name
        self.avatarName = avatarName
        self.isKidsProfile = isKidsProfile
        self.preferredLanguage = preferredLanguage
    }
}

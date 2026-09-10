//
//  SubscriptionEntity.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import Foundation
import SwiftData

@Model
final class SubscriptionEntity {

    @Attribute(.unique)
    var id: UUID

    var planName: String
    var isActive: Bool

    var startDate: Date
    var expiryDate: Date

    init(
        id: UUID = UUID(),
        planName: String = "Free",
        isActive: Bool = true,
        startDate: Date = .now,
        expiryDate: Date = .distantFuture
    ) {
        self.id = id
        self.planName = planName
        self.isActive = isActive
        self.startDate = startDate
        self.expiryDate = expiryDate
    }
}

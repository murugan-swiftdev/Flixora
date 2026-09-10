//
//  NotificationRouter.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import Observation

@Observable
final class NotificationRouter {

    var selectedNotificationType:
        FlixoraNotificationType?

    var selectedContentId: UUID?

    func handle(
        userInfo: [AnyHashable: Any]
    ) {

        if let typeString =
            userInfo[
                FlixoraNotificationKeys.type
            ] as? String {

            selectedNotificationType =
                FlixoraNotificationType(
                    rawValue: typeString
                )
        }

        if let contentIdString =
            userInfo[
                FlixoraNotificationKeys.contentId
            ] as? String {

            selectedContentId =
                UUID(
                    uuidString: contentIdString
                )
        }
    }

    func clear() {

        selectedNotificationType = nil
        selectedContentId = nil
    }
}

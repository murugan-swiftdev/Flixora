//
//  OrientationManager.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import UIKit

enum OrientationManager {

    static func lockToPortrait() {

        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {

            scene.requestGeometryUpdate(
                .iOS(
                    interfaceOrientations: .portrait
                )
            )
        }
    }

    static func lockToLandscape() {

        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {

            scene.requestGeometryUpdate(
                .iOS(
                    interfaceOrientations: .landscape
                )
            )
        }
    }

    static func unlockOrientation() {

        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {

            scene.requestGeometryUpdate(
                .iOS(
                    interfaceOrientations:
                        .all
                )
            )
        }
    }
}

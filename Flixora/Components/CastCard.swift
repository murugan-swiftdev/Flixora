//
//  CastCard.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct CastCard: View {

    let name: String
    let role: String
    let image: String

    var body: some View {

        VStack(spacing: 7) {

            Image(image)
                .resizable()
                .scaledToFill()
                .frame(
                    width: 72,
                    height: 72
                )
                .clipShape(Circle())

            Text(name)
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )

            Text(role)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(width: 90)
    }
}

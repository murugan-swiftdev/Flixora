//
//  ContinueWatchingCard.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct ContinueWatchingCard: View {

    let content: OTTContent

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            ZStack(alignment: .bottom) {

                Image(content.posterName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 220,
                        height: 125
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
                    .clipped()

                LinearGradient(
                    colors: [
                        .clear,
                        .black.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )

                Image(
                    systemName: "play.circle.fill"
                )
                .font(.system(size: 42))
                .foregroundStyle(.white)

                VStack(spacing: 0) {

                    GeometryReader { geometry in

                        ZStack(alignment: .leading) {

                            Rectangle()
                                .fill(
                                    .white.opacity(0.3)
                                )

                            Rectangle()
                                .fill(.red)
                                .frame(
                                    width:
                                        geometry.size.width * 0.45
                                )
                        }
                    }
                    .frame(height: 4)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 7)
            }

            Text(content.title)
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .lineLimit(1)
        }
        .frame(width: 220)
    }
}

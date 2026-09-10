//
//  HeroBannerView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct HeroBannerView: View {

    let content: OTTContent

    var body: some View {

        ZStack(alignment: .bottomLeading) {

            Image(content.backdropName)
                .resizable()
                .scaledToFill()
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 420)
                .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(
                alignment: .leading,
                spacing: 10
            ) {

                Spacer()

                Text(content.title)
                    .font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)

                Text(
                    "\(content.releaseYear) • \(content.genre) • \(content.language)"
                )
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))

                Text(content.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)

                Button {

                } label: {

                    Label(
                        "Watch Now",
                        systemImage: "play.fill"
                    )
                    .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.black)
            }
            .padding(20)
        }
        .frame(height: 420)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
        .padding(.horizontal, 12)
    }
}

//
//  MovieCard.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct MovieCard: View {

    let content: OTTContent

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            // MARK: - Poster

            ZStack(alignment: .topTrailing) {

                Image(content.posterName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 130,
                        height: 190
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .stroke(
                            .white.opacity(0.08),
                            lineWidth: 1
                        )
                    }

                // MARK: - Premium Badge

                if content.isPremium {
                    Text("PREMIUM")
                        .font(
                            .system(
                                size: 8,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(.red)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 5
                            )
                        )
                        .padding(7)
                }
            }

            // MARK: - Title

            Text(content.title)
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .lineLimit(1)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

            // MARK: - Rating

            HStack(spacing: 4) {

                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(.yellow)

                Text(
                    String(
                        format: "%.1f",
                        content.rating
                    )
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .frame(width: 130)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(content.title), rating \(String(format: "%.1f", content.rating))\(content.isPremium ? ", premium" : "")"
        )
    }
}

//
//  ContentSection.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct ContentSection: View {

    let title: String
    let items: [OTTContent]

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack {

                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                Button("See All") {

                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {

                HStack(spacing: 14) {

                    ForEach(items) { item in

                        NavigationLink {

                            MovieDetailsView(
                                content: item
                            )

                        } label: {

                            MovieCard(
                                content: item
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 245)
        }
    }
}

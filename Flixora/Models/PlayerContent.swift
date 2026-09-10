//
//  PlayerContent.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import Foundation

struct PlayerContent {

    let title: String
    let videoName: String?
    let videoURL: URL?

    init(
        title: String,
        videoName: String? = nil,
        videoURL: URL? = nil
    ) {
        self.title = title
        self.videoName = videoName
        self.videoURL = videoURL
    }
}

//
//  FlixoraVideoPlayerView.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI
import AVKit

struct FlixoraVideoPlayerView: View {

    let content: PlayerContent

    @Environment(\.dismiss)
    private var dismiss

    @State private var player: AVPlayer

    @State private var isPlaying = false
    @State private var isFullscreen = false

    @State private var currentTime: Double = 0
    @State private var duration: Double = 1

    @State private var volume: Double = 1.0
    @State private var previousVolume: Double = 1.0

    @State private var selectedLanguage = "English"
    @State private var selectedSubtitle = "Off"
    @State private var selectedSpeed = 1.0

    @State private var isSeeking = false

    @State private var timeObserverToken: Any?

    // MARK: - Init

    init(content: PlayerContent) {

        self.content = content

        let resolvedURL: URL

        if let url = content.videoURL {

            resolvedURL = url

        } else if let videoName = content.videoName,
                  let bundledURL = Bundle.main.url(
                    forResource: videoName,
                    withExtension: "mp4"
                  ) {

            resolvedURL = bundledURL

        } else if let bundledURL = Bundle.main.url(
            forResource: "flixora_demo",
            withExtension: "mp4"
        ) {

            resolvedURL = bundledURL

        } else {

            resolvedURL = URL(
                string:
                    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
            )!
        }

        _player = State(
            initialValue: AVPlayer(
                url: resolvedURL
            )
        )
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VideoPlayer(player: player)
                    .ignoresSafeArea()

                controlsOverlay(geometry: geometry)
            }
        }
        .statusBarHidden(isFullscreen)
        .onAppear {
            startPlayer()
        }
        .onDisappear {
            stopPlayer()
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Player Lifecycle

private extension FlixoraVideoPlayerView {

    func startPlayer() {
        player.volume = Float(volume)
        addTimeObserver()

        player.playImmediately(
            atRate: Float(selectedSpeed)
        )

        isPlaying = true
    }

    func stopPlayer() {
        removeTimeObserver()

        player.pause()

        isPlaying = false

        OrientationManager.lockToPortrait()
    }

    func addTimeObserver() {

        removeTimeObserver()

        timeObserverToken =
            player.addPeriodicTimeObserver(
                forInterval:
                    CMTime(
                        seconds: 0.5,
                        preferredTimescale: 600
                    ),
                queue: .main
            ) { time in

                guard !isSeeking else {
                    return
                }

                let seconds = time.seconds

                guard seconds.isFinite else {
                    return
                }

                currentTime = seconds

                if let item = player.currentItem {

                    let total =
                        item.duration.seconds

                    if total.isFinite && total > 0 {

                        duration = total
                    }
                }
            }
    }

    func removeTimeObserver() {

        guard let token = timeObserverToken else {
            return
        }

        player.removeTimeObserver(token)

        timeObserverToken = nil
    }
}

// MARK: - Controls Overlay

private extension FlixoraVideoPlayerView {

    func controlsOverlay(
        geometry: GeometryProxy
    ) -> some View {

        ZStack {

            LinearGradient(
                colors: [
                    .black.opacity(0.70),
                    .clear,
                    .black.opacity(0.88)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack {
                topBar

                Spacer()

                centerControls

                Spacer()

                bottomControls
            }
            .padding(
                .horizontal,
                isFullscreen ? 30 : 16
            )
            .padding(.vertical, 12)
        }
    }
}

// MARK: - Top Bar

private extension FlixoraVideoPlayerView {

    var topBar: some View {

        HStack(spacing: 14) {

            // MARK: Minimize / Close

            Button {

                closePlayer()

            } label: {

                Image(
                    systemName:
                        isFullscreen
                        ? "chevron.down"
                        : "xmark"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    width: 40,
                    height: 40
                )
                .background(
                    .black.opacity(0.45)
                )
                .clipShape(Circle())
            }

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(content.title)
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 6) {

                    Text("FLIXORA")

                    Text("•")

                    Text(selectedLanguage)
                }
                .font(.caption)
                .foregroundStyle(
                    .white.opacity(0.7)
                )
            }

            Spacer()

            languageMenu

            subtitleMenu

            settingsMenu
        }
    }
}

// MARK: - Center Controls

private extension FlixoraVideoPlayerView {

    var centerControls: some View {

        HStack(spacing: 48) {

            Button {

                seek(by: -10)

            } label: {

                VStack(spacing: 3) {

                    Image(
                        systemName:
                            "gobackward.10"
                    )
                    .font(
                        .system(size: 30)
                    )

                    Text("10")
                        .font(.caption2)
                }
                .foregroundStyle(.white)
            }

            Button {
                seek(by: -10)
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 30))

                    Text("10")
                        .font(.caption2)
                }
                .foregroundStyle(.white)
            }

            Button {

                seek(by: 10)

            } label: {

                VStack(spacing: 3) {

                    Image(
                        systemName:
                            "goforward.10"
                    )
                    .font(
                        .system(size: 30)
                    )

                    Text("10")
                        .font(.caption2)
                }
                .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - Bottom Controls

private extension FlixoraVideoPlayerView {

    var bottomControls: some View {

        VStack(spacing: 8) {

            progressSlider

            HStack {

                Text(
                    formatTime(currentTime)
                )

                Spacer()

                Text(
                    formatTime(duration)
                )
            }
            .font(.caption)
            .foregroundStyle(.white)

            HStack(spacing: 20) {

                volumeControl

                Spacer()

                speedMenu

                fullscreenButton
            }
        }
    }
}

// MARK: - Progress

private extension FlixoraVideoPlayerView {

    var progressSlider: some View {

        Slider(
            value:
                Binding(
                    get: {
                        currentTime
                    },
                    set: { value in

                        currentTime = value
                    }
                ),
            in: 0...max(duration, 1),
            onEditingChanged: { editing in

                isSeeking = editing

                if !editing {

                    seek(
                        to: currentTime
                    )
                }
            }
        )
        .tint(.red)
    }
}

// MARK: - Volume

private extension FlixoraVideoPlayerView {

    var volumeControl: some View {

        HStack(spacing: 8) {

            Button {

                toggleMute()

            } label: {

                Image(
                    systemName:
                        volume == 0
                        ? "speaker.slash.fill"
                        : volume < 0.5
                        ? "speaker.wave.1.fill"
                        : "speaker.wave.2.fill"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
            }

            Slider(
                value: $volume,
                in: 0...1
            )
            .frame(width: 90)
            .tint(.white)
            .onChange(of: volume) {

                player.volume =
                    Float(volume)

                if volume > 0 {

                    previousVolume = volume
                }
            }
        }
    }

    func toggleMute() {

        if volume > 0 {

            previousVolume = volume
            volume = 0

        } else {

            volume =
                previousVolume > 0
                ? previousVolume
                : 1
        }

        player.volume =
            Float(volume)
    }
}

// MARK: - Playback Speed

private extension FlixoraVideoPlayerView {

    var speedMenu: some View {

        Menu {

            ForEach(
                [0.5, 1.0, 1.25, 1.5, 2.0],
                id: \.self
            ) { speed in

                Button {

                    selectedSpeed = speed

                    if isPlaying {

                        player.rate =
                            Float(speed)
                    }

                } label: {

                    HStack {

                        Text(
                            String(
                                format:
                                    "%.2gx",
                                speed
                            )
                        )

                        if selectedSpeed == speed {

                            Image(
                                systemName:
                                    "checkmark"
                            )
                        }
                    }
                }
            }

        } label: {

            HStack(spacing: 4) {

                Image(
                    systemName:
                        "speedometer"
                )

                Text(
                    String(
                        format:
                            "%.2gx",
                        selectedSpeed
                    )
                )
            }
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Language

private extension FlixoraVideoPlayerView {

    var languageMenu: some View {

        Menu {

            ForEach(
                [
                    "English",
                    "Tamil",
                    "Hindi",
                    "Telugu",
                    "Malayalam",
                    "Kannada"
                ],
                id: \.self
            ) { language in

                Button {

                    selectedLanguage =
                        language

                } label: {

                    HStack {

                        Text(language)

                        if selectedLanguage ==
                            language {

                            Image(
                                systemName:
                                    "checkmark"
                            )
                        }
                    }
                }
            }

        } label: {

            Image(
                systemName:
                    "globe"
            )
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Subtitles

private extension FlixoraVideoPlayerView {

    var subtitleMenu: some View {

        Menu {

            ForEach(
                [
                    "Off",
                    "English",
                    "Tamil",
                    "Hindi",
                    "Telugu"
                ],
                id: \.self
            ) { subtitle in

                Button {

                    selectedSubtitle =
                        subtitle

                } label: {

                    HStack {

                        Text(subtitle)

                        if selectedSubtitle ==
                            subtitle {

                            Image(
                                systemName:
                                    "checkmark"
                            )
                        }
                    }
                }
            }

        } label: {

            Image(
                systemName:
                    "captions.bubble"
            )
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Settings

private extension FlixoraVideoPlayerView {

    var settingsMenu: some View {

        Menu {

            Section("Playback Speed") {

                ForEach(
                    [0.5, 1.0, 1.25, 1.5, 2.0],
                    id: \.self
                ) { speed in

                    Button {

                        selectedSpeed =
                            speed

                        if isPlaying {

                            player.rate =
                                Float(speed)
                        }

                    } label: {

                        Text(
                            String(
                                format:
                                    "%.2gx",
                                speed
                            )
                        )
                    }
                }
            }

            Section("Audio") {

                Button {

                    selectedLanguage =
                        "English"

                } label: {

                    Text("English")
                }

                Button {

                    selectedLanguage =
                        "Tamil"

                } label: {

                    Text("Tamil")
                }

                Button {

                    selectedLanguage =
                        "Hindi"

                } label: {

                    Text("Hindi")
                }
            }

            Section("Subtitles") {

                Button {

                    selectedSubtitle =
                        "Off"

                } label: {

                    Text("Off")
                }

                Button {

                    selectedSubtitle =
                        "English"

                } label: {

                    Text("English")
                }

                Button {

                    selectedSubtitle =
                        "Tamil"

                } label: {

                    Text("Tamil")
                }
            }

        } label: {

            Image(
                systemName:
                    "gearshape.fill"
            )
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.white)
        }
    }
}

// MARK: - Fullscreen

private extension FlixoraVideoPlayerView {

    var fullscreenButton: some View {

        Button {

            toggleFullscreen()

        } label: {

            Image(
                systemName:
                    isFullscreen
                    ? "arrow.down.right.and.arrow.up.left"
                    : "arrow.up.left.and.arrow.down.right"
            )
            .font(
                .system(
                    size: 18,
                    weight: .semibold
                )
            )
            .foregroundStyle(.white)
        }
    }

    func toggleFullscreen() {

        withAnimation(
            .easeInOut(duration: 0.25)
        ) {

            isFullscreen.toggle()
        }

        if isFullscreen {

            OrientationManager
                .lockToLandscape()

        } else {

            OrientationManager
                .lockToPortrait()
        }
    }
}

// MARK: - Play / Pause

private extension FlixoraVideoPlayerView {

    func togglePlayPause() {

        if isPlaying {
            player.pause()
        } else {
            player.playImmediately(
                atRate: Float(selectedSpeed)
            )
        }

        isPlaying.toggle()
    }
}

// MARK: - Seek

private extension FlixoraVideoPlayerView {

    func seek(by seconds: Double) {

        let newTime = max(
            0,
            min(
                currentTime + seconds,
                duration
            )
        )

        seek(to: newTime)
    }

    func seek(to seconds: Double) {

        player.seek(
            to: CMTime(
                seconds: seconds,
                preferredTimescale: 600
            )
        )

        currentTime = seconds
    }
}

// MARK: - Close

private extension FlixoraVideoPlayerView {

    func closePlayer() {

            if isFullscreen {
                OrientationManager.lockToPortrait()
            }

            player.pause()
            dismiss()
        }
}

// MARK: - Time

private extension FlixoraVideoPlayerView {

    func formatTime(
        _ seconds: Double
    ) -> String {

        guard seconds.isFinite else {
            return "00:00"
        }

        let total =
            Int(seconds)

        let hours =
            total / 3600

        let minutes =
            (total % 3600) / 60

        let remainingSeconds =
            total % 60

        if hours > 0 {

            return String(
                format:
                    "%02d:%02d:%02d",
                hours,
                minutes,
                remainingSeconds
            )

        } else {

            return String(
                format:
                    "%02d:%02d",
                minutes,
                remainingSeconds
            )
        }
    }
}

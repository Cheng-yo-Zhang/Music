//
//  ContentView.swift
//  Music
//
//  Created by Louis Chang on 2024/12/18.
//

import AVFoundation
import SwiftUI

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let url: URL
    let coverImage: String
}

class AudioPlayerViewModel: ObservableObject {
    private var player: AVPlayer?
    var aduioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentSongIndex = 0
    @Published var isShuffleEnabled = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    private var timeObserver: Any?
    @Published var isRepeatEnabled = false
    @Published var isRepeatOneEnabled = false
    
    let songs: [Song] = [
        Song(title: "可愛女人",
             artist: "Jay",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/b7/1a/3a/b71a3a09-1246-1548-bf8d-a8e8071baad4/mzaf_13108310522472210845.plus.aac.ep.m4a")!,
             coverImage: "Jay"
            ),
        
        Song(title: "開不了口",
             artist: "范特西",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/98/9c/24/989c24f5-7638-c064-4ce6-85fd4f67b2c9/mzaf_6794586204730046430.plus.aac.ep.m4a")!,
             coverImage: "Fantasy"
            ),
        
        Song(title: "最後的戰役",
             artist: "八度空間",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/cc/34/d1/cc34d17f-3c79-e34b-9d40-37483dc6ed1a/mzaf_10610855431509152296.plus.aac.ep.m4a")!,
             coverImage: "TheEightDimensions"
            ),
        
        Song(title: "以父之名",
             artist: "葉惠美",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/86/44/ef/8644ef0a-2efd-bc41-9be5-b71bcbe6c646/mzaf_7151388810020997295.plus.aac.ep.m4a")!,
             coverImage: "YehHuiMei"
            ),
        
        Song(title: "七里香",
             artist: "七里香",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/20/86/b8/2086b87c-251f-4654-58e4-3e781a4d1f27/mzaf_6506679183249265834.plus.aac.ep.m4a")!,
             coverImage: "CommonJasminOrange"
            ),
        
        Song(title: "夜曲",
             artist: "11月蕭邦",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/0e/f2/00/0ef200dd-c5aa-f406-2f21-f4724ae74350/mzaf_2880175993859070066.plus.aac.ep.m4a")!,
             coverImage: "NovembersChopin"
            ),
        
        Song(title: "千里之外",
             artist: "依然范特西",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/6e/ac/16/6eac1640-60d8-274b-65d9-d4bf0d96a60d/mzaf_13318199740955840662.plus.aac.ep.m4a")!,
             coverImage: "StillFantasy"
            ),
        
        Song(title: "牛仔很忙",
             artist: "我很忙",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/ab/95/04/ab95047f-6e2e-24e1-b2ee-e966c0914672/mzaf_16197471527595281427.plus.aac.ep.m4a")!,
             coverImage: "OnTheRun"
            ),
        
        Song(title: "稻香",
             artist: "魔杰座",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/2e/99/24/2e99240d-aae9-1c6b-8ef8-03e5640a1815/mzaf_15556082871588496659.plus.aac.ep.m4a")!,
             coverImage: "CapricornDeluxePackage"
            ),
        
        Song(title: "超人不會飛",
             artist: "跨時代",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/3c/f8/df/3cf8df08-fc32-27c9-0d69-11345cb36e39/mzaf_3231317064683575427.plus.aac.ep.m4a")!,
             coverImage: "TheEra"
            ),
        
        Song(title: "驚嘆號",
             artist: "驚嘆號",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/ee/4f/8c/ee4f8c66-7e06-0700-6d07-72b8fe9e2ddb/mzaf_584163674931899168.plus.aac.ep.m4a")!,
             coverImage: "ExclamationPoint"
            ),
        
        Song(title: "紅塵客棧",
             artist: "12新作",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/2a/53/df/2a53df4d-aac5-b944-6eaa-ac8a0826f530/mzaf_6413955721671681082.plus.aac.ep.m4a")!,
             coverImage: "Opus12"
            ),
        
        Song(title: "鞋子特大號",
             artist: "哎呦，不錯哦",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/e8/cc/13/e8cc136b-8f45-5df0-0d45-9f87c3831619/mzaf_3613719886468059201.plus.aac.ep.m4a")!,
             coverImage: "ExtraLargeShoes"
            ),
        
        Song(title: "床邊故事",
             artist: "周杰倫的床邊故事",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/fa/67/f5/fa67f50f-ca2c-50ae-791d-e628982947ae/mzaf_3918587164873368348.plus.aac.ep.m4a")!,
             coverImage: "BedtimeStories"
            ),
        
        Song(title: "最偉大的作品",
             artist: "最偉大的作品",
             url: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview126/v4/80/c8/19/80c8193f-bce4-0e52-6e47-886082ae3fd4/mzaf_4812814279657097236.plus.aac.ep.m4a")!,
             coverImage: "GreatestWorksOfArt"
            ),
    ]
    
    var currentSong: Song {
        songs[currentSongIndex]
    }
    
    init() {
        setupPlayer(url: songs[currentSongIndex].url)
    }
    
    func setupPlayer(url: URL) {
        setupPlay(url: url)
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func nextSong() {
        if isShuffleEnabled {
            playRandomSong()
            return
        }
        currentSongIndex = (currentSongIndex + 1) % songs.count
        setupPlay(url: songs[currentSongIndex].url)
        if isPlaying {
            player?.play()
        }
    }
    
    func previousSong() {
        if currentSongIndex > 0 {
            currentSongIndex -= 1
        } else {
            currentSongIndex = songs.count - 1
        }
        setupPlay(url: songs[currentSongIndex].url)
        if isPlaying {
            player?.play()
        }
    }
    
    func playRandomSong() {
        let randomIndex = Int.random(in: 0..<songs.count)
        currentSongIndex = randomIndex
        setupPlay(url: songs[currentSongIndex].url)
        if isPlaying {
            player?.play()
        }
    }
    
    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
    
    func setupPlay(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // 添加播放完成的通知觀察者
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // 使用 async/await 和新的 asset 載入方法
        Task {
            do {
                let asset = AVURLAsset(url: url)
                let duration = try await asset.load(.duration)
                
                await MainActor.run {
                    self.duration = CMTimeGetSeconds(duration)
                }
            } catch {
                print("載入音訊長度失敗: \(error)")
            }
        }
        
        // 使用 CMTime.makeWithSeconds 替代舊方法
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    func seekToTime(_ time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    // 處理播放完成的方法
    @objc func playerDidFinishPlaying() {
        if isRepeatOneEnabled {
            setupPlay(url: currentSong.url)
            player?.play()
        } else if currentSongIndex == songs.count - 1 && !isRepeatEnabled {
            isPlaying = false
        } else {
            nextSong()
        }
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        NotificationCenter.default.removeObserver(self)
    }
}


struct ContentView: View {
    @StateObject private var viewModel = AudioPlayerViewModel()
    @State private var volume: Float = 0.5
    
    var body: some View {
        ZStack {
            // 背景專輯封面
            TabView(selection: Binding(
                get: { viewModel.currentSongIndex },
                set: { index in
                    viewModel.currentSongIndex = index
                    viewModel.setupPlay(url: viewModel.songs[index].url)
                }
            )) {
                ForEach(Array(viewModel.songs.enumerated()), id: \.element.id) { index, song in
                    Image(song.coverImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .blur(radius: 50)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            // 半透明黑色遮罩
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // 專輯封面 TabView
                TabView(selection: Binding(
                    get: { viewModel.currentSongIndex },
                    set: { index in
                        viewModel.currentSongIndex = index
                        viewModel.setupPlay(url: viewModel.songs[index].url)
                    }
                )) {
                    ForEach(Array(viewModel.songs.enumerated()), id: \.element.id) { index, song in
                        Image(song.coverImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width - 80)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                            .tag(index)
                    }
                }
                .frame(height: UIScreen.main.bounds.width - 80)
                .tabViewStyle(.page)
                
                Spacer()
                
                // 歌曲信息
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.currentSong.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(viewModel.currentSong.artist)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // 進度條
                VStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { viewModel.currentTime },
                            set: { viewModel.seekToTime($0) }
                        ),
                        in: 0...(viewModel.duration > 0 ? viewModel.duration : 210)
                    )
                    .tint(.white)
                    .controlSize(.mini)
                    
                    HStack {
                        Text(formatTime(viewModel.currentTime))
                        Spacer()
                        Text(formatTime(viewModel.duration))
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // 播放控制
                HStack(spacing: 40) {
                    Spacer()
                    
                    Button(action: viewModel.previousSong) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 30))
                    }
                    
                    Button(action: viewModel.playPause) {
                        Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 65))
                    }
                    
                    Button(action: viewModel.nextSong) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                
                // 音量控制
                HStack {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.gray)
                    Slider(value: Binding(
                        get: { Double(volume) },
                        set: {
                            volume = Float($0)
                            viewModel.setVolume(volume)
                        }
                    ), in: 0...1)
                    .tint(.gray)
                    .controlSize(.mini)
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // 底部控制列
                HStack(spacing: 35) {
                    Spacer()
                    
                    Button(action: {
                        viewModel.isShuffleEnabled.toggle()
                    }) {
                        Image(systemName: viewModel.isShuffleEnabled ? "shuffle.circle.fill" : "shuffle")
                            .foregroundColor(viewModel.isShuffleEnabled ? .white : .gray)
                    }
                    
                    Button(action: {
                        viewModel.isRepeatEnabled.toggle()
                        if viewModel.isRepeatEnabled {
                            viewModel.isRepeatOneEnabled = false
                        }
                    }) {
                        Image(systemName: viewModel.isRepeatEnabled ? "repeat.circle.fill" : "repeat")
                            .foregroundColor(viewModel.isRepeatEnabled ? .white : .gray)
                    }
                    
                    Button(action: {
                        viewModel.isRepeatOneEnabled.toggle()
                        if viewModel.isRepeatOneEnabled {
                            viewModel.isRepeatEnabled = false
                        }
                    }) {
                        Image(systemName: viewModel.isRepeatOneEnabled ? "repeat.1.circle.fill" : "repeat.1")
                            .foregroundColor(viewModel.isRepeatOneEnabled ? .white : .gray)
                    }
                    
                    Spacer()
                }
                .font(.system(size: 20))
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}

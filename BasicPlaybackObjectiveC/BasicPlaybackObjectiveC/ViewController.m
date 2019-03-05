//
// Bitmovin Player iOS SDK
// Copyright (C) 2018, Bitmovin GmbH, All Rights Reserved
//
// This source code and its use and distribution, is subject to the terms
// and conditions of the applicable license agreement.
//

#import "ViewController.h"
#import <BitmovinPlayer/BitmovinPlayer.h>

@interface ViewController () <BMPPlayerListener>

@property (nonatomic, strong) BMPBitmovinPlayer *player;

@end

@implementation ViewController

- (void)dealloc {
    [self.player destroy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    NSURL *streamUrl = [NSURL URLWithString: @"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"];
    NSURL *posterUrl = [NSURL URLWithString:@"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/poster.jpg"];
    
    if (streamUrl == nil || posterUrl == nil){
        return;
    }
    
    // Create player configuration
    BMPPlayerConfiguration *config = [[BMPPlayerConfiguration alloc] init];
    
    BMPSourceItem *sourceItem = [[BMPSourceItem alloc] initWithUrl:streamUrl];
    
    // Set a poster image
    [sourceItem setPosterSource:posterUrl];
    
    
    // subtitles
    NSString *subtitles = @"https://api.hotpot.tv/captions/9009/track.vtt?token=chili";
    NSURL *subtitlesURL = [NSURL URLWithString:subtitles];
    
    BMPSubtitleTrack *subtitleTrack = [[BMPSubtitleTrack alloc]initWithUrl:subtitlesURL label:@"en" identifier:@"lol works" isDefaultTrack:YES language:@"en"];
    [sourceItem addSubtitleTrack:subtitleTrack];
    
    // Set source item for configuration
    [config setSourceItem:sourceItem];
    
    
    // ads
    NSURL *adSourceTag = [NSURL URLWithString:@"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/32573358/2nd_test_ad_unit&ciu_szs=300x100&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=123123555"];
    
    BMPAdSource *adSource = [[BMPAdSource alloc]initWithTag:adSourceTag ofType:BMPAdSourceTypeIMA];
    BMPAdItem *adItem = [[BMPAdItem alloc] initWithAdSources:@[adSource] atPosition:@"pre"];
    BMPAdvertisingConfiguration *adConfig = [[BMPAdvertisingConfiguration alloc] initWithSchedule: @[adItem]];
    [config setAdvertisingConfiguration:adConfig];
    
    // Create player based on player configuration
    BMPBitmovinPlayer *player = [[BMPBitmovinPlayer alloc] initWithConfiguration:config];
    
    // Create player view and pass the player instance to it
    BMPBitmovinPlayerView *playerView = [[BMPBitmovinPlayerView alloc]initWithPlayer:player frame:CGRectZero];
    
    // Listen to player events
    [player addPlayerListener:self];
    
    playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    playerView.frame = self.view.bounds;
    
    [self.view addSubview:playerView];
    [self.view bringSubviewToFront:playerView];
    
    self.player = player;
}

// MARK: BMPPlayerListener

- (void)onPlay:(BMPPlayEvent *)event {
    NSLog(@"onPlay: %f", event.time);
}

- (void)onPaused:(BMPPausedEvent *)event {
    NSLog(@"onPaused: %f", event.time);
}

- (void)onTimeChanged:(BMPTimeChangedEvent *)event {
    NSLog(@"onTimeChanged: %f", event.currentTime);
}

- (void)onDurationChanged:(BMPDurationChangedEvent *)event {
    NSLog(@"onDurationChanged: %f", event.duration);
}

- (void)onError:(BMPErrorEvent *)event {
    NSLog(@"onError: %@", event.message);
}

@end

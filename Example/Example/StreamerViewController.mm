//
//  StreamerViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 ArenaCloud.com. All rights reserved.
//

#import "StreamerViewController.h"
#import <ArenaCloud/broadcast/ArenaCloudBroadcast.h>

@interface StreamerViewController ()

@end

@implementation StreamerViewController

@synthesize playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    playButton.hidden = NO;
    playButton.enabled = YES;
    
    //-- ArenaCloud.com setup
    
    // read our ArenaCloud.com configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"broadcast-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    
    // create a new ACBRClient to fetch our stream information
    ACBRClient *client = [[ACBRClient alloc] init];
    client.projectPublicKey = settings[@"PROJECT_PUBLIC_KEY"];
    [client getStream:settings[@"STREAM_ID"]
             byTicket:settings[@"STREAM_TICKET"]
        withCompletionHandler:^(NSError *error, ACBRStream *stream) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Couldn't get stream settings from ArenaCloud.com."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.stream = stream;
        }
    }];
#if 0
    [client getStreamRecordings:settings[@"STREAM_ID"]
             byTicket:settings[@"STREAM_TICKET"]
          withCompletionHandler:^(NSError *error, NSArray *recordings) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Couldn't get stream recordings from ArenaCloud.com."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.recordings = recordings;
        }
    }];
#endif
}

- (IBAction)playButtonPressed:(id)sender
{
    playButton.enabled = NO;
    playButton.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self startStreaming];
#if 0
    [self startRecordingStreaming];
#endif
}

- (void)finishStreaming
{
    [super finishStreaming];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    playButton.hidden = NO;
    playButton.enabled = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

@end

//
//  PlaySoundTools.h
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-26.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

@interface PlaySoundTools : NSObject
{
    SystemSoundID _soundID;
}

+(id)soundEffectWithContentsOfFile:(NSString *)aPath;
-(id)initWithContentsOfFile:(NSString *)path;
-(void)play;

@end

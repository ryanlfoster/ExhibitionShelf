//
//  PlaySoundTools.h
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-26.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
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

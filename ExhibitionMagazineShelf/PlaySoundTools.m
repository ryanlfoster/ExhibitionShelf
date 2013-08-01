//
//  PlaySoundTools.m
//  ExhibitionShelf
//
//  Created by Qin Xin on 13-7-26.
//  Copyright (c) 2013年 Today Cyber. All rights reserved.
//

#import "PlaySoundTools.h"

@implementation PlaySoundTools

/**
 *	init PlaySoundTools class method
 *
 *	@param	aPath	sound resource path
 *
 *	@return	playSoundTools
 */
+(id)soundEffectWithContentsOfFile:(NSString *)aPath
{
    if(aPath){
        return [[PlaySoundTools alloc] initWithContentsOfFile:aPath];
    }
    return nil;
}

/**
 *	init instance method
 *
 *	@param	path	sound resource path
 *
 *	@return	PlaySoundTools instance
 */
- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    
    if (self != nil) {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        if (aFileURL != nil)  {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(aFileURL), &aSoundID);
            
            if (error == kAudioServicesNoError) {
                _soundID = aSoundID;
            } else {
                self = nil;
            }
        } else {
            self = nil;
        }
    }
    return self;
}

/**
 *	play sound
 */
-(void)play
{
    AudioServicesPlaySystemSound(_soundID);
}

@end

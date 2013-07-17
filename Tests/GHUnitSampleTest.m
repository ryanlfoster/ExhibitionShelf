//
//  GHUnitSampleTest.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-5-14.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "GHUnitSampleTest.h"

@implementation GHUnitSampleTest

- (void)testStrings

{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

@end

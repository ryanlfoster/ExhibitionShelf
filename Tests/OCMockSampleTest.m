//
//  OCMockSampleTest.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-5-14.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "OCMockSampleTest.h"
#import <OCMock/OCMock.h>
@implementation OCMockSampleTest
// simple test to ensure building, linking,

// and running test case works in the project

- (void)testOCMockPass

{
    
    id mock = [OCMockObject mockForClass:NSString.class];
    
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    
    GHAssertEqualObjects(@"mocktest", returnValue,
                         
                         @"Should have returned the expected string.");
    
}

- (void)testOCMockFail

{
    
    id mock = [OCMockObject mockForClass:NSString.class];
    
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    
    GHAssertEqualObjects(@"thisIsTheWrongValueToCheck",
                         
                         returnValue, @"Should have returned the expected string.");
    
}
@end

//
//  Exhibition.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-28.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ExhibitionStore.h"
#import "Exhibition.h"

@interface ExhibitionStore(Private)

-(void)analyzeXml;
-(NSURL *)fileURLOfCachedExhibitionFile;

@end
@implementation ExhibitionStore
@synthesize exhibitionArray = _exhibitionArray;
@synthesize status = _status;
@synthesize list = _list;

/**
 *	init _exhibitionArray & _status
 *
 *	@return	self
 */
-(id)init {
    self = [super init];
    if(self) {
        _exhibitionArray = [[NSMutableArray alloc] init];
        _status = ExhibitionStatusNotInizialized;
    }
    return self;
}

#pragma mark -Get/Set override
/**
 *	set status
 *
 *	@param	newStatus	transmit new status
 */
-(void)setStatus:(ExhibitionStatusType)newStatus
{
    if(_status == newStatus)return;
    NSLog(@"newStatus == %d",newStatus);
    NSLog(@"_status == %d",_status);
    _status = newStatus;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_CHANGED_STATUS_NOTIFICATION object:self];
    });
}

#pragma mark -Private
/**
 *	anlyze xml in server
 */
-(void)analyzeXml
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        _list = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.vrdam.com/app/test.plist"]];
        if(!_list){
            _list = [[NSArray alloc] initWithContentsOfURL:[self fileURLOfCachedExhibitionFile]];
            NSLog(@"本地的xml数据");
        }
        else{
            //retrieve sever list
            [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *exhibitionDictionary = (NSDictionary *)obj;
                Exhibition *anExhibition = [[Exhibition alloc] init];
                anExhibition.exhibitionID = [exhibitionDictionary objectForKey:@"ID"];
                anExhibition.title = [exhibitionDictionary objectForKey:@"Title"];
                anExhibition.subTitle = [exhibitionDictionary objectForKey:@"Sub Title"];
                anExhibition.date = [exhibitionDictionary objectForKey:@"Date"];
                anExhibition.coverURL = [exhibitionDictionary objectForKey:@"Cover URL"];
                anExhibition.downloadURL = [exhibitionDictionary objectForKey:@"Download URL"];
                anExhibition.description = [exhibitionDictionary objectForKey:@"Description"];
                [_exhibitionArray addObject:anExhibition];
            }];
            if(_exhibitionArray){
                // save the location
                [_list writeToURL:[self fileURLOfCachedExhibitionFile] atomically:YES];
                self.status = ExhibitionStatusReady;
                NSLog(@"服务器的xml数据");
            }else{
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器没有数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alerView show];
                self.status = ExhibitionStatusError;
            }
        }
    });
}
/**
 *	analyze xml in sandbox documnetDirectory
 *
 *	@return	NSURL:plist path
 */
-(NSURL *)fileURLOfCachedExhibitionFile
{
    return [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:DocumentsDirectory,@"exhibition.plist",nil]];
}

#pragma mark -Public
/**
 *	analyzexml()
 */
-(void)startup
{
    [self analyzeXml];
}
/**
 *	whether exhibition is play
 *
 *	@return	BOOL
 */
-(BOOL)isExhibitionStoreReady
{
    return (_status == ExhibitionStatusReady);
}
/**
 *	the number of exhibiton in store
 *
 *	@return	NSInteger
 */
-(NSInteger)numberOfStoreExhibition
{
    return [_exhibitionArray count];
}
/**
 *	get exhibition with index in exhibitionStore
 *
 *	@param	index	index
 *
 *	@return	exhibition
 */
-(Exhibition *)exhibitionAtIndex:(NSInteger)index
{
    return [_exhibitionArray objectAtIndex:index];
}
/**
 *	get exhibition with exhibitionID in exhibitionArray
 *
 *	@param	exhibitionID	exhibiitonID
 *
 *	@return	exhibiiton
 */
-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID
{
    for(Exhibition *anExhibition in _exhibitionArray) {
        if([anExhibition.exhibitionID isEqualToString:exhibitionID]) {
            return anExhibition;
        }
    }
    return nil;
}
@end

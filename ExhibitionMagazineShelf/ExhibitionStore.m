//
//  Exhibition.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-28.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "ExhibitionStore.h"
#import "Exhibition.h"
@interface ExhibitionStore(Private)
//download exhibition
-(void)downloadStoreExhibition;
//exhibition plist save to cache Dir
-(NSURL *)fileURLOfCachedExhibitionFile;
@end
@implementation ExhibitionStore
@synthesize status = _status;
@synthesize downloadQueue = _downloadQueue;
@synthesize op = _op;

#pragma mark - Object lifecycle

-(id)init {
    self = [super init];
    if(self) {
        exhibitionArray=[[NSMutableArray alloc] init];
        userExhibition=[[NSMutableDictionary alloc] init];
        _status=ExhibitionStatusNotInizialized;
        
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount=1;
        
    }
    return self;
}

#pragma mark - Get/Set override
//set override
-(void)setStatus:(ExhibitionStatusType)newStatus
{
    if(_status == newStatus)return;
    _status = newStatus;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_CHANGED_STATUS_NOTIFICATION object:[NSNumber numberWithInt:newStatus]];
    });
}

#pragma mark - Public
//init
-(void)startup
{
    [self downloadStoreExhibition];
}

-(BOOL)isExhibitionReady
{
    return (_status == ExhibitionStatusReady);
}

-(NSInteger)numberOfStoreExhibition {
    NSLog(@"numberOfStoreExhibition = %d",[exhibitionArray count]);
    return [exhibitionArray count];
}

-(NSInteger)numberOfDownloadedExhibition
{
    NSLog(@"numberOfDownloadedExhibition = %d",[userExhibition count]);
    return[userExhibition count];
    
}

-(Exhibition *)exhibitionAtIndex:(NSInteger)index {
    return [exhibitionArray objectAtIndex:index];
}

-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID {
    for(Exhibition *anExhibition in exhibitionArray) {
        if([anExhibition.exhibitionID isEqualToString:exhibitionID]) {
            return anExhibition;
        }
    }
    return nil;
}

-(void)scheduleDownloadOfExhibition:(Exhibition *)exhibition{
    
    NSString *downloadURL = [exhibition downloadURL];
    if(!downloadURL)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:exhibition];
    [conn start];
}

-(void)clearQueue:(Exhibition *)exhibition
{
    exhibition.expectedLength = 0;
    NSString *downloadURL = [exhibition downloadURL];
    if(!downloadURL)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:exhibition];
    [conn cancel];

    
}

#pragma mark - Startup(private)
-(void)downloadStoreExhibition
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSArray *_list = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.vrdam.com/app/exhibition.plist"]];
        if(!_list){
            _list = [[NSArray alloc] initWithContentsOfURL:[self fileURLOfCachedExhibitionFile]];
        }
        if(_list){
            //retrieve sever list
            [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *exhibitionDictionary = (NSDictionary *)obj;
                Exhibition *anExhibition = [[Exhibition alloc] init];
                anExhibition.exhibitionID=[exhibitionDictionary objectForKey:@"ID"];
                anExhibition.title=[exhibitionDictionary objectForKey:@"Title"];
                anExhibition.coverURL=[exhibitionDictionary objectForKey:@"Cover URL"];
                anExhibition.downloadURL=[exhibitionDictionary objectForKey:@"Download URL"];
                [exhibitionArray addObject:anExhibition];
                // dispatch cover loading
                if(![UIImage imageWithContentsOfFile:[anExhibition exhibitionImagePath]]) {
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:anExhibition.coverURL]];
                        if(imgData) {
                            [imgData writeToFile:[anExhibition exhibitionImagePath] atomically:YES];
                        }
                    });
                }
            }];
            // save the location
            [_list writeToURL:[self fileURLOfCachedExhibitionFile] atomically:YES];
            self.status=ExhibitionStatusReady;
            [self loadInstalledExhibition];
        } else {
            exhibitionArray = nil;
            self.status=ExhibitionStatusError;
        }
    });
}

//retrieve exhibition
-(void)loadInstalledExhibition
{
    for(Exhibition *anExhibition in exhibitionArray){
        if([anExhibition isExhibitionAvailibleForRead]){
            [userExhibition setObject:anExhibition forKey:anExhibition.exhibitionID];
        }
    }
}


#pragma mark - Private
-(NSURL *)fileURLOfCachedExhibitionFile
{
    return [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:DocumentsDirectory,@"exhibition.plist",nil]];
}
@end

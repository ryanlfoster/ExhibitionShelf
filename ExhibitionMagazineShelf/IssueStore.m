//
//  Store.m
//  ExhibitionMagazineShelf
//
//  Created by Today Sybor on 13-3-21.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "IssueStore.h"
#import "Issue.h"
@interface IssueStore(Private)
-(void)downloadStoreIssues;
-(void)loadInstalledIssues;
-(NSURL *)fileURLOfCachedStoreFile;
@end

@implementation IssueStore

@synthesize status=_status;

#pragma mark - Object lifecycle

-(id)init {
    self = [super init];
    if(self) {
        IssueArray=[[NSMutableArray alloc] init];
        userIssue=[[NSMutableDictionary alloc] init];
        _status=StoreStatusNotInizialized;
        
    }
    return self;
}

#pragma mark - Get/Set override

//set override
-(void)setStatus:(StoreStatusType)newStatus {
    if(_status==newStatus) return;
    _status=newStatus;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:STORE_CHANGED_STATUS_NOTIFICATION object:[NSNumber numberWithInt:newStatus]];
    });
}

#pragma mark - Public

-(void)startup {
    
    [self downloadStoreIssues];
}

-(BOOL)isStoreReady {
    return(_status==StoreStatusReady);
}

#pragma mark - Startup (private)

-(void)downloadStoreIssues {
    self.status=StoreStatusDownloading;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        NSArray *_list = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.vrdam.com/app/issue.plist"]];
        if(!_list) {
            //retrieve local list
            _list = [[NSArray alloc] initWithContentsOfURL:[self fileURLOfCachedStoreFile]];
        }
        if(_list) {
            //retrieve server list            
            [_list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *issueDictionary = (NSDictionary *)obj;
                Issue *anIssue = [[Issue alloc] init];
                anIssue.issueID=[issueDictionary objectForKey:@"ID"];
                anIssue.title=[issueDictionary objectForKey:@"Title"];
                anIssue.coverURL=[issueDictionary objectForKey:@"Cover URL"];
                anIssue.downloadURL=[issueDictionary objectForKey:@"Download URL"];
                [IssueArray addObject:anIssue];
                // if no image , download image and save the image 
                if(![anIssue coverImage]) {
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:anIssue.coverURL]];
                        if(imgData) {
                            [imgData writeToURL:[anIssue.contentURL URLByAppendingPathComponent:@"cover.png"] atomically:YES];
                        }
                    });
                }
            }];
            // save local
            [_list writeToURL:[self fileURLOfCachedStoreFile] atomically:YES];        
            self.status=StoreStatusReady;
            [self loadInstalledIssues];
        } else {
            IssueArray = nil;
            self.status=StoreStatusError;
        }
    });
}

-(void)loadInstalledIssues {
    for(Issue *anIssue in IssueArray) {
        if([anIssue isIssueAvailibleForRead]) {
            [userIssue setObject:anIssue forKey:anIssue.issueID];
        }
    }
}

-(void)scheduleDownloadOfIssue:(Issue *)issueToDownload {
    NSString *downloadURL = [issueToDownload downloadURL];
    if(!downloadURL)return;
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:downloadRequest delegate:issueToDownload];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(startDownload:) object:conn];
    if(!downloadQueue) {
        downloadQueue = [[NSOperationQueue alloc] init];
        downloadQueue.maxConcurrentOperationCount=1;
    }
    [downloadQueue addOperation:op];
    [downloadQueue setSuspended:NO];

}

-(void)startDownload:(id)obj {
    NSURLConnection *conn = (NSURLConnection *)obj;
    [conn start];
}

#pragma mark - Issue retrieval

-(NSInteger)numberOfStoreIssues {
    return [IssueArray count];
}

-(Issue *)issueAtIndex:(NSInteger)index {
    return [IssueArray objectAtIndex:index];
}

-(Issue *)issueWithID:(NSString *)issueID {
    for(Issue *anIssue in IssueArray) {
        if([anIssue.issueID isEqualToString:issueID]) {
            return anIssue;
        }
    }
    return nil;
}

#pragma mark - Private
//cash file
-(NSURL *)fileURLOfCachedStoreFile {
    return [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:DocumentsDirectory, @"issue.plist",nil]];
}

@end
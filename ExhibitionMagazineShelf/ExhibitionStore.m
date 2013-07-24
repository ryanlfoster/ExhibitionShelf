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
//analyze xml
-(void)analyzeXml;
//exhibition plist save to cache Dir
-(NSURL *)fileURLOfCachedExhibitionFile;
@end
@implementation ExhibitionStore
@synthesize exhibitionArray = _exhibitionArray;
@synthesize status = _status;
@synthesize list = _list;

#pragma mark -init
/**********************************************************
 函数名称：-(id)init
 函数描述：初始化变量
 输入参数：n/a
 输出参数：n/a
 返回值：self
 **********************************************************/
-(id)init {
    self = [super init];
    if(self) {
        _exhibitionArray = [[NSMutableArray alloc] init];
        _status = ExhibitionStatusNotInizialized;
    }
    return self;
}

#pragma mark -Get/Set override
/**********************************************************
 函数名称：-(void)setStatus:(ExhibitionStatusType)newStatus
 函数描述：exhibition set status 
 输入参数：(ExhibitionStatusType)newStatus:新状态
 输出参数：n/a
 返回值：void
 **********************************************************/
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
/**********************************************************
 函数名称：-(void)analyzeXml
 函数描述：从服务器文件中读取并解析xml文件
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
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
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器中的xml文件没有数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alerView show];
                self.status = ExhibitionStatusError;
            }
        }
    });
}
/**********************************************************
 函数名称：-(NSURL *)fileURLOfCachedExhibitionFile
 函数描述：得到缓存文件URL
 输入参数：n/a
 输出参数：n/a
 返回值：(NSURL *)
 **********************************************************/
-(NSURL *)fileURLOfCachedExhibitionFile
{
    return [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:DocumentsDirectory,@"exhibition.plist",nil]];
}

#pragma mark -Public
/**********************************************************
 函数名称：-(void)startup
 函数描述：初始化exhibition store
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)startup
{
    [self analyzeXml];
}
/**********************************************************
 函数名称：-(BOOL)isExhibitionReady
 函数描述：exhibition 是否已下载
 输入参数：n/a
 输出参数：n/a
 返回值：BOOL
 **********************************************************/
-(BOOL)isExhibitionStoreReady
{
    return (_status == ExhibitionStatusReady);
}
/**********************************************************
 函数名称：-(NSInteger)numberOfStoreExhibition 
 函数描述：exhibition total count
 输入参数：n/a
 输出参数：n/a
 返回值：NSInteger
 **********************************************************/
-(NSInteger)numberOfStoreExhibition
{
    return [_exhibitionArray count];
}
/**********************************************************
 函数名称：-(Exhibition *)exhibitionAtIndex:(NSInteger)index
 函数描述：通过array的位置取出exhibition对象
 输入参数：(NSInteger)index
 输出参数：n/a
 返回值：Exhibition
 **********************************************************/
-(Exhibition *)exhibitionAtIndex:(NSInteger)index
{
    return [_exhibitionArray objectAtIndex:index];
}
/**********************************************************
 函数名称：-(Exhibition *)exhibitionWithID:(NSString *)exhibitionID
 函数描述：通过exhibitionID得到exhibition对象
 输入参数：(NSString *)exhibitionID
 输出参数：n/a
 返回值：Exhibition
 **********************************************************/
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

//
//  Exhibition.m
//  ExhibitionMagazineShelf
//
//  Created by 秦鑫 on 13-3-29.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "Exhibition.h"
#import "ZipArchive.h"

@interface Exhibition (Private)
-(void)alertDownloadErrorView;
@end

static BOOL haveExhibitionDownloading;//全局变量，当执行删除操作时看是否有文件在下载当中。
@implementation Exhibition
@synthesize exhibitionID = _exhibitionID;
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize date = _date;
@synthesize coverURL = _coverURL;
@synthesize downloadURL = _downloadURL;
@synthesize description = _description;
@synthesize downloadData = _downloadData;
@synthesize expectedLength = _expectedLength;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloading = _downloading;
@synthesize expectedLengthNumber = _expectedLengthNumber;
@synthesize downloadDataLengthNumber = _downloadDataLengthNumber;

#pragma mark -Class Methods
/**********************************************************
 函数名称：+(BOOL)ifHaveExhibitionDownloading
 函数描述：检查是否存在下载中的文件
 输入参数：n/a
 输出参数：n/a
 返回值：(BOOL) 返回YES,则有文件在下载
 **********************************************************/
+(BOOL)ifHaveExhibitionDownloading
{
    return haveExhibitionDownloading;
}

#pragma mark -Public methods
/**********************************************************
 函数名称：-(BOOL)isDownloading
 函数描述：展览zip是否正在下载
 输入参数：n/a
 输出参数：n/a
 返回值：(BOOL)
 **********************************************************/
-(BOOL)isDownloading
{
    return _downloading;
}
/**********************************************************
 函数名称：-(NSURL *)contentURL
 函数描述：对象在沙盒文件中的路径URL
 输入参数：n/a
 输出参数：n/a
 返回值：(NSURL *)
 **********************************************************/
-(NSURL *)contentURL
{
    NSURL *theURL = [NSURL fileURLWithPath:[CacheDirectory stringByAppendingPathComponent:_exhibitionID]];
    // create the URL
    if(![[NSFileManager defaultManager] fileExistsAtPath:[theURL path]]) {
        NSError *error=nil;
        if([[NSFileManager defaultManager] createDirectoryAtPath:[theURL path] withIntermediateDirectories:NO attributes:nil error:&error]==NO) {
            NSLog(@"There was an error in creating the directory: %@",error);
        }
        
    }
    return theURL;
}
/**********************************************************
 函数名称：-(NSString *)exhibitionImagePath
 函数描述：对象在沙盒文件中的封面路径string
 输入参数：n/a
 输出参数：n/a
 返回值：(NSString *)
 **********************************************************/
-(NSString *)exhibitionImagePath
{
    return[[[self contentURL] URLByAppendingPathComponent:@"cover.png"] path];
}
/**********************************************************
 函数名称：-(NSString *)exhibitionFilePath
 函数描述：展览文件在沙盒文件中的目录string
 输入参数：n/a
 输出参数：n/a
 返回值：(NSString *)
 **********************************************************/
-(NSString *)exhibitionFilePath
{
    return [[[self contentURL] URLByAppendingPathComponent:@"exhibition"]path];
}
/**********************************************************
 函数名称：-(BOOL)isExhibitionAvailibleForRead
 函数描述：展览zip是否已下载
 输入参数：n/a
 输出参数：n/a
 返回值：(NSString *)
 **********************************************************/
-(BOOL)isExhibitionAvailibleForPlay
{
    //delete file
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *contentPathDelete = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    if(contentPathDelete){
        [fileManger removeItemAtPath:contentPathDelete error:NULL];
    }
    
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition"] path];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:contentPath];
    NSLog(@"Checking for path: %@ ==> %d",contentPath,fileExists);
    return(fileExists);
}
/**********************************************************
 函数名称：-(void)setDownloadProgress:(float)downloadProgress
 函数描述：
 输入参数：n/a
 输出参数：n/a
 返回值：
 **********************************************************/
-(void)setDownloadProgress:(float)downloadProgress
{
    _downloadProgress = downloadProgress;
    NSLog(@"Download progress: %.0f%%",_downloadProgress * 100);
}

#pragma mark -NSURLConnectionDataDelegate
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called when enough data has been read to construct an NSURLResponse object. In the event of a protocol
 which may return multiple responses (such as HTTP multipart/x-mixed-replace) the delegate should be prepared to inspect the new response and make
 itself ready for data callbacks as appropriate.
 输入参数：(NSURLConnection *)connection :发送请求的对象  didReceiveResponse:(NSURLResponse *)response:接受到的回应
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response !!!!!!!!!!!");
    if(!_downloadData){
        _downloadData = [[NSMutableData alloc] init];
    }
    [_downloadData setLength:0];
    
    _expectedLength = [response expectedContentLength];
    NSLog(@"_expectedLength = %d",_expectedLength);
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called with a single immutable NSData object to the delegate,representing the next portion of the data loaded
 from the connection.  This is the only guaranteed for the delegate to receive the data from the resource load.
 输入参数：(NSURLConnection *)connection :发送请求的对象  didReceiveData:(NSData *)data:接受到的数据
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    haveExhibitionDownloading = YES;
    [_downloadData appendData:data];
    _expectedLengthNumber = [[NSNumber alloc]initWithInteger:_expectedLength];
    _downloadDataLengthNumber = [[NSNumber alloc] initWithInteger:[_downloadData length]];
    
    float expectedLengthFloat = [_expectedLengthNumber floatValue];
    float downloadDataLengthFloat = [_downloadDataLengthNumber floatValue];
    
    [self setDownloadProgress:downloadDataLengthFloat / expectedLengthFloat];
    
    NSLog(@"下载中＝＝%d",haveExhibitionDownloading);
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：is called when all connection processing has completed successfully,before the delegate is released by the connection.
 输入参数：(NSURLConnection *)connection :发送请求的对象
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    haveExhibitionDownloading = NO;
    NSURL *finalURL = [[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"];
    [_downloadData writeToURL:finalURL atomically:YES];
    
    NSString *zipPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"]path];
    
/**************************************Zip operate*******************************************/    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:zipPath]){
        BOOL ret = [zip UnzipFileTo:[self exhibitionFilePath] overWrite:YES];
        if(ret){
            NSLog(@"unzip success !!!");
            //send end of download notification
            //delete file
            NSFileManager *fileManger = [NSFileManager defaultManager];
            NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
            [fileManger removeItemAtPath:contentPath error:NULL];
            [self sendEndOfDownloadNotification];
        }
        else{
            //delete incomplement UnzipFile
            [self alertDownloadErrorView];
        }
        
        [zip UnzipCloseFile];
    }
/********************************************************************************************/ 
    
    NSLog(@"下载后＝＝%d",haveExhibitionDownloading);
}
/**********************************************************
 函数名称：-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 函数描述：will be called at most once, if an error occurs during a resource load.  No other callbacks will be made after.
 输入参数：(NSURLConnection *)connection :发送请求的对象 didFailWithError:(NSError *)error
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"There was an error downloading this exhibition %@ with connection %@ . Error is: %@",self,connection,error);
    haveExhibitionDownloading = NO;
    [self setDownloadProgress:0.0];
    // post notification
    [self sendFailedDownloadNotification];
    NSLog(@"下载失败＝＝%d",haveExhibitionDownloading);
    return;
}
/**********************************************************
 函数名称：-(void)alertView
 函数描述：下载出错弹窗
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)alertDownloadErrorView
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"呀吼！下载出错了请在再试一次!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alerView show];
    
    [self sendFailedDownloadNotification];
    
    //delete file
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString *contentPath = [[[self contentURL] URLByAppendingPathComponent:@"exhibition.zip"] path];
    [fileManger removeItemAtPath:contentPath error:NULL];
    
}

#pragma mark -NSNotificationCenter
/**********************************************************
 函数名称：-(void)cancelDownloadExhibiiton
 函数描述：send conceal downloadCoverImageView notification
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)sendConcealDownloadCoverImageViewNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CONCEAL_DOWNLOADCOVERIMAGEVIEW_NOTIFICATION object:self];
}
/**********************************************************
 函数名称：-(void)sendEndOfDownloadNotification
 函数描述：下载完成后放松通知
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)sendEndOfDownloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_END_OF_DOWNLOAD_NOTIFICATION object:self];
}
/**********************************************************
 函数名称：-(void)sendFailedDownloadNotification
 函数描述：下载失败发送的通知
 输入参数：n/a
 输出参数：n/a
 返回值：void
 **********************************************************/
-(void)sendFailedDownloadNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXHIBITION_FAILED_DOWNLOAD_NOTIFICATION object:self];
}
@end

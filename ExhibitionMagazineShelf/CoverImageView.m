//
//  CoverImageView.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-12.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "CoverImageView.h"
#import "Exhibition.h"

@interface CoverImageView()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) Exhibition *exhibition;

@end

@implementation CoverImageView
@synthesize imgURL = _imgURL;
@synthesize exhibitionID = _exhibitionID;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize spinner = _spinner;
@synthesize exhibition = _exhibition;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinner.frame = self.frame;
        _spinner.center = self.center;
        _spinner.hidesWhenStopped = TRUE;
    }
    return self;
}

-(void)setImgURL:(NSString *)imgURL
{
    if(!imgURL){
        [_connection cancel];
        _imgURL = nil;
        self.image = nil;
        return;
    }
    _imgURL = imgURL;
    [self downloadImage];
}

-(void)setExhibitionID:(NSString *)exhibitionID
{
    _exhibitionID = exhibitionID;
}

-(void)downloadImage
{
    [self.superview addSubview:_spinner];
    [_spinner startAnimating];
    
    _data = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:_imgURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_spinner stopAnimating];
    _connection = nil;
    if([connection.currentRequest.URL.absoluteString isEqualToString:_imgURL]){
        self.image = [UIImage imageWithData:_data];
        //        NSURL *sandBoxURL = [NSURL fileURLWithPath:[CacheDirectory stringByAppendingPathComponent:_bookID]];
        //        NSString *imgString = [[sandBoxURL URLByAppendingPathComponent:@"cover.png"]path];
        //        NSLog(@"imgString == %@",imgString);
        //        [_data writeToFile:imgString atomically:YES];
        [self setNeedsLayout];
    }
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	NSString *url = theConnection.currentRequest.URL.absoluteString;
	NSString *msg = [NSString stringWithFormat:@"Error:\n%@\n\nWith this url:\n%@", [error description], url];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Download Error" message:msg delegate:self cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
	[alert show];
}


@end

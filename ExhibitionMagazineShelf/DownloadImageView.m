//
//  DownloadImageView.m
//  ExhibitionMagazineShelf
//
//  Created by Today Cyber on 13-7-15.
//  Copyright (c) 2013年 TodaySybor. All rights reserved.
//

#import "DownloadImageView.h"

@implementation DownloadImageView
@synthesize description = _description;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _description = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 202, 42)];
        _description.font = [UIFont systemFontOfSize:10.0];
        _description.textColor=[UIColor blackColor];
        _description.lineBreakMode = UILineBreakModeTailTruncation;
        _description.numberOfLines = 4;
        _description.backgroundColor = [UIColor clearColor];
        [self addSubview:_description];
    }
    return self;
}

//-(UIImage *)addText:(UIImage *)img text:(NSString *)string
//{
//	int w = img.size.width;
//	int h = img.size.height;
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//	CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//	
//	char* text= (char *)[string cStringUsingEncoding:NSASCIIStringEncoding];
//	CGContextSelectFont(context, "FZLTHJW--GB1-0",12, kCGEncodingMacRoman);
//	CGContextSetTextDrawingMode(context, kCGTextFill);
//	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
//	CGContextShowTextAtPoint(context,0,0,text,192);
//	CGImageRef imgCombined = CGBitmapContextCreateImage(context);
//	
//	CGContextRelease(context);
//	CGColorSpaceRelease(colorSpace);
//	
//	UIImage *retImage = [UIImage imageWithCGImage:imgCombined];
//	CGImageRelease(imgCombined);
//	
//	return retImage;
//
//}



@end

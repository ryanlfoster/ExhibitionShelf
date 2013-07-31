//
//  AboutUsViewController.m
//  ExhibitionMagazineShelf
//
//  Created by 秦 鑫 on 5/26/13.
//  Copyright (c) 2013 TodaySybor. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) PlaySoundTools *sound;

-(void)openURL;

@end

@implementation AboutUsViewController
@synthesize backButton = _backButton;
@synthesize sound = _sound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //load background
//    UIImage *backgroundImage = [UIImage imageNamed:@"about_us.png"];
//    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
//    self.view.backgroundColor = backgroundColor;
    
    
    //logo link image view
    UIImageView *linkLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(460, 67, 100, 185)];
    [self.view addSubview:linkLogoImageView];
    linkLogoImageView.userInteractionEnabled = YES;
    [linkLogoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	open page net in safari
 */
-(void)openURL
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"applaunch" ofType: @"wav"];
    _sound = [[PlaySoundTools alloc] initWithContentsOfFile:soundFilePath];
    [_sound play];
    NSURL *url = [NSURL URLWithString:OPENSAFARI];
    [[UIApplication sharedApplication] openURL:url];
}

@end

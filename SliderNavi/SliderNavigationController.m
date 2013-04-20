//
//  SliderNavigationController.m
//  SliderNavi
//
//  Created by mouwenbin on 4/20/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "SliderNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface SliderNavigationController ()
@property (retain, nonatomic) UIImageView *topImageView;
@property (retain, nonatomic) UIView*backgroudView;
@property (retain, nonatomic) NSMutableArray*imageArray;
@property (retain, nonatomic) UIView*currentView;
@property (assign, nonatomic) float lastInstance;
@end

@implementation SliderNavigationController
@synthesize topImageView = _topImageView, backgroudView = _backgroudView, imageArray = _imageArray,currentView = _currentView,lastInstance = _lastInstance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.topImageView = [[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
        self.backgroudView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
        self.backgroudView.backgroundColor = [UIColor blackColor];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.topImageView];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backgroudView];
    }
    return self;
}

- (void)dealloc
{
    self.topImageView = nil;
    self.backgroudView = nil;
    self.imageArray = nil;
    self.currentView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite Push and Pop methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        [self screenShots];
        [self configGesstureInfo:viewController.view];
        self.backgroudView.alpha = 0;
        self.topImageView.frame = CGRectMake(0,0, self.topImageView.frame.size.width, self.topImageView.frame.size.height);
        self.view.frame = CGRectMake(CGRectGetWidth(self.view.frame),self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            self.backgroudView.alpha = 1;
            self.topImageView.frame = CGRectMake(15,15, self.topImageView.frame.size.width, self.topImageView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    [super pushViewController:viewController animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.backgroudView.alpha = 0.7;
    self.topImageView.frame = CGRectMake(15,15, self.topImageView.frame.size.width, self.topImageView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(CGRectGetWidth(self.view.frame),self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self.backgroudView.alpha = 0;
        self.topImageView.frame = CGRectMake(0,0, self.topImageView.frame.size.width, self.topImageView.frame.size.height);
    } completion:^(BOOL finished) {
        [self back];
    }];
    return nil;
}

//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    
//}
//
//
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    
//}

#pragma mark - Custom Methods

- (void)screenShots
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (!self.imageArray)
    {
        self.imageArray = [NSMutableArray array];
    }
    [self.imageArray  addObject:image];
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    NSLog(@"Suceeded!");
}

- (void)configGesstureInfo:(UIView*)view
{
    if (self.imageArray && self.imageArray.count>0)
    {
        UIImage*image = [self.imageArray lastObject];
        self.topImageView.image = image;
    }
    self.currentView = view;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [self.currentView addGestureRecognizer:panGesture];
    [panGesture release];
}


#pragma mark -UIPanGestureRecognizer Selector
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.lastInstance = 0.0;
        return;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat xOffSet = [gestureRecognizer translationInView:self.currentView].x;
        CGFloat translateX = xOffSet -  self.lastInstance;
        self.lastInstance = xOffSet;
        [self slideView:translateX];
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self slideAnimationView];
        self.lastInstance = 0.0;
        
    }
}


- (void)slideView:(CGFloat)translate
{
    CGFloat x = self.view.frame.origin.x + translate;
    if (x<0) {
        x=0;
    }
    else if(x>270){
        x=270;
    }
    self.view.frame = CGRectMake(x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    float alpha = 1-x/250;
    self.backgroudView.alpha = alpha;
    self.topImageView.frame = CGRectMake(1000/x,1000/x, self.topImageView.frame.size.width, self.topImageView.frame.size.height);
}

- (void)slideAnimationView
{
    CGFloat x = self.view.frame.origin.x;
    if (x>=180) {
        CGFloat time = (270-x)/1000;
        [UIView animateWithDuration:time animations:^{
            self.view.frame = CGRectMake(270, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            [self back];
        }];
    }
    else{
        CGFloat time = x/2000;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:time];
        [UIView setAnimationDelegate:self];
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)back
{
    //self.navigationController.view.alpha = 0.0;
    [super popViewControllerAnimated:NO];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.topImageView.image];
    [self.view addSubview:imageView];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [imageView release];
    }];
    //self.navigationController.view.alpha = 1.0;
    [self  configBackInfo];
}

- (void)configBackInfo
{
    if (self.imageArray && self.imageArray.count>0)
    {
        [self.imageArray removeLastObject];
        if (self.imageArray && self.imageArray.count>0)
        {
            self.topImageView.image = [self.imageArray lastObject];
        }
    }
}

@end

//
//  ViewController.m
//  SliderNavi
//
//  Created by mouwenbin on 4/20/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewCtrlViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ButtonClicked:(id)sender {
    SecondViewCtrlViewController *secondView = [[SecondViewCtrlViewController alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    [secondView release];
}
@end

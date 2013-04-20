//
//  SecondViewCtrlViewController.m
//  SliderNavi
//
//  Created by mouwenbin on 4/20/13.
//  Copyright (c) 2013 mouwenbin. All rights reserved.
//

#import "SecondViewCtrlViewController.h"
#import "ViewController.h"

@interface SecondViewCtrlViewController ()

@end

@implementation SecondViewCtrlViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_buttonClicked release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setButtonClicked:nil];
    [super viewDidUnload];
}
- (IBAction)buttoncliced:(id)sender {
    ViewController *view = [[ViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [view release];
}
@end

//
//  CenterViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "CenterViewController.h"
#import "SecondViewCtrlViewController.h"
#import "Animal.h"

@interface CenterViewController ()

@property (nonatomic, retain) IBOutlet UILabel *imageTitle;
@property (nonatomic, retain) IBOutlet UILabel *imageCreator;

@property (nonatomic, retain) NSMutableArray *imagesArray;

@end

@implementation CenterViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)dealloc
{
    self.imageCreator = nil;
    self.imageTitle = nil;
    self.imagesArray = nil;
    self.leftButton = nil;
    self.rightButton = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.mainImageView addGestureRecognizer:gestureRecognizer];
    self.mainImageView.userInteractionEnabled = YES;
    [gestureRecognizer release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Button Actions

-(IBAction)btnMovePanelRight:(id)sender {
	UIButton *button = sender;
	switch (button.tag) {
		case 0: {
			[_delegate movePanelToOriginalPosition];
			break;
		}
			
		case 1: {
			[_delegate movePanelRight];
			break;
		}
			
		default:
			break;
	}
}

-(IBAction)btnMovePanelLeft:(id)sender {
	UIButton *button = sender;
	switch (button.tag) {
		case 0: {
			[_delegate movePanelToOriginalPosition];
			break;
		}
			
		case 1: {
			[_delegate movePanelLeft];
			break;
		}
            
		default:
			break;
	}
}

#pragma mark -
#pragma mark Delagate Method for capturing selected image

/*
 note: typically, you wouldn't create "duplicate" delagate methods, but we went with simplicity.
       doing it this way allowed us to show how to use the #define statement and the switch statement.
*/

- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator
{
    // only change the main display if an animal/image was selected
    if (image)
    {
        self.mainImageView.image = image;
        self.imageTitle.text = [NSString stringWithFormat:@"%@", imageTitle];
        self.imageCreator.text = [NSString stringWithFormat:@"%@", imageCreator];
    }
}

- (void)animalSelected:(Animal *)animal
{
    // only change the main display if an animal/image was selected
    if (animal)
    {
        [self showAnimalSelected:animal];
    }
}

// setup the imageview with our selected animal
- (void)showAnimalSelected:(Animal *)animalSelected
{
    self.mainImageView.image = animalSelected.image;
    self.imageTitle.text = [NSString stringWithFormat:@"%@", animalSelected.title];
    self.imageCreator.text = [NSString stringWithFormat:@"%@", animalSelected.creator];
}

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - handleRegesture
- (void)handleGesture:(UIGestureRecognizer *)sender
{
    SecondViewCtrlViewController *secondView = [[SecondViewCtrlViewController alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    [secondView release];
}
@end

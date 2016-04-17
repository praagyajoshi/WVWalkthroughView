//
//  ViewController.m
//  Walkthrough View Demo
//
//  Created by Praagya Joshi on 17/04/16.
//  Copyright © 2016 Praagya Joshi. All rights reserved.
//

#import "ViewController.h"
#import "WVWalkthroughView.h"
#import "HomeTableViewCell.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

@interface ViewController () <WVWalkthroughViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WVWalkthroughView *walkthrough;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController {
    BOOL introFirstRunShown;
    BOOL firstRowWalkthroughShown;
    BOOL secondRowWalkthroughShown;
    BOOL thirdRowWalkthroughShown;
    BOOL firstRowWalkthroughWithTouchShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createTableView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(displayRequiredWalkthroughs) withObject:nil afterDelay:0.5f];
}

- (void) createData {
    
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSDictionary *dataDict = @{@"image" : [UIImage imageNamed:[NSString stringWithFormat:@"image_%d", i+1]],
                                   @"text" : [self getTextForIndex:i]};
        [_dataArray addObject:dataDict];
    }
}

- (NSString *) getTextForIndex: (int) index {
    switch (index) {
        case 0:
            return @"First index text";
            break;
            
        case 1:
            return @"Second index text";
            break;
            
        default:
            return @"Default index text";
            break;
    }
}

#pragma mark - view creation methods

- (void) createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

#pragma mark - helper methods

- (void) displayRequiredWalkthroughs {
    
    if (!introFirstRunShown) {
        
        [self showIntroViewWithText:@"Welcome! Let's show you around."];
        introFirstRunShown = YES;
    }
    else if (!firstRowWalkthroughShown) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFirstRunWithText:@"This is your first row. Tap anywhere to continue."
                          andIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          andMaskEdges:CGRectMake(15, 15, - 2 * 15, - 2 * 15)
                   andShowTouchPointer:NO];
        });
        firstRowWalkthroughShown = YES;
    }
    else if (!secondRowWalkthroughShown) {
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFirstRunWithText:@"This is your second row with a really, really long description. Really long. I'm not kidding when I say that this description is long. Tap anywhere to continue."
                          andIndexPath:ip
                          andMaskEdges:CGRectMake(15, 15, - 2 * 15, - 2 * 15)
                   andShowTouchPointer:NO];
        });
        secondRowWalkthroughShown = YES;
    }
    else if (!thirdRowWalkthroughShown) {
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:2 inSection:0];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFirstRunWithText:@"This description should animate from the top on the iPhone 6 (or another with a smaller screen size) simulator. Tap anywhere to continue."
                          andIndexPath:ip
                          andMaskEdges:CGRectMake(15, 15, - 2 * 15, - 2 * 15)
                   andShowTouchPointer:NO];
        });
        thirdRowWalkthroughShown = YES;
    }
    else if (!firstRowWalkthroughWithTouchShown) {
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFirstRunWithText:@"Look at that, Morty! A touch pointer! Your touch will pass through this view if you tap the masked area. Touch it now!"
                          andIndexPath:ip
                          andMaskEdges:CGRectMake(15, 15, - 2 * 15, - 2 * 15)
                   andShowTouchPointer:YES];
        });
        firstRowWalkthroughWithTouchShown = YES;
    }
}

- (BOOL) showIntroViewWithText: (NSString *) text {
    
    [self createWalkthroughViewWithTouchPointer:NO];
    [_walkthrough setText:text];
    [[UIApplication sharedApplication].keyWindow addSubview:_walkthrough];
    [_walkthrough show];
    
    return YES;
}

- (BOOL) showFirstRunWithText: (NSString *) text
                 andIndexPath: (NSIndexPath *) indexPath
                 andMaskEdges: (CGRect) maskEdges
          andShowTouchPointer: (BOOL) showPointer{
    
    CGRect requiredRect = [_tableView rectForRowAtIndexPath:indexPath];
    requiredRect = [_tableView convertRect:requiredRect toView:_walkthrough];
    
    requiredRect.origin.x += maskEdges.origin.x;
    requiredRect.origin.y += maskEdges.origin.y;
    requiredRect.size.width += maskEdges.size.width;
    requiredRect.size.height += maskEdges.size.height;
    
    [self createWalkthroughViewWithTouchPointer:showPointer];
    [_walkthrough setText:text];
    [_walkthrough addMaskWithRect:requiredRect andCornerRadius:4.0f];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_walkthrough];
    [_walkthrough show];
    
    return YES;
}

- (void) createWalkthroughViewWithTouchPointer: (BOOL) showPointer {
    
    _walkthrough = [[WVWalkthroughView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [_walkthrough setHideOnTappingEmptyArea:YES];
    [_walkthrough setHideOnTappingTooltip:YES];
    [_walkthrough setHideOnTappingMaskedArea:YES];
    
    if (showPointer) {
        [_walkthrough setShowTouchPointer:YES];
        [_walkthrough setPassTouchThroughEmptyArea:YES];
    }
    
    //comment these two lines
    //to show the walkthough view
    //without any icon
    [_walkthrough setIconFont:[UIFont fontAwesomeFontOfSize:19]];
    [_walkthrough setIconText:[NSString fontAwesomeIconStringForEnum:FAQuestionCircle]];
    
    [_walkthrough setDelegate:self];
}

- (void) showAlertForIndexPath: (NSIndexPath *) indexPath {
    NSString *title = @"Cell was tapped!";
    NSString *description = [NSString stringWithFormat:@"You tapped the cell at row %ld.", (long)indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:description
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"I'm guilty :("
                                                       style:UIAlertActionStyleDestructive
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - WVWalkthroughViewDelegate methods

- (void) didTapEmptyAreaForWalkthrough:(WVWalkthroughView *)walkView {
    [self displayRequiredWalkthroughs];
}

- (void) didTapMaskedAreaForWalkthrough:(WVWalkthroughView *)walkView {
    [self displayRequiredWalkthroughs];
}

- (void) didTapTooltipForWalkthrough:(WVWalkthroughView *)walkView {
    [self displayRequiredWalkthroughs];
}

#pragma marl - table view methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 185.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dataDict = [_dataArray objectAtIndex:indexPath.row];
    UIImage *image = [dataDict objectForKey:@"image"];
    NSString *text = [dataDict objectForKey:@"text"];
    
    [cell.cellImageView setImage:image];
    [cell.descriptionLabel setText:text];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_walkthrough hide];
    [self showAlertForIndexPath:indexPath];
}

#pragma mark - misc methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PPOverviewTableViewController.m
//  Pennypot
//
//  Created by Matthew Nydam on 19/11/14.
//  Copyright (c) 2014 PP. All rights reserved.
//
#import "PPOverviewTableViewController.h"
#import "PPOverviewHeaderView.h"
#import "PPOverviewTableViewCell.h"
#import "PPPennyPot.h"
#import "PPDataManager.h"
#import "PPModifyPennyPotViewController.h"
#import "PPCreateObjectView.h"
#import "PPAnimatingAddControl.h"
#import "PPObjectCreationNotificationManager.h"

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL isCreatingObject;

@property (nonatomic, strong) PPOverviewTableViewCell *modifiyingCell;
@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;
@property (nonatomic, strong) PPCreateObjectView *createView;

@property (nonatomic, strong) UIView *transparentBackgroundView;

- (void)animateCreateView;

@end

@implementation PPOverviewTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [PPObjectCreationNotificationManager registerForStateChangedNotificationWithObserver:self andStateChangeSelector:@selector(stateChangedNotificationReceived:)];
    }
    return self;
}

- (void)viewDidLoad
{

    [self.tableView registerClass:PPOverviewTableViewCell.class forCellReuseIdentifier: [PPOverviewTableViewCell reuseIdentifier]];
    
    [self.view addSubview:self.createView];
    
    self.overviewHeader.height = [PPOverviewHeaderView headerHeight];
    
    self.tableView.tableHeaderView = self.overviewHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.createView.width = self.view.boundsWidth;
    self.createView.height = [PPCreateObjectView heightForView];

    self.createView.top = self.isCreatingObject ? self.overviewHeader.bottom : self.overviewHeader.bottom - self.createView.height;
    
    self.transparentBackgroundView.height = self.view.boundsHeight - self.overviewHeader.bottom;
    self.transparentBackgroundView.width = self.view.boundsWidth;
    self.transparentBackgroundView.bottom = self.view.boundsHeight;
}

- (void)dealloc
{
    [PPObjectCreationNotificationManager deregisterForStateChangedNotificationWithObserver:self];
    
    [self deregisterForKeyboardNotifications];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PPDataManager sharedManager] numberOfPennyObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PPOverviewTableViewCell heightForModel:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPOverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PPOverviewTableViewCell reuseIdentifier]];

    cell.delegate = self;
    [cell configureWithModel:[[PPDataManager sharedManager] pennyPotAtPosition:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPModifyPennyPotViewController *modifyController = [[PPModifyPennyPotViewController alloc] initWithMode:PPModifyModeEdit];
    
    UINavigationController *modifyNavigation = [[UINavigationController alloc] initWithRootViewController:modifyController];
    
    [self presentViewController:modifyNavigation animated:YES completion:^{
        
    }];
}

#pragma mark - Custom Cell Delegate

- (void)overviewTableViewCell:(PPOverviewTableViewCell *)cell didSwipeWithCellMode:(PPOverviewCellSwipeMode)mode
{
    PPPennyPot *pennyToEdit = cell.pennyPot;
    self.modifiyingCell = cell;
    
    if (mode == PPOverviewCellSwipeTypeDelete) {
        
        NSString *deleteString = [NSString stringWithFormat:@"Are you sure you want to delete %@", pennyToEdit.title];
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete?" message:deleteString delegate:self cancelButtonTitle:@"No"otherButtonTitles:@"Yes", nil];
        deleteAlert.delegate = self;
        [deleteAlert show];
        
    } else {
        
        PPModifyPennyPotViewController *modifyController = [[PPModifyPennyPotViewController alloc] initWithMode:PPModifyModeEdit];
        UINavigationController *modifyNavigation = [[UINavigationController alloc] initWithRootViewController:modifyController];
        
        [self presentViewController:modifyNavigation animated:YES completion:^{
            [cell swipeToOriginWithCompletion:nil];
        }];
    }
}

#pragma mark - Add Button Actions

- (void)stateChangedNotificationReceived:(NSNotification *)sender
{
    BOOL originatedFromAnimatingIcon = [[sender object] boolValue];
    
    if (originatedFromAnimatingIcon) {
        [self animateCreateView];

    } else if (self.isCreatingObject && ![self.createView shouldDismiss]) {
        
        [self.createView animateForEmptyTextFields];
        
    } else { // Shown, Add Button used. should return.
        
        [[PPDataManager sharedManager] addPennyPotToArray:[self.createView retrieveObjectFromForm]];
        
        [self.createView animateForEmptyTextFields];
        [self.tableView reloadData];
        [self animateCreateView];
    }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteCell];
    } else {
        if (self.modifiyingCell) {
            [self.modifiyingCell swipeToOriginWithCompletion:nil];
        }
    }
    
    self.modifiyingCell = nil;
}

#pragma mark - Animation States

- (void)animateCreateView
{
    CGFloat pointToAnimate;
    
    self.isCreatingObject = !self.isCreatingObject;
    
    if (self.isCreatingObject) {
        pointToAnimate = self.overviewHeader.bottom + self.createView.height;
        self.tableView.scrollEnabled = NO;
    } else {
        [self.createView resignResponders];
        pointToAnimate = self.overviewHeader.bottom;
        
        self.tableView.scrollEnabled = YES;
    }
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self animateTransparentBackgroundView];
    
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.65f initialSpringVelocity:.10f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.createView.bottom = pointToAnimate;
        
    } completion:^(BOOL finished) {
        if (self.isCreatingObject) {
            [self.createView initialResponder];
        }
    }];
    
}

- (void)animateTransparentBackgroundView
{
    if (self.isCreatingObject) {
        [self.tableView insertSubview:self.transparentBackgroundView belowSubview:self.createView];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.transparentBackgroundView.alpha = self.isCreatingObject ? 1.0f : 0.0f;
        
    } completion:^(BOOL finished) {
        if (!self.isCreatingObject) {
            [self.transparentBackgroundView removeFromSuperview];
        }
    }];
}

#pragma mark - Utilities

- (void)deleteCell
{
    NSIndexPath *deletePath = [self.tableView indexPathForCell:self.modifiyingCell];
    
    [[PPDataManager sharedManager] deletePennyObject:self.modifiyingCell.pennyPot];
    
    [self.tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Keyboard Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}

#pragma mark - Keyboard Listeners

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGPoint createViewBottom = (CGPoint){0, self.createView.bottom};
    
    CGFloat offset = createViewBottom.y - (self.view.boundsHeight -keyboardFrame.size.height);
    if (offset > 0) {
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Getters

- (PPOverviewHeaderView *)overviewHeader
{
    if (!_overviewHeader) {
        _overviewHeader = [[PPOverviewHeaderView alloc] initWithImage:[UIImage imageNamed:@"bridge"]];
    }
    return _overviewHeader;
}

- (PPCreateObjectView *)createView
{
    if (!_createView) {
        _createView = [[PPCreateObjectView alloc] initWithFrame:CGRectZero];
    }
    return _createView;
}

- (UIView *)transparentBackgroundView
{
    if (!_transparentBackgroundView) {
        _transparentBackgroundView = [UIView new];
        _transparentBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        _transparentBackgroundView.alpha = 0.0f;
    }
    return _transparentBackgroundView;
}

@end

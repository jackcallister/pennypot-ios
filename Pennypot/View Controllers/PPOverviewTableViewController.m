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
#import "PPAnimator.h"
#import "PPCreateViewController.h"

#import <ViewUtils/ViewUtils.h>
#import <MNFloatingActionButton/MNFloatingActionButton.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate, PPModifyPennyPotViewControllerDelegate, UIAlertViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) MNFloatingActionButton *createButton;

@property (nonatomic, strong) PPOverviewTableViewCell *modifiyingCell;
@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;

@end

@implementation PPOverviewTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:PPOverviewTableViewCell.class forCellReuseIdentifier: [PPOverviewTableViewCell reuseIdentifier]];
    
    [self.view addSubview:self.createButton];
    
    self.overviewHeader.height = [PPOverviewHeaderView headerHeight];
    
    self.tableView.tableHeaderView = self.overviewHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.createButton.height = self.createButton.width = 60.0f;
    self.createButton.bottom = self.view.boundsHeight - 20.0f;
    self.createButton.right = self.view.boundsWidth - 20.0f;
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
        
        PPModifyPennyPotViewController *modifyController = [[PPModifyPennyPotViewController alloc] initWithObject:pennyToEdit];
        modifyController.delegate = self;
        modifyController.transitioningDelegate = self;
        [self presentViewController:modifyController animated:YES completion:^{
            [cell swipeToOriginWithCompletion:nil];
        }];
    }
}

#pragma mark - Add Button Actions

- (IBAction)createButtonPressed:(id)sender
{
    PPCreateViewController *viewController = [PPCreateViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.transitioningDelegate = self;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [(PPOverviewHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [(PPOverviewHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark - Modify View Controller Delegate

- (void)modifyViewControllerDidReturnPennyPot:(PPPennyPot *)pennyPot
{
    [[PPDataManager sharedManager] updateObjects];
    [self.tableView reloadData];
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


#pragma mark - Utilities

- (void)deleteCell
{
    NSIndexPath *deletePath = [self.tableView indexPathForCell:self.modifiyingCell];
    
    [[PPDataManager sharedManager] deletePennyObject:self.modifiyingCell.pennyPot];
    
    [self.tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Getters

- (MNFloatingActionButton *)createButton
{
    if (!_createButton) {
        _createButton = [[MNFloatingActionButton alloc] initWithFrame:CGRectZero];
        [_createButton addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

- (PPOverviewHeaderView *)overviewHeader
{
    if (!_overviewHeader) {
        _overviewHeader = [[PPOverviewHeaderView alloc] initWithImage:[UIImage imageNamed:@"bridge"]];
    }
    return _overviewHeader;
}

#pragma mark - View Controller Transition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PPAnimator alloc] initWithPresentationType:PPAnimatorPresentationPresent];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[PPAnimator alloc] initWithPresentationType:PPAnimatorPresentationDismiss];
}

@end

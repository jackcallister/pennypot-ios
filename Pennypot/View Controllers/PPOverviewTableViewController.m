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

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL isCreatingObject;

@property (nonatomic, strong) PPOverviewTableViewCell *modifiyingCell;
@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;
@property (nonatomic, strong) PPCreateObjectView *createView;

- (void)animateCreateView;

@end

@implementation PPOverviewTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
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
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.createView.width = self.view.boundsWidth;
    self.createView.height = [PPCreateObjectView heightForView];

    self.createView.top = self.isCreatingObject ? self.overviewHeader.bottom : self.overviewHeader.bottom - self.createView.height;
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

- (IBAction)headerViewAddButtonPressed:(id)sender
{
    [self animateCreateView];
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
    CGFloat pointToAnimate = self.isCreatingObject ?  self.overviewHeader.bottom : self.overviewHeader.bottom + self.createView.height;
    
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:.10f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.createView.bottom = pointToAnimate;
        
    } completion:nil];
    
    self.isCreatingObject = !self.isCreatingObject;
}

#pragma mark - Utilities

- (void)deleteCell
{
    NSIndexPath *deletePath = [self.tableView indexPathForCell:self.modifiyingCell];
    
    [[PPDataManager sharedManager] deletePennyObject:self.modifiyingCell.pennyPot];
    
    [self.tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Getters

- (PPOverviewHeaderView *)overviewHeader
{
    if (!_overviewHeader) {
        _overviewHeader = [[PPOverviewHeaderView alloc] initWithImage:[UIImage imageNamed:@"bridge"]];
        [_overviewHeader.addButton addTarget:self action:@selector(headerViewAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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

@end

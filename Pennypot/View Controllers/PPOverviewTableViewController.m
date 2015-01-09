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

#import "PPAddButton.h"

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate, PPAddButtonDelegate, UIAlertViewDelegate, PPModifyPennyPotViewControllerDelegate>

@property (nonatomic) CGFloat addButtonBottom;

@property (nonatomic, strong) PPOverviewTableViewCell *modifiyingCell;

@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;
@property (nonatomic, strong) PPAddButton *addButton;

@end

static const CGFloat kButtonOffset = 20.0f;
static const CGFloat kButtonSize = 60.0f;


@implementation PPOverviewTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self.tableView addSubview:self.addButton];

    }
    return self;
}

- (void)viewDidLoad
{

    [self.tableView registerClass:PPOverviewTableViewCell.class forCellReuseIdentifier: [PPOverviewTableViewCell reuseIdentifier]];
    
    self.overviewHeader.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4f];
    
    self.overviewHeader.height = 250.0f;
    self.tableView.tableHeaderView = self.overviewHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // For floating button :'(
    self.addButton.height = self.addButton.width = kButtonSize;
    self.addButton.right = self.tableView.boundsWidth - kButtonOffset;
    
    self.addButtonBottom = self.addButton.bottom = [[UIScreen mainScreen] bounds].size.height - kButtonOffset;
    [self.tableView bringSubviewToFront:self.addButton];
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
        modifyController.delegate = self;
        UINavigationController *modifyNavigation = [[UINavigationController alloc] initWithRootViewController:modifyController];
        
        [self presentViewController:modifyNavigation animated:YES completion:^{
            [cell swipeToOriginWithCompletion:nil];
        }];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.addButton.y = scrollView.contentOffset.y + self.addButtonBottom - (kButtonSize/2);
    [self.tableView bringSubviewToFront:self.addButton];
    
    self.overviewHeader.y = scrollView.contentOffset.y/3;
}

#pragma mark - Add Button Delegate

- (void)addButtonPressed:(PPAddButton *)button
{
    PPModifyPennyPotViewController *addController = [[PPModifyPennyPotViewController alloc] initWithMode:PPModifyModeAdd];
    addController.delegate = self;
    UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addController];
    
    [self presentViewController:addNavigation animated:YES completion:nil];
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

#pragma mark - Modify View Controller delegate

- (void)modifyViewControllerDidReturnPennyPot:(PPPennyPot *)pennyPot
{
    [[PPDataManager sharedManager] addPennyPotToArray:pennyPot];
    [self.tableView reloadData];
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
    }
    return _overviewHeader;
}

- (PPAddButton *)addButton
{
    if (!_addButton) {
        _addButton = [[PPAddButton alloc] initWithFrame:CGRectZero];
        _addButton.delegate = self;
    }
    return _addButton;
}

@end

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

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate>

@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;

@property (nonatomic, strong) PPDataManager *dataManager;

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
    
    self.overviewHeader.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4f];
    
    self.tableView.tableHeaderView = self.overviewHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"%@, %@", @(self.tableView.contentSize.height), @([[UIScreen mainScreen] bounds].size.height));
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
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
//    PPPennyPot *pennyPot = [self.pen]
    
    PPModifyPennyPotViewController *modifyController = [[PPModifyPennyPotViewController alloc] initWithMode:PPModifyModeEdit];
    
    UINavigationController *modifyNavigation = [[UINavigationController alloc] initWithRootViewController:modifyController];
    
    [self presentViewController:modifyNavigation animated:YES completion:^{
        
    }];
    
}

#pragma mark - Custom Cell Delegate

- (void)overviewTableViewCell:(PPOverviewTableViewCell *)cell didSwipeWithCellMode:(PPOverviewCellSwipeMode)mode
{
    if (mode == PPOverviewCellSwipeTypeDelete) {
        
        NSIndexPath *deletePath = [self.tableView indexPathForCell:cell];
        
        [[PPDataManager sharedManager] deletePennyObject:cell.pennyPot];
        
        [self.tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        
        PPModifyPennyPotViewController *modifyController = [[PPModifyPennyPotViewController alloc] initWithMode:PPModifyModeEdit];
        
        UINavigationController *modifyNavigation = [[UINavigationController alloc] initWithRootViewController:modifyController];
        
        [self presentViewController:modifyNavigation animated:YES completion:^{
            [cell swipeToOriginWithCompletion:^{
                
            }];
        }];

    }
}


#pragma mark - Getters

- (PPOverviewHeaderView *)overviewHeader
{
    if (!_overviewHeader) {
        _overviewHeader = [[PPOverviewHeaderView alloc] initWithImage:[UIImage imageNamed:@"bridge"]];
    }
    return _overviewHeader;
}

@end

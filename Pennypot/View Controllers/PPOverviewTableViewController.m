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

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate, PPAddButtonDelegate>

@property (nonatomic) CGFloat addButtonBottom;

@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;
@property (nonatomic, strong) PPAddButton *addButton;

@property (nonatomic, strong) PPDataManager *dataManager;

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
    
    UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addController];
    
    [self presentViewController:addNavigation animated:YES completion:nil];
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

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

#import <ViewUtils/ViewUtils.h>

@interface PPOverviewTableViewController () <PPOverviewTableViewCellDelegate>

@property (nonatomic, strong) PPOverviewHeaderView *overviewHeader;

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
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PPOverviewTableViewCell heightForModel:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPOverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PPOverviewTableViewCell reuseIdentifier]];

    PPPennyPot *penny = [[PPPennyPot alloc] initWithTitle:@"New York" andSavingsGoal:3000];

    cell.delegate = self;
    [cell configureWithModel:penny];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PPPennyPot *pennyPot = [self.pen]
    
}

#pragma mark - Custom Cell Delegate

- (void)overviewTableViewCell:(PPOverviewTableViewCell *)cell didSwipeWithCellMode:(MCSwipeTableViewCellMode)mode
{
    [cell swipeToOriginWithCompletion:^{
        
    }];
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

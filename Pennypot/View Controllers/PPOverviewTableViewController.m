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

@interface PPOverviewTableViewController ()

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

    [cell configureWithModel:penny];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.overviewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [PPOverviewHeaderView heightForImage:[UIImage imageNamed:@"Bridge"]];
}

#pragma mark - Getters

- (PPOverviewHeaderView *)overviewHeader
{
    if (!_overviewHeader) {
        _overviewHeader = [[PPOverviewHeaderView alloc] initWithImage:[UIImage imageNamed:@"Bridge"]];
    }
    return _overviewHeader;
}

@end

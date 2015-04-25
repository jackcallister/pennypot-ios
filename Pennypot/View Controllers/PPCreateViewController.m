//
//  PPCreateViewController.m
//  Pennypot
//
//  Created by Matt Nydam on 11/04/15.
//  Copyright (c) 2015 PP. All rights reserved.
//

#import "PPCreateViewController.h"
#import "PPCreateObjectView.h"
#import "PPPennyPot.h"

#import <ViewUtils/ViewUtils.h>

@interface PPCreateViewController ()

@property (nonatomic, strong) PPCreateObjectView *createView;

@end

@implementation PPCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addButtonPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.createView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.createView.height = [PPCreateObjectView heightForView];
    self.createView.width = self.view.boundsWidth;
}

#pragma mark - Actions

- (IBAction)addButtonPressed:(id)sender
{
    PPPennyPot *savingObject = [self.createView retrieveObjectFromFormAnimateError];
    if (savingObject) {
        if ([self.delegate respondsToSelector:@selector(createViewController:didCreateObject:)]) {
            [self.delegate createViewController:self didCreateObject:savingObject];
        }
        [self dismissViewController];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewController];
}

#pragma mark - Private

- (void)dismissViewController
{
    [self.createView resignRespondersAndClearData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters

- (PPCreateObjectView *)createView
{
    if (!_createView) {
        _createView = [[PPCreateObjectView alloc] initWithFrame:CGRectZero];
    }
    return _createView;
}

@end

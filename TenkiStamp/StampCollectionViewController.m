//
//  StampCollectionViewController.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/5/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "StampCollectionViewController.h"

@interface StampCollectionViewController ()

@end

@implementation StampCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString* cellIndetifier = @"CellIdentifier";
    
    static NSString* cellIdentifier = @"StampGroupViewCell";
    
    StampGroupViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]lastObject];
    }
    
    
    
    return cell;
}


@end

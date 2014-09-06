//
//  StampCollectionViewController.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/5/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampGroupViewCell.h"

@interface StampCollectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *stampCollectionView;

@end

//
//  MainViewController.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"

@interface MainViewController : UITabBarController <TabBarDelegate> {
    TabBarView *customTabBarView;
}

@property (nonatomic, retain) IBOutlet TabBarView *customTabBarView;

-(void) hideExistingTabBar;

@end

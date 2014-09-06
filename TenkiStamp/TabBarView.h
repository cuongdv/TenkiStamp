//
//  TabBarView.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate methods for responding to TabBar events
@protocol TabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
-(void)tabWasSelected:(NSInteger)index;

@end

@interface TabBarView : UIView {
    
    NSObject<TabBarDelegate> *delegate;
    
    UIButton *selectedTab;
}

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;


@property (nonatomic, retain) NSObject<TabBarDelegate> *delegate;
@property (nonatomic, retain) UIButton *selectedTab;


-(IBAction) touchButton:(id)sender;

@end

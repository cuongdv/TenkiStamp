//
//  MainViewController.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end



@implementation MainViewController

@synthesize customTabBarView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self hideExistingTabBar];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    //self.customTabBarView = [nibObjects objectAtIndex:0];
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, 320, 49)];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    [container addSubview:self.customTabBarView];
    self.customTabBarView.delegate = self;
    [self.customTabBarView touchButton:self.customTabBarView.tab1];
    [self.view addSubview:container];
   
}

- (void)hideExistingTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

#pragma mark TabBarDelegate

-(void)tabWasSelected:(NSInteger)index {
    self.selectedIndex = index;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

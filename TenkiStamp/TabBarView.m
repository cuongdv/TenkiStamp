//
//  TabBarView.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "TabBarView.h"



@implementation TabBarView

@synthesize delegate;
@synthesize selectedTab;



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        //self.verticalSpace.constant = 300;

        //        [self updateConstraints];
        //        self = [[[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil] lastObject];

    }
    
    return self;
}



-(IBAction) touchButton:(id)sender {
    if( delegate != nil && [delegate respondsToSelector:@selector(tabWasSelected:)]) {
        
        
        switch ([sender tag]) {
            case 0:

                selectedTab = (UIButton*)sender;
                
                [selectedTab setBackgroundImage:[UIImage imageNamed:@"tab1_selected.png"] forState:UIControlStateNormal];
                [self.tab2 setBackgroundImage:[UIImage imageNamed:@"tab2.png"] forState:UIControlStateNormal];
               [self.tab3 setBackgroundImage:[UIImage imageNamed:@"tab3.png"] forState:UIControlStateNormal];
               
                
                [delegate tabWasSelected:selectedTab.tag];
                
                break;
                
            case 1:

                
                selectedTab = (UIButton*)sender;
                
                [selectedTab setBackgroundImage:[UIImage imageNamed:@"tab2_selected.png"] forState:UIControlStateNormal];
                
                [self.tab1 setBackgroundImage:[UIImage imageNamed:@"tab1.png"] forState:UIControlStateNormal];
                [self.tab3 setBackgroundImage:[UIImage imageNamed:@"tab3.png"] forState:UIControlStateNormal];
                
                [delegate tabWasSelected:selectedTab.tag];
                break;
                
            case 2:
 
                
                selectedTab = (UIButton*)sender;
                
                [selectedTab setBackgroundImage:[UIImage imageNamed:@"tab3_selected.png"] forState:UIControlStateNormal];
                
                [self.tab1 setBackgroundImage:[UIImage imageNamed:@"tab1.png"] forState:UIControlStateNormal];
                [self.tab2 setBackgroundImage:[UIImage imageNamed:@"tab2.png"] forState:UIControlStateNormal];
                [delegate tabWasSelected:selectedTab.tag];
                break;
                
            default:
                break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

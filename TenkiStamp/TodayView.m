//
//  TodayView.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "TodayView.h"

@implementation TodayView

@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:[[[NSBundle mainBundle]loadNibNamed:@"TodayView" owner:self options:nil] lastObject]];
    }
    return self;
}



- (IBAction)showSelectCity:(id)sender {
    
    [delegate actionSelectCity:sender];
    
    
}
@end

//
//  DateView.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/4/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "DateView.h"

@implementation DateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize weatherItem, day, dateMonth, icon, tempMax, tempMin, pop;

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:[[[NSBundle mainBundle]loadNibNamed:@"DateView" owner:self options:nil] lastObject]];
    }
    return self;
}
- (void)updateView {
    
    
    
    NSString* imageName = [[NSString alloc]initWithFormat:@"%ld.png", (long)weatherItem.weatherCode];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setImage:[UIImage imageNamed:imageName]];
    
    [tempMax setText:[[NSString alloc] initWithFormat:@"%ld°C", (long)weatherItem.tempMax]];
    
    
    
    [tempMin setText:[[NSString alloc] initWithFormat:@"%ld°C", (long)weatherItem.tempMin]];
    [pop setText:[[NSString alloc] initWithFormat:@"%ld%%", (long)weatherItem.pop]];
    
   
    
    [day setText:[self getDateFromNumber:weatherItem.day]];
    
    NSString* dateMonthString = [[NSString alloc]initWithFormat:@"%ld/%ld", (long)weatherItem.month, (long)weatherItem.date];
    [dateMonth setText:dateMonthString];
    
    
    //NSLog(@"UpdateView");
}

- (NSString*)getDateFromNumber:(NSInteger)num {
    
    
    NSArray* arrayDate = [[NSArray alloc]initWithObjects:@"月", @"火", @"水", @"木", @"金", @"土", @"日",  nil];
    
    return [arrayDate objectAtIndex:num];
}

@end

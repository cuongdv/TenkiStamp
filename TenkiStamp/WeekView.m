//
//  WeekView.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "WeekView.h"

@implementation WeekView

@synthesize delegate;
@synthesize dateViews;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:[[[NSBundle mainBundle]loadNibNamed:@"WeekView" owner:self options:nil] lastObject]];
        
    }
    return self;
}

- (void)addDateViewsWithData:(NSMutableArray*)data {
    
    
    dateViews = [[NSMutableArray alloc]init];
    
    for (int i=1; i < 7; i++) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil];
        DateView *dateView = [nibObjects lastObject];
        dateView.weatherItem = [data objectAtIndex:i];
        [dateView updateView];
        dateView.frame = CGRectMake((i-1)*50+10, 35, 0, 0);
        [self addSubview:dateView];
        [dateViews addObject:dateView];
    }
    
    for (int i=8; i < 14; i++) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil];
        DateView *dateView = [nibObjects lastObject];
        dateView.weatherItem = [data objectAtIndex:i];
        [dateView updateView];
        dateView.frame = CGRectMake((i-8)*50+10, 185, 0, 0);
        [self addSubview:dateView];
        [dateViews addObject:dateView];
    }
}

- (void)updateDateViews:(NSInteger)tag withData:(NSMutableArray*)data {
    
    if (tag == 1) {
        
        if ([data count] == 14) {
            for (int i=6;i<12; i++) {
                if ([[dateViews objectAtIndex:i] isKindOfClass:[DateView class]]) {
                    DateView *dateView = [dateViews objectAtIndex:i];
                    dateView.weatherItem = [data objectAtIndex:i+2];
                    [dateView updateView];
                }
            }
        } else {
            for (int i=6;i<12; i++) {
                if ([[dateViews objectAtIndex:i] isKindOfClass:[DateView class]]) {
                    DateView *dateView = [dateViews objectAtIndex:i];
                    dateView.weatherItem = [data objectAtIndex:i-5];
                    [dateView updateView];
                }
            }
        }
       
        
        
        
    } else {
    
        for (int i=0;i<6; i++) {
            if ([[dateViews objectAtIndex:i] isKindOfClass:[DateView class]]) {
                DateView *dateView = [dateViews objectAtIndex:i];
                dateView.weatherItem = [data objectAtIndex:i+1];
                
                [dateView updateView];
            }
        }
    }
    
}

- (IBAction)selectCity:(id)sender {
    //NSLog(@"Click");

    [delegate actionSelectCity:sender];
}
@end

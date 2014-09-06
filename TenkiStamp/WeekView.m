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
    
    [self showTimeForData:data];
    
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
    
    [self showTimeForData:data];
    
    
    if (tag == 1) {
    
        for (int i=6;i<12; i++) {
            if ([[dateViews objectAtIndex:i] isKindOfClass:[DateView class]]) {
                DateView *dateView = [dateViews objectAtIndex:i];
                dateView.weatherItem = [data objectAtIndex:i-5];
                [dateView updateView];
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

- (void)showTimeForData:(NSMutableArray*)data {
    
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    NSInteger date = [dateComponents day];
    
    
    NSDate* current = [NSDate date];
    NSTimeInterval interval = [current
                               timeIntervalSinceReferenceDate]/(60.0*60.0*24.0);
    long dayix=((long)interval) % 7;
    //long nextDay =
    NSMutableArray* days = [[NSMutableArray alloc]init];
    for (int x=0; x<2; x++) {
        for (int i=0; i<7; i++) {
            long temp = dayix + i;
            if (temp>6) {
                temp = temp-7;
            }
            switch (temp) {
                case 0:
                    [days addObject:@"月"];
                    break;
                case 1:
                    [days addObject:@"火"];
                    break;
                case 2:
                    [days addObject:@"水"];
                    break;
                case 3:
                    [days addObject:@"木"];
                    break;
                case 4:
                    [days addObject:@"金"];
                    break;
                case 5:
                    [days addObject:@"土"];
                    break;
                case 6:
                    [days addObject:@"日"];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    NSMutableArray* dates = [[NSMutableArray alloc]init];
        for (int i=0; i<7; i++) {
            [dates addObject:[[NSString alloc]initWithFormat:@"%d", date]];
            date++;
        }
    
    NSCalendar *gregorian1 = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents1 = [gregorian1 components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    NSInteger date1 = [dateComponents1 day];
    for (int i=0; i<7; i++) {
        [dates addObject:[[NSString alloc]initWithFormat:@"%d", date1]];
        date1++;
    }
    
    for (int i=0; i<data.count; i++) {
        


        WeatherItem* item = [data objectAtIndex:i];
        if(i <14) {
        item.day = [days objectAtIndex:i];
        NSString* dateMonthString = [[NSString alloc]initWithFormat:@"%ld/%@",(long)[dateComponents month],[dates objectAtIndex:i]];
 

        item.dateMonth = dateMonthString;
        }
    }
}


//- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        // Initialization code
//        self = [[[NSBundle mainBundle] loadNibNamed:@"WeekView" owner:self options:nil] lastObject];
//        
//    }
//    
//    return self;
//}

- (IBAction)selectCity:(id)sender {
    //NSLog(@"Click");

    [delegate actionSelectCity:sender];
}
@end

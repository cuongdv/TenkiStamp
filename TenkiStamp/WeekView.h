//
//  WeekView.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateView.h"
#import "TodayView.h"

@interface WeekView : UIView {
    NSObject<ActionSelectCity> *delegate;
    NSMutableArray* dateViews;
}


@property (nonatomic, retain) NSObject<ActionSelectCity> *delegate;
@property (nonatomic, retain) NSMutableArray* dateViews;

@property (weak, nonatomic) IBOutlet UILabel *upperCityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowerCityNameLabel;
- (void)addDateViewsWithData:(NSMutableArray*)data;
- (void)updateDateViews:(NSInteger)tag withData:(NSMutableArray*)data;
- (IBAction)selectCity:(id)sender;

@end

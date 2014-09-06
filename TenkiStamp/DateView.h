//
//  DateView.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/4/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherItem.h"

@interface DateView : UIView {
    WeatherItem* weatherItem;
}

@property (nonatomic, retain) WeatherItem* weatherItem;

@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *dateMonth;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tempMax;
@property (weak, nonatomic) IBOutlet UILabel *tempMin;
@property (weak, nonatomic) IBOutlet UILabel *pop;

//- (instancetype)initWithWeatherItem:(WeatherItem*)item;
- (void)updateView;

@end

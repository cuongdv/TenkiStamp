//
//  WeatherItem.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/5/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "WeatherItem.h"

@implementation WeatherItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize day, dateMonth, tempMax, tempMin, pop, weatherCode;

- (instancetype)initWithDay:(NSString*)d dateMonth:(NSString*)dM tempMax:(NSInteger)max tempMin:(NSInteger)min pop:(NSInteger)p weatherCode:(NSInteger)code {
    if (self = [super init]) {
        day = d;
        dateMonth = dM;
        tempMax = max;
        tempMin = min;
        pop = p;
        weatherCode = code;
    }
    return self;
}

@end

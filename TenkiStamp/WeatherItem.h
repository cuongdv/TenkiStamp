//
//  WeatherItem.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/5/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherItem : UIView {
    
    NSInteger weatherCode;
    NSInteger tempMax;
    NSInteger tempMin;
    NSInteger pop;
    NSString* day;
    NSString* dateMonth;
}

- (instancetype)initWithDay:(NSString*)d dateMonth:(NSString*)dM tempMax:(NSInteger)max tempMin:(NSInteger)min pop:(NSInteger)p weatherCode:(NSInteger)code ;

@property (nonatomic) NSInteger weatherCode;
@property (nonatomic) NSInteger tempMax;
@property (nonatomic) NSInteger tempMin;
@property (nonatomic) NSInteger pop;
@property (nonatomic) NSString* day;
@property (nonatomic) NSString* dateMonth;


@end

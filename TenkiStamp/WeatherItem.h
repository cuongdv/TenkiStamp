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
    NSInteger day;
    NSInteger date;
    NSInteger month;
}



@property (nonatomic) NSInteger weatherCode;
@property (nonatomic) NSInteger tempMax;
@property (nonatomic) NSInteger tempMin;
@property (nonatomic) NSInteger pop;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger date;
@property (nonatomic) NSInteger month;


@end

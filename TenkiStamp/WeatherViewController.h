//
//  ViewController.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 8/31/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "TodayView.h"
#import "WeekView.h"
#import "WeatherItem.h"
#import "ActionSheetStringPicker.h"

@interface WeatherViewController : UIViewController <ActionSelectCity, NSXMLParserDelegate> {
    TodayView* todayView;
    WeekView* weekView;
    NSDictionary* cities;
    
    //NSMutableArray* weatherData;
    //NSMutableArray* weatherDataUpper;
    //NSMutableArray* weatherDataLower;

}

@property (nonatomic, retain) NSDictionary* cities;
//@property (nonatomic, retain) NSMutableArray* weatherData;
//@property (nonatomic, retain) NSMutableArray* weatherDataUpper;
//@property (nonatomic, retain) NSMutableArray* weatherDataLower;


@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;

@property (nonatomic, retain) IBOutlet TodayView *todayView;
@property (nonatomic, retain) IBOutlet WeekView *weekView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
- (IBAction)update:(id)sender;

@end


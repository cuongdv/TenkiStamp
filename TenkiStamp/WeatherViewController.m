//
//  ViewController.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 8/31/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController () {
    
    NSString* mElement;
    NSMutableArray* weatherWeek;
    NSString* value;
    WeatherItem* weatherItem;
}

@end

@implementation WeatherViewController

@synthesize mainView;
@synthesize todayView, weekView;
@synthesize cities;
//@synthesize weatherData, cities, element;
//@synthesize weatherDataLower, weatherDataUpper;
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    NSInteger date = [dateComponents day];
    NSInteger month = [dateComponents month];
    
    NSString* currentDateString = [[NSString alloc]initWithFormat:@"%ld月%ld日の天気", (long)month, (long)date];
    [self.currentDateLabel setText:currentDateString];
    // Load CityData from resource
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"DataCityName" ofType:@"plist"];
    cities = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // Checking internet connection.
    if (![self checkingInternetConnection]) {
        
        NSLog(@"No internet connection");
        NSString *temp = [[NSBundle mainBundle]pathForResource:@"weather" ofType:@"xml"];
        NSData* data = [[NSData alloc]initWithContentsOfFile:temp];
        
        //weatherData = [[NSMutableArray alloc]init];
        //weatherDataUpper = [[NSMutableArray alloc]init];
        [self parseValueWithData:data];
        //weatherDataLower = [[NSMutableArray alloc]init];
        [self parseValueWithData:data];
        
    } else {
        //NSLog(@"There is internet connection");
        // Checking database
        
        //weatherData = [[NSMutableArray alloc]init];
        // Request for upper
        NSURL* urlUpper = [[NSURL alloc]initWithString:@"http://www.custamo.com/smartp/weather/?code=47945"];
        NSXMLParser *parserUpper = [[NSXMLParser alloc]initWithContentsOfURL:urlUpper];
        
        [parserUpper setDelegate:self];
        [parserUpper parse];
        
        // Request for lower
        NSURL* urllower = [[NSURL alloc]initWithString:@"http://www.custamo.com/smartp/weather/?code=47662"];
        NSXMLParser *parserlower = [[NSXMLParser alloc]initWithContentsOfURL:urllower];
        
        [parserlower setDelegate:self];
        [parserlower parse];
    }


    todayView = [[[NSBundle mainBundle] loadNibNamed:@"TodayView" owner:self options:nil] lastObject];
    todayView.delegate = self;
    //WeatherItem* today = [weatherData objectAtIndex:0];
    //[todayView.upperTempMax setText:[NSString stringWithFormat:@"%d°C /", today.tempMax]];
    [mainView addSubview:todayView];
    

    weekView = [[[NSBundle mainBundle] loadNibNamed:@"WeekView" owner:self options:nil] lastObject];
    weekView.frame = CGRectMake(320, 0, 320, 300);
    weekView.delegate = self;
    [mainView addSubview:weekView];
    [weekView addDateViewsWithData:weatherWeek];

    [mainView setContentSize:CGSizeMake(640, 300)];
    [mainView setPagingEnabled:YES];
    
    [self updateWeatherView];
}

- (void)parseValueWithCode:(NSInteger)code {
    
    NSMutableString* urlString = [[NSMutableString alloc]init];
    [urlString appendString:@"http://www.custamo.com/smartp/weather/?code="];
    [urlString appendFormat:@"%d", code];
    
    NSURL* url = [[NSURL alloc]initWithString:urlString];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
        
    [parser setDelegate:self];
    [parser parse];
}

- (void)parseValueWithData:(NSData*)data {
    
    NSXMLParser *parserUpper = [[NSXMLParser alloc]initWithData:data];
    
    [parserUpper setDelegate:self];
    [parserUpper parse];
}

- (void)updateWeatherView {
    
    [self updateUpper];
    [self updateLower];
    

}

- (void)updateUpper {
    WeatherItem* today = [weatherWeek objectAtIndex:0];
//    if (weatherDataUpper) {
//        [weekView updateDateViews:0 withData:weatherDataUpper];
//        today = [weatherDataUpper objectAtIndex:0];
//    }
    [todayView.upperTempMax setText:[NSString stringWithFormat:@"%d°C /", today.tempMax]];
    [todayView.upperTempMin setText:[NSString stringWithFormat:@"%d°C /", today.tempMin]];
    [todayView.upperPop setText:[NSString stringWithFormat:@"%d%% ", today.pop]];
    NSString* imageName = [[NSString alloc]initWithFormat:@"%d.png", today.weatherCode];
    //NSLog(@"%@", imageName);
    todayView.upperIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.upperIcon setImage:[UIImage imageNamed:imageName]];
    
}

- (void)updateLower {
    WeatherItem* today = [weatherWeek objectAtIndex:7];
//    if (weatherDataUpper) {
//        [weekView updateDateViews:1 withData:weatherDataUpper];
//        today = [weatherDataUpper objectAtIndex:0];
//    }
    [todayView.lowerTempMax setText:[NSString stringWithFormat:@"%d°C /", today.tempMax]];
    [todayView.lowerTempMin setText:[NSString stringWithFormat:@"%d°C /", today.tempMin]];
    [todayView.lowerPop setText:[NSString stringWithFormat:@"%d%% ", today.pop]];
    NSString* imageName = [[NSString alloc]initWithFormat:@"%d.png", today.weatherCode];
    todayView.lowerIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.lowerIcon setImage:[UIImage imageNamed:imageName]];
    
}

#pragma mark Parse XML Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    mElement = elementName;
    if (weatherItem == nil && [elementName isEqualToString:@"day"] && [attributeDict count] ==  0) {
        weatherItem = [[WeatherItem alloc]init];
        
        
        
    } else if ([elementName isEqualToString:@"day"] && [attributeDict count] > 0) {
        
        NSString* weatherCode = [attributeDict objectForKey:@"weather"];
        NSString* tempMax = [attributeDict objectForKey:@"tempmax"];
        NSString* tempMin = [attributeDict objectForKey:@"tempmin"];
        NSString* pop = [attributeDict objectForKey:@"pop"];
        
        
        if (tempMax && [weatherWeek count] > 0) {
            for (WeatherItem* item in weatherWeek) {
                if (item.tempMax == 0) {
                    item.weatherCode = [weatherCode integerValue];
                    item.tempMax = [tempMax integerValue];
                    item.tempMin = [tempMin integerValue];
                    item.pop = [pop integerValue];
                    break;
                }
            }
        }
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (weatherWeek == nil) {
        weatherWeek = [[NSMutableArray alloc]init];
    }
    
    if (value && [elementName isEqualToString:@"date"]) {
        weatherItem.date = [value integerValue];
    }
    
    if (value && [elementName isEqualToString:@"month"]) {
        weatherItem.month = [value integerValue];
    }
    
    if (value && [elementName isEqualToString:@"day"]) {
        if (value.length != 0) {
            weatherItem.day = [value integerValue];
        }
        if (weatherItem ) {
            [weatherWeek addObject:weatherItem];
            weatherItem = nil;
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([mElement isEqualToString:@"month"]) {
        value = string;
    }
    
    if ([mElement isEqualToString:@"date"]) {
        value = string;
    }
    
    if ([mElement isEqualToString:@"day"]) {
        value = string;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
 
    NSLog(@"%lu",(unsigned long)[weatherWeek count]);
}

- (void)actionSelectCity:sender {
    
    //weatherDataUpper = [[NSMutableArray alloc]init];
    
    if (![self checkingInternetConnection]) {
        UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString* currentCityName;
    if ([sender tag] == 0) {
        currentCityName = todayView.upperCityName.text;
    } else {
        currentCityName = todayView.lowerCityName.text;
    }
    
    NSArray *cityNames = [cities allValues];
    //NSArray *cityKeys = [cities allKeys];
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender tag] == 0 && ![selectedValue isEqualToString:currentCityName]){
            NSLog(@"Update Upper");
            [todayView.upperCityName setText:selectedValue];
            [weekView.upperCityNameLabel setText:selectedValue];
            [self parseValueWithCode:[[[cities allKeysForObject:selectedValue] objectAtIndex:0] integerValue]];
            [self updateUpper];
        } else if ([sender tag] == 1 && ![selectedValue isEqualToString:currentCityName]) {
            NSLog(@"Update Lower");
            [todayView.lowerCityName setText:selectedValue];
            [weekView.lowerCityNameLabel setText:selectedValue];
            [self parseValueWithCode:[[[cities allKeysForObject:selectedValue] objectAtIndex:0] integerValue]];
            [self updateLower];
        }
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
   [ActionSheetStringPicker showPickerWithTitle:@"地域設定"
                                            rows:cityNames
                               initialSelection:[cityNames indexOfObject:currentCityName]                                      doneBlock:done
                                     cancelBlock:cancel
                                          origin:sender];
}

- (BOOL)checkingInternetConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    if (![self checkingInternetConnection]) {
        UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
        [alertView show];
        //return;
    }
    
    //[weatherData removeAllObjects];
    
    NSInteger upperKey =  [[[cities allKeysForObject:todayView.upperCityName.text] objectAtIndex:0] integerValue];
    [self parseValueWithCode:upperKey];
    NSInteger lowerKey =  [[[cities allKeysForObject:todayView.lowerCityName.text] objectAtIndex:0] integerValue];
    [self parseValueWithCode:lowerKey];
}
@end

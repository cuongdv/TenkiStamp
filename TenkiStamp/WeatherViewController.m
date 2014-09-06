//
//  ViewController.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 8/31/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

@synthesize mainView;
@synthesize todayView, weekView;
@synthesize weatherData, cities, element;
@synthesize weatherDataLower, weatherDataUpper;
            
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
        
        weatherData = [[NSMutableArray alloc]init];
        //weatherDataUpper = [[NSMutableArray alloc]init];
        [self parseValueWithData:data];
        //weatherDataLower = [[NSMutableArray alloc]init];
        [self parseValueWithData:data];
        
    } else {
        //NSLog(@"There is internet connection");
        // Checking database
        
        weatherData = [[NSMutableArray alloc]init];
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
    [weekView addDateViewsWithData:weatherData];

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
    WeatherItem* today = [weatherData objectAtIndex:0];
    if (weatherDataUpper) {
        [weekView updateDateViews:0 withData:weatherDataUpper];
        today = [weatherDataUpper objectAtIndex:0];
    }
    [todayView.upperTempMax setText:[NSString stringWithFormat:@"%d°C /", today.tempMax]];
    [todayView.upperTempMin setText:[NSString stringWithFormat:@"%d°C /", today.tempMin]];
    [todayView.upperPop setText:[NSString stringWithFormat:@"%d%% ", today.pop]];
    NSString* imageName = [[NSString alloc]initWithFormat:@"%d.png", today.weatherCode];
    //NSLog(@"%@", imageName);
    todayView.upperIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.upperIcon setImage:[UIImage imageNamed:imageName]];
    
}

- (void)updateLower {
    WeatherItem* today = [weatherData objectAtIndex:7];
    if (weatherDataUpper) {
        [weekView updateDateViews:1 withData:weatherDataUpper];
        today = [weatherDataUpper objectAtIndex:0];
    }
    [todayView.lowerTempMax setText:[NSString stringWithFormat:@"%d°C /", today.tempMax]];
    [todayView.lowerTempMin setText:[NSString stringWithFormat:@"%d°C /", today.tempMin]];
    [todayView.lowerPop setText:[NSString stringWithFormat:@"%d%% ", today.pop]];
    NSString* imageName = [[NSString alloc]initWithFormat:@"%d.png", today.weatherCode];
    todayView.lowerIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.lowerIcon setImage:[UIImage imageNamed:imageName]];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;

    if ([elementName isEqualToString:@"day"]) {
        
        NSString* weatherCode = [attributeDict objectForKey:@"weather"];
        if (weatherCode) {
            
            
            NSString* max = [attributeDict objectForKey:@"tempmax"];
            NSString* min = [attributeDict objectForKey:@"tempmin"];
            NSString* pop = [attributeDict objectForKey:@"pop"];
            
          
            
            WeatherItem* item = [[WeatherItem alloc]initWithDay:@"" dateMonth:@"" tempMax:[max integerValue] tempMin:[min integerValue] pop:[pop integerValue] weatherCode:[weatherCode integerValue]];
            
            [weatherData addObject:item];
            if (weatherDataUpper) {
                [weatherDataUpper addObject:item];
            }
            
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!weatherDataLower) {
        weatherDataLower = [[NSMutableArray alloc]init];
    }
    
    if ([element isEqualToString:@"date"]) {
       //NSLog(@"%@", string);

        NSInteger number = [string integerValue];
       
       if ([string length] != 0 && number > 0) {
           
           [weatherDataLower addObject:string];
        }
    }
    
    if ([element isEqualToString:@"month"]) {
        //NSLog(@"%@", string);
        
        NSInteger number = [string integerValue];
        
        if ([string length] != 0 && number > 0) {
            
            [weatherDataLower addObject:string];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //NSLog(@"Count Array = %d", [weatherData count]);
    if ([weatherData count] == 7) {
        [self updateUpper];
       // NSLog(@"DayCount = %d", [weatherDataLower count] );
      //  [weatherDataLower removeObjectAtIndex:0];
      //  [weatherDataLower removeObjectAtIndex:0];

       // NSLog(@"DayCount = %d", [weatherDataLower count] );

    } else if ([weatherData count] == 14) {
        [self updateLower];
        
        /*
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
        */

        
        //NSLog(@"DayCount = %d", [days count] );
        
        for (int i=0; i<2; i++) {
            [weatherDataLower removeObjectAtIndex:0];
        }
        
        for (int i=0; i<2; i++) {
            if ([[weatherDataLower objectAtIndex:1] isEqualToString:@"6"]) {
                [weatherDataLower removeObjectAtIndex:14];

            }
        }
        
        //[days removeObjectAtIndex:0];
        //[days removeObjectAtIndex:6];
        
        NSLog(@"DayCount = %d", [weatherDataLower count] );
        for (int i =0; i < 28; i += 2) {
            NSInteger temp = i/2+i%2;
            if (temp == 0 ||temp == 7) {
                continue;
            }
            WeatherItem* item = [weatherData objectAtIndex:temp];
            NSInteger month = [[weatherDataLower objectAtIndex:temp*2] integerValue];
            NSInteger date = [[weatherDataLower objectAtIndex:temp*2+1] integerValue];
            item.dateMonth = [[NSString alloc]initWithFormat:@"%d/%d",month,date ];
            //item.day = [days objectAtIndex:temp];
            
        }
        
    }
    
    /*
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
    
    NSLog(@"DayCount = %lu", (unsigned long)[weatherDataLower count] );
//    NSMutableArray* emWDL = [weatherDataLower subarrayWithRange:NSMakeRange(weatherDataLower.count -26, 26)];

    for (int i =1; i < 7; i ++) {
       
        WeatherItem* item = [weatherDataUpper objectAtIndex:i];
        NSInteger tempM = 2*i;
        NSInteger month = [[weatherDataLower objectAtIndex:tempM] integerValue];
        NSInteger tempD = 2*i + 1;
        NSInteger date = [[weatherDataLower objectAtIndex:tempD] integerValue];
        item.dateMonth = [[NSString alloc]initWithFormat:@"%ld/%ld",(long)month,(long)date ];
        item.day = [days objectAtIndex:i];
        
    }
    
    
     */
}

- (void)actionSelectCity:sender {
    
    weatherDataUpper = [[NSMutableArray alloc]init];
    
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
    
    [weatherData removeAllObjects];
    
    NSInteger upperKey =  [[[cities allKeysForObject:todayView.upperCityName.text] objectAtIndex:0] integerValue];
    [self parseValueWithCode:upperKey];
    NSInteger lowerKey =  [[[cities allKeysForObject:todayView.lowerCityName.text] objectAtIndex:0] integerValue];
    [self parseValueWithCode:lowerKey];
}
@end

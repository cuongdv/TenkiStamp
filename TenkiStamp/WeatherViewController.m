//
//  ViewController.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 8/31/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "WeatherViewController.h"

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface WeatherViewController () {
    
    NSString* mElement;
    NSMutableArray* weatherWeek;
    NSString* value;
    WeatherItem* weatherItem;
    NSInteger indexUpdate;
    NSInteger stampTypeUpper, stampTypeLower;
    NSMutableString* imageNamedStamp;
    NSMutableArray* stampCollection;
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
        
        //Osaka weather code
        //NSString* upperCode = [[NSString alloc]initWithFormat:@"%d", 47945];
        //Tokyo weather code
        //NSString* lowerCode = [[NSString alloc]initWithFormat:@"%d", 47662];
        // Get data for all
        //[self getDataForUpper:upperCode andLower:lowerCode];
    }

    todayView = [[[NSBundle mainBundle] loadNibNamed:@"TodayView" owner:self options:nil] lastObject];
    todayView.delegate = self;
    [mainView addSubview:todayView];

    weekView = [[[NSBundle mainBundle] loadNibNamed:@"WeekView" owner:self options:nil] lastObject];
    weekView.frame = CGRectMake(320, 0, 320, 300);
    weekView.delegate = self;
    [mainView addSubview:weekView];
    [weekView addDateViewsWithData:weatherWeek];

    [mainView setContentSize:CGSizeMake(640, 300)];
    [mainView setPagingEnabled:YES];
    
    [self update:self.refreshButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    AppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    
    stampCollection = delegate.stampCollection;
    
    NSLog(@"Stamp Collection Count = %lu", (unsigned long)stampCollection.count);

    
    //delegate.stampDatabase insert:<#(StampInfo *)#>
    
}

- (void)parseValueWithCode:(NSInteger)code {
    
    weatherWeek = [[NSMutableArray alloc]init];
    
    NSMutableString* urlString = [[NSMutableString alloc]init];
    [urlString appendString:@"http://www.custamo.com/smartp/weather/?code="];
    [urlString appendFormat:@"%ld", (long)code];
    
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
    [weekView updateDateViews:0 withData:weatherWeek];

    [todayView.upperTempMax setText:[NSString stringWithFormat:@"%ld°C /", (long)today.tempMax]];
    [todayView.upperTempMin setText:[NSString stringWithFormat:@"%ld°C /", (long)today.tempMin]];
    [todayView.upperPop setText:[NSString stringWithFormat:@"%ld%% ", (long)today.pop]];
    
    NSString* imageName = [[NSString alloc]initWithFormat:@"%ld.png", (long)today.weatherCode];
    todayView.upperIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.upperIcon setImage:[UIImage imageNamed:imageName]];
    
    todayView.upperStampView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSMutableString* imageNS = [self randomStampViewFromCode:today.weatherCode];
    UIImage* image = [UIImage imageNamed:imageNS];
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    if (cim == nil && cgref == NULL)
    {
        [imageNS appendString:@".gif"];
        image = [UIImage imageNamed:imageNS];
    }
    
    [todayView.upperStampView setImage:image];
    
    [self insertDataToDatabase];
}

- (void)updateLower {
    WeatherItem* today = [weatherWeek objectAtIndex:0];
    if ([weatherWeek count] == 14) {
        today = [weatherWeek objectAtIndex:7];
    }
    [weekView updateDateViews:1 withData:weatherWeek];
    [todayView.lowerTempMax setText:[NSString stringWithFormat:@"%ld°C /", (long)today.tempMax]];
    [todayView.lowerTempMin setText:[NSString stringWithFormat:@"%ld°C /", (long)today.tempMin]];
    [todayView.lowerPop setText:[NSString stringWithFormat:@"%ld%% ", (long)today.pop]];
    NSString* imageName = [[NSString alloc]initWithFormat:@"%ld.png", (long)today.weatherCode];
    todayView.lowerIcon.contentMode = UIViewContentModeScaleAspectFit;
    [todayView.lowerIcon setImage:[UIImage imageNamed:imageName]];
    
    todayView.lowerStampView.contentMode = UIViewContentModeScaleAspectFit;
        
     NSMutableString* imageNS = [self randomStampViewFromCode:today.weatherCode];
    UIImage* image = [UIImage imageNamed:imageNS];
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    if (cim == nil && cgref == NULL)
    {
        [imageNS appendString:@".gif"];
        image = [UIImage imageNamed:imageNS];
    }
    
    [todayView.lowerStampView setImage:image];
    [self insertDataToDatabase];
}

- (void)insertDataToDatabase {
    
    AppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    StampDatabase* database = delegate.stampDatabase;
    
    NSInteger position = 0;
    
    if ([database stampCollection].count != 0) {
        while ([self randomRuningWithInt:position]) {
            position = arc4random()%301;
        }
    }
    StampInfo* stampInfo = [[StampInfo alloc]initWithName:imageNamedStamp position:position watched:0];
    
    [database insert:stampInfo];
    
}

- (BOOL)randomRuningWithInt:(NSInteger)num {
    
    AppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    stampCollection = [delegate stampCollection];
    for (StampInfo* stampInfo in stampCollection) {
        if (stampInfo.position == num) {
            return NO;
        };
    }
    return YES;
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
    
    if ([mElement isEqualToString:@"month"]
        || [mElement isEqualToString:@"date"]
        || [mElement isEqualToString:@"day"]) {
        value = string;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
 
    //NSLog(@"%lu",(unsigned long)[weatherWeek count]);
    if ([weatherWeek count] == 14) {
        [self updateWeatherView];
    }
}

- (void)actionSelectCity:sender {
    
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
    NSMutableArray* filterCityName = [[NSMutableArray alloc]initWithArray:cityNames];
    [filterCityName removeObject:todayView.upperCityName.text];
    [filterCityName removeObject:todayView.lowerCityName.text];
    
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
                                            rows:filterCityName
                               initialSelection:0                                      doneBlock:done
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
}

- (void)getDataForUpper:(NSString*)upperCode andLower:(NSString*)lowerCode {
    // Request for Upper
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:@"http://www.custamo.com/smartp/weather/?code="];
    [urlString appendString:upperCode];
    
    NSURL* urlUpper = [[NSURL alloc]initWithString:urlString];
    NSXMLParser *parserUpper = [[NSXMLParser alloc]initWithContentsOfURL:urlUpper];
    
    [parserUpper setDelegate:self];
    [parserUpper parse];
    
    //NSLog(@"%@", urlString);
    
    // Request for lower
    urlString = [[NSMutableString alloc]initWithString:@"http://www.custamo.com/smartp/weather/?code="];
    [urlString appendString:lowerCode];
    NSURL* urllower = [[NSURL alloc]initWithString:urlString];
    NSXMLParser *parserlower = [[NSXMLParser alloc]initWithContentsOfURL:urllower];
    //NSLog(@"%@", urlString);

    [parserlower setDelegate:self];
    [parserlower parse];
}

- (IBAction)update:(id)sender {
    if (![self checkingInternetConnection]) {
        UIAlertView* alertView =[[UIAlertView alloc] initWithTitle:@"" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString* upperCode =  [[cities allKeysForObject:todayView.upperCityName.text] objectAtIndex:0] ;
    NSString* lowerCode =  [[cities allKeysForObject:todayView.lowerCityName.text] objectAtIndex:0];

    weatherWeek = [[NSMutableArray alloc]init];
    [self getDataForUpper:upperCode andLower:lowerCode];
}

- (NSMutableString*)randomStampViewFromCode:(NSInteger)code  {
    NSMutableString* imageNamed = [[NSMutableString alloc]init];
    
    //indexUpdate = code;
    
    if (code < 200) {
        [imageNamed appendString:@"sunny_"];
        
    } else if (code >= 200 || code < 300) {
        [imageNamed appendString:@"cloudy_"];
    } else if (code >= 300) {
        [imageNamed appendString:@"rainy_"];
    }
    
    int num = RAND_FROM_TO(0, 99);
    
    [imageNamed appendFormat:@"%d", num];
    imageNamedStamp = imageNamed;
    NSLog(@"%@", imageNamed);
    
    return imageNamed;
}
@end

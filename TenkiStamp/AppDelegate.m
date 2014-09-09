//
//  AppDelegate.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 8/31/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSString *temperature;

@end

@implementation AppDelegate
            
@synthesize stampDatabase, stampCollection;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    stampDatabase = [StampDatabase database];
    stampCollection = [stampDatabase stampCollection];
    
    NSLog(@"Stamp Collection Count = %lu", (unsigned long)stampCollection.count);
    
    
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    
    NSInteger hour = [dateComponents hour];
    if (hour == 3) {
        [[UIApplication sharedApplication]
         setMinimumBackgroundFetchInterval:
         UIApplicationBackgroundFetchIntervalMinimum];
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
   
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Background fetch started...");
    NSString *urlString = [NSString stringWithFormat:
                           @"http://api.openweathermap.org/data/2.5/weather?q=%@",
                           @"Singapore"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                if (!error && httpResp.statusCode == 200) {
                    //---print out the result obtained---
                    NSString *result =
                    [[NSString alloc] initWithBytes:[data bytes]
                                             length:[data length]
                                           encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", result);
                    
                    //---parse the JSON result---
                    [self parseJSONData:data];
                    
                    //---update the UIViewController---
                    /*WeatherViewController *vc =
                    (WeatherViewController *)
                    [[[UIApplication sharedApplication] keyWindow]
                     rootViewController];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        vc.testLabel.text = self.temperature;
                    });*/
                    
                    completionHandler(UIBackgroundFetchResultNewData);
                    NSLog(@"Background fetch completed...");
                } else {
                    NSLog(@"%@", error.description);
                    completionHandler(UIBackgroundFetchResultFailed);
                    NSLog(@"Background fetch Failed...");
                }
            }
      ] resume
     ];
    
    NSLog(@"Background fetch completed...");
}

- (void)parseJSONData:(NSData *)data {
    NSError *error;
    NSDictionary *parsedJSONData =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:kNilOptions
                                      error:&error];
    NSDictionary *main = [parsedJSONData objectForKey:@"main"];
    
    //---temperature in Kelvin---
    NSString *temp = [main valueForKey:@"temp"];
    
    //---convert temperature to Celcius---
    float temperature = [temp floatValue] - 273;
    
    //---get current time---
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *timeString = [formatter stringFromDate:date];
    
    self.temperature = [NSString stringWithFormat:
                        @"%f degrees Celsius, fetched at %@",
                        temperature, timeString];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

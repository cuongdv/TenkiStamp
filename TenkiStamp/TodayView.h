//
//  TodayView.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/3/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSelectCity <NSObject>

-(void)actionSelectCity:(id)sender;

@end


@interface TodayView : UIView {
    NSObject<ActionSelectCity> *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *lowerCityName;
@property (weak, nonatomic) IBOutlet UILabel *upperCityName;
@property (weak, nonatomic) IBOutlet UIImageView *upperIcon;
@property (weak, nonatomic) IBOutlet UIImageView *lowerIcon;
@property (weak, nonatomic) IBOutlet UILabel *upperTempMax;
@property (weak, nonatomic) IBOutlet UILabel *upperTempMin;
@property (weak, nonatomic) IBOutlet UILabel *upperPop;
@property (weak, nonatomic) IBOutlet UILabel *lowerTempMax;
@property (weak, nonatomic) IBOutlet UILabel *lowerTempMin;
@property (weak, nonatomic) IBOutlet UILabel *lowerPop;
@property (weak, nonatomic) IBOutlet UIImageView *upperStampView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerStampView;

@property (nonatomic, retain) NSObject<ActionSelectCity> *delegate;
- (IBAction)showSelectCity:(id)sender;

@end

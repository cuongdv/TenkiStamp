//
//  StampInfo.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/8/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StampInfo : NSObject {

    int _rowid;
    NSInteger _position;
    int _watched;
    NSString* _name;

}

@property (nonatomic, assign) int rowid;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) int watched;
@property (strong, nonatomic) NSString* name;

- (id)initWithName:(NSString*)pName position:(int)pPosition watched:(int)pWatched;

@end

//
//  StampInfo.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/8/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "StampInfo.h"

@implementation StampInfo

@synthesize rowid, name, position, watched;

- (id)initWithName:(NSString *)pName position:(int)pPosition watched:(int)pWatched {
    
    if ((self = [super init])) {
        name = pName;
        position = pPosition;
        watched = pWatched;
    }
    
    return self;
}

@end

//
//  StampDatabase.h
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/8/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "StampInfo.h"

@interface StampDatabase : NSObject {
    sqlite3* _database;
}

+ (StampDatabase*)database;
- (NSMutableArray*)stampCollection;
-(int) insert:(StampInfo*)stampInfo;

@end

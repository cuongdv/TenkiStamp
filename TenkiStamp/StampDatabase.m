//
//  StampDatabase.m
//  TenkiStamp
//
//  Created by Huỳnh Phúc on 9/8/14.
//  Copyright (c) 2014 Huỳnh Phúc. All rights reserved.
//

#import "StampDatabase.h"

@implementation StampDatabase

static StampDatabase* _database;

+ (StampDatabase *)database
{
    if (_database == nil) {
        _database = [[StampDatabase alloc]init];
    }
    return _database;
}

- (NSMutableArray *)stampCollection
{
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    
    NSString* query = @"SELECT * FROM stamp_collection";
    sqlite3_stmt* statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            //int rowid = sqlite3_column_int(statement, 0);
            int watched = sqlite3_column_int(statement, 2);
            int position = sqlite3_column_int(statement, 3);

            char* nameChars = (char*)sqlite3_column_text(statement, 1);
            NSString* name = [[NSString alloc]initWithUTF8String:nameChars];
            
          
            
            
            StampInfo* stampInfo = [[StampInfo alloc]initWithName:name position:position watched:watched];
            
            [retval addObject:stampInfo];
            
            
            //SongInfo* songInfo = [[SongInfo alloc]initWithRowId:rowid name:name];
            
            //[retval addObject:songInfo];
            
            //NSLog(@"RowId = %d", rowid);
            
        }
        
        sqlite3_finalize(statement);
    }
    
    return  retval;
}

-(int) insert:(StampInfo*)stampInfo {
 
    int rc = 0;
    NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO stamp_collection (_name,_postion,_watched) VALUES (\"%@\",%ld,%ld)",stampInfo.name,(long)stampInfo.position,(long)stampInfo.watched];
    char * errMsg;
    rc = sqlite3_exec(_database, [query UTF8String] ,NULL,NULL,&errMsg);
    
    if(SQLITE_OK != rc)
    {
        NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
    }
    
    sqlite3_close(_database);
    
    return rc;
}




- (id) init
{
    if ((self = [super init])) {
        NSString* sqliteDBPath = [[NSBundle mainBundle]pathForResource:@"tenkistamp" ofType:@".sqlite"];
        if (sqlite3_open([sqliteDBPath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Error Open Databae");
        }
    }
    return self;
}
@end

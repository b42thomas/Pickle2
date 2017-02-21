//
//  RWGameData.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/19/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

#import "RWGameData.h"  //this is where you store information that is going to be used in more than one scene

@implementation RWGameData

//characterArray = @[@"BlankCharacter-1", @"PickleCharacter-1"];



- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
        _characterIndex = [decoder decodeDoubleForKey: SSGameDataCharacterIndex];
    }
    return self;
}
+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [RWGameData filePath]];
    if (decodedData) {
        RWGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[RWGameData alloc] init];
}


+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)reset  //run everytime app is opened
{
    self.score = 0;
    self.characterIndex = 0;
}

static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataCharacterIndex = @"characterIndex";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
    [encoder encodeDouble:self.characterIndex forKey: SSGameDataHighScoreKey];

   
}


-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[RWGameData filePath] atomically:YES];
}




@end

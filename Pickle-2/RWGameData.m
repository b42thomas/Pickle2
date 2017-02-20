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



+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)reset  //run everytime app is opened
{
    self.score = 0;
    self.characterIndex = 0;
}



@end

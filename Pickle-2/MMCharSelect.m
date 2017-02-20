//
//  MMCharSelect.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/20/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

#import "MMCharSelect.h"

@implementation MMCharSelect


+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}



@end

//
//  MMCharSelect.h
//  Pickle-2
//
//  Created by Billy Thomas on 2/20/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MMCharSelect : NSObject

@property () NSArray *characterSelection; //= [NSArray array];
@property () SKTextureAtlas *characterAtlas;// = [SKTextureAtlas atlasNamed:@"CharacterAtlas"];

+(void)createAtlas;
+(instancetype)sharedGameData;

@end

//
//  GameScene.h
//  Pickle-2
//
//  Created by Billy Thomas on 2/20/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "MainMenuScene.h"


@interface GameScene : SKScene
@property BOOL contentCreated;
@property BOOL playing;

@property  NSArray *allCharacters; //= [NSArray array];
@property  NSArray *characterAnimate; //= [NSArray array];
@property NSArray *charFrames;

@property SKTexture *f1;
@property SKTexture *f2;
@property SKTexture *f3;
@property SKTexture *f4;

@property CGFloat x;
@property CGFloat y;

@property int playerSpeed;

@property SKAction *runAnimation;
@property SKAction *moveRight;
@property SKAction *moveLeft;
@property SKAction *runGroup;
@property SKAction *repeatAnimation;
@property SKAction *repeatMoveLeft;
@property SKAction *repeatMoveRight;

@property SKSpriteNode *player;

@property BOOL playerFacingRight; 

@end

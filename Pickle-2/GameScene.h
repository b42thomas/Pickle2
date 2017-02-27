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
#import "textures.h"


@interface GameScene : SKScene <SKPhysicsContactDelegate>
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

@property CGFloat g;

@property CGFloat gloveDistance;
@property CGFloat points;
//@property CGFloat speed;
//@property CGFloat

@property SKAction *runAnimation;
@property SKAction *moveRight;
@property SKAction *moveLeft;
@property SKAction *runGroup;
@property SKAction *repeatAnimation;
@property SKAction *repeatMoveLeft;
@property SKAction *repeatMoveRight;

@property SKAction *runRight;
@property SKAction *runLeft;

@property SKAction*throwBallToRight;
@property SKAction*throwBallToLeft;

@property SKSpriteNode *background;
@property SKSpriteNode *player;
@property SKSpriteNode *leftBaseman;
@property SKSpriteNode *leftArm;
@property SKSpriteNode *rightBaseman;
@property SKSpriteNode *rightArm;
@property SKSpriteNode *ball;

@property BOOL playerFacingRight;
@property BOOL shouldThrowBall;
@property BOOL leftHasBall;
@property BOOL rightHasBall;
@property BOOL movingRight;
@property BOOL movingLeft;
@property BOOL moving;

@property BOOL leftBasemanHasBall;
@property BOOL rightBasemanHasBall;

@end

//
//  GameScene.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/20/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//


#import "MainMenuScene.h"
#import "RWGameData.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "MainMenuScene.h"
#import "textures.h"




@implementation GameScene :SKScene

- (void)didMoveToView: (SKView *) view
{
    self.x = [self getParentSizeX];
    self.y = [self getParentSizeY];
    
    self.characterAnimate = [self determineCharacterFrames];
    
    self.f1 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:0]];
    self.f2 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    self.f3 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:2]];
    self.f4 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    
    self.charFrames = @[self.f1,self.f2,self.f3,self.f4];
    self.playerSpeed = 1;
    
    
    self.runAnimation = [SKAction animateWithTextures:self.charFrames timePerFrame:0.15];
    self.moveRight = [SKAction moveByX:(10+self.playerSpeed) y:0 duration:0.2];
    self.moveLeft = [SKAction moveByX:-(10 +self.playerSpeed) y:0 duration:0.2];
    self.repeatAnimation = [SKAction repeatActionForever:self.runAnimation];
    self.repeatMoveLeft = [SKAction repeatActionForever:self.moveLeft];
    self.repeatMoveRight = [SKAction repeatActionForever:self.moveRight];
    
    self.runGroup = [SKAction repeatActionForever:[SKAction group:@[self.repeatAnimation,self.repeatMoveRight]]];
    
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    
    [self playerRunRight];
    
}

- (void)didFinishUpdate  //game logic
{
    
   
    
    if(self.player.position.x > self.frame.size.width*0.75)
    {
        self.playerFacingRight = NO;
        self.player.size = CGSizeMake(-1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
        [self playerRun];
    }
    if(self.player.position.x < self.frame.size.width*0.25)
    {
        self.playerFacingRight = YES;
        self.player.size = CGSizeMake(1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
        [self playerRun];
    }

    
}


-(void)playerRun
{
    if(self.playerFacingRight)
    {
        [self playerRunLeft];
    } else
    {
        [self playerRunRight];
    }
}

-(void)playerRunRight
{
   // self.player.removeAllActions;
    self.runGroup = [SKAction repeatActionForever:[SKAction group:@[self.repeatAnimation,self.repeatMoveRight]]];
    [self.player runAction:self.runGroup withKey:@"playerRunLeft"];
}

-(void)playerRunLeft
{
    //self.player.remo;
    self.runGroup = [SKAction repeatActionForever:[SKAction group:@[self.repeatAnimation,self.repeatMoveLeft]]];
    [self.player runAction:self.runGroup withKey:@"playerRunRight"];
}


-(void)createSceneContents
{

    [self addChild:[self addBackground]];

}

-(SKSpriteNode *)addBackground
{
    
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"AppBackground"];
    background.size = self.scene.size;
    background.anchorPoint = CGPointMake(0, 0);
    background.position = CGPointMake(0, 0);
    
    self.player = [self addPlayer];
   // SKSpriteNode *leftBaseman = [self addLeftBaseman];
    //SKSpriteNode *rightBaseman = [self addRightBaseman];
    //SKSpriteNode *ball = [self addBall];
    //SKSpriteNode *controls = [self addControls];
    //SKSpriteNode *gameOverButtons = [self addGameOverButtons];
    //SKSpriteNode *score = [self addScore];
    
    [background addChild:self.player];
    
    return background;
    
    
    
}
-(CGFloat)getParentSizeX
{
    CGRect parentFrame = self.frame;
    return CGRectGetMaxX(parentFrame);
    
    
    
}
-(CGFloat)getParentSizeY
{
    CGRect parentFrame = self.frame;
    return CGRectGetMaxY(parentFrame);
}

-(SKSpriteNode *)addPlayer
{
    
    
    self.playerFacingRight = YES;
    
     self.characterAnimate = [self determineCharacterFrames];
    
    CGFloat x = [self getParentSizeX];
    CGFloat y = [self getParentSizeY];
    SKSpriteNode *player = [[SKSpriteNode alloc] initWithImageNamed:self.characterAnimate[0]]; //self.characterAnimate[0]]
    NSLog(@"%@",self.characterAnimate[0]);
    player.size = CGSizeMake(1.5*x*0.15,1.5*y*0.27);
    player.position = CGPointMake(x/2, y*.13);
    
    return player;
    
    
}
/*
-(SKSpriteNode *)addLeftBaseman
{
    
}
-(SKSpriteNode *)addRightBaseman
{
    
}
-(SKSpriteNode *)addBall
{
    
}-(SKSpriteNode *)addControls
{
    
}
-(SKSpriteNode *)leftControl
{
    
}
-(SKSpriteNode *)rightControl
{
    
}
-(SKSpriteNode *)score
{
    
}
-(SKSpriteNode *)addGameOverButtons
{
    
}
-(SKSpriteNode *)exitButton
{
    
}
-(SKSpriteNode *)shareButton
{
    
}-(SKSpriteNode *)replayButton
{
    
}
*/
-(NSArray*)determineCharacterFrames
{
    
    NSString *s0 = [NSString stringWithFormat:@"Blank 0-1"];
    NSString *s3 = [NSString stringWithFormat:@"Outfit 4-1"];
    NSString *s6 = [NSString stringWithFormat:@"Girl 2-1"];
    NSString *s9 = [NSString stringWithFormat:@"Hat 3-1"];
    NSString *s12 = [NSString stringWithFormat:@"Pickle 11-1"];
    NSString *s15 = [NSString stringWithFormat:@"Rollerblade 10-1"];
    NSString *s18 = [NSString stringWithFormat:@"Gingerbread 6-1"];
    NSString *s21 = [NSString stringWithFormat:@"Astronaut 7-1"];
    NSString *s24 = [NSString stringWithFormat:@"Vampire 8-1"];
    NSString *s27 = [NSString stringWithFormat:@"Wizard 9-1"];
    
    NSString *s1 = [NSString stringWithFormat:@"Blank 0-2"];
    NSString *s4 = [NSString stringWithFormat:@"Outfit 4-2"];
    NSString *s7 = [NSString stringWithFormat:@"Girl 2-2"];
    NSString *s10 = [NSString stringWithFormat:@"Hat 3-2"];
    NSString *s13 = [NSString stringWithFormat:@"Pickle 11-2"];
    NSString *s16 = [NSString stringWithFormat:@"Rollerblade 10-2"];
    NSString *s19 = [NSString stringWithFormat:@"Gingerbread 6-2"];
    NSString *s22 = [NSString stringWithFormat:@"Astronaut 7-2"];
    NSString *s25 = [NSString stringWithFormat:@"Vampire 8-2"];
    NSString *s28 = [NSString stringWithFormat:@"Wizard 9-2"];
    
    NSString *s2 = [NSString stringWithFormat:@"Blank 0-3"];
    NSString *s5 = [NSString stringWithFormat:@"Outfit 4-3"];
    NSString *s8 = [NSString stringWithFormat:@"Girl 2-3"];
    NSString *s11 = [NSString stringWithFormat:@"Hat 3-3"];
    NSString *s14 = [NSString stringWithFormat:@"Pickle 11-3"];
    NSString *s17 = [NSString stringWithFormat:@"Rollerblade 10-3"];
    NSString *s20 = [NSString stringWithFormat:@"Gingerbread 6-3"];
    NSString *s23 = [NSString stringWithFormat:@"Astronaut 7-3"];
    NSString *s26 = [NSString stringWithFormat:@"Vampire 8-3"];
    NSString *s29 = [NSString stringWithFormat:@"Wizard 9-3"];
    
    NSArray *allCharacters =  @[s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29];
    
    int ci = [RWGameData sharedGameData].characterIndex;
    
    NSArray *selectedCharacterFrames = @[allCharacters[3*ci],allCharacters[3*ci + 1],allCharacters[3*ci + 2]];
    return selectedCharacterFrames;
    
}





@end

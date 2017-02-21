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
#import <math.h>




@implementation GameScene :SKScene

- (void)didMoveToView: (SKView *) view
{
    self.x = [self getParentSizeX];
    self.y = [self getParentSizeY];
    
    self.characterAnimate = [self determineCharacterFrames];
    
    self.shouldThrowBall = NO;
    self.leftHasBall = NO;
    self.rightHasBall = NO;
    
    self.f1 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:0]];
    self.f2 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    self.f3 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:2]];
    self.f4 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    
    self.charFrames = @[self.f1,self.f2,self.f3,self.f4];
    self.playerSpeed = 1;
    
    
    self.runAnimation = [SKAction animateWithTextures:self.charFrames timePerFrame:0.15];
    
    self.repeatAnimation = [SKAction repeatActionForever:self.runAnimation];
   
    
    self.runGroup = [SKAction repeatActionForever:[SKAction group:@[self.repeatAnimation]]];
    
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    [self.player runAction:self.runGroup];
    [self playerRunRight];
    
    
    self.throwBallToLeft = [self tBTL];
    self.throwBallToRight = [self tBTR];
    
    [self.ball runAction:self.throwBallToRight completion:^{
        [self.ball runAction:self.throwBallToLeft];
        //check if ball should be thrown
        
        [self checkthrow];
            }];
    
    
}

- (void)didFinishUpdate  //game logic           //*********UPDATE*******//
{
    
    //check for point
    if(self.player.position.x > self.frame.size.width*0.84)
    {
        self.playerFacingRight = NO;
        self.player.size = CGSizeMake(-1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
        [self playerRunLeft];
        //[self playerRunRight];
    }
    if(self.player.position.x < self.frame.size.width*0.16)
    {
        self.playerFacingRight = YES;
        self.player.size = CGSizeMake(1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
        [self playerRunRight];
        //[self playerRunLeft];
    }
    //decides which direction to run
    if(self.playerFacingRight)
    {
        [self playerRunRight];
    } else{
        [self playerRunLeft];
    }
    
    //check for throw
    if([self checkthrow])
    {
        if(self.leftHasBall)
        {
            self.leftHasBall = NO;
            [self.ball runAction:self.throwBallToRight completion:^{
                self.rightHasBall = YES;
            }];

        } else if (self.rightHasBall){
            self.rightHasBall = NO;
            [self.ball runAction:self.throwBallToLeft completion:^{
                self.leftHasBall = YES;
            }];

        }
    }
        
    
    
}                                                   //*****UPDATE END*******//


-(void)playerRunRight                       //*************MOVE PLAYER************//
{
    
    self.player.position = CGPointMake((self.player.position.x + (1 + logf(self.playerSpeed))),self.y*0.13);
    
}

-(void)playerRunLeft
{
  self.player.position = CGPointMake((self.player.position.x - (1 + logf(self.playerSpeed))),self.y*0.13);
}


-(SKAction *)tBTL                       //****THROW BALL LEFT*****//
{
    //ballx and bally are the current pos of the ball
    CGFloat ballTopy = self.y/3;
    CGFloat ballTopx = self.x/2 - self.ball.position.x;
    CGFloat ballendx = (self.rightBaseman.position.x + self.ball.size.width/3) - self.ball.position.x;
    
    
    // CGFloat pathwidth = self.rightBaseman.position.x - self.leftBaseman.position.x;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddQuadCurveToPoint(path, NULL, -ballTopx, ballTopy, -ballendx, 0);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:5.0];
    
    SKAction *rotate = [SKAction repeatAction:[SKAction rotateByAngle:-2 duration:0.5 ]count:10];
    SKAction *throwGroup = [SKAction group:@[followline,rotate]];
    
    return throwGroup;

}
-(SKAction *)tBTR                       //****THROW BALL LEFT*****//
{
    //ballx and bally are the current pos of the ball
    CGFloat ballTopy = self.y/3;
    CGFloat ballTopx = self.x/2 - self.ball.position.x;
    CGFloat ballendx = (self.rightBaseman.position.x + self.ball.size.width/3) - self.ball.position.x;
    
   // CGFloat pathwidth = self.rightBaseman.position.x - self.leftBaseman.position.x;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddQuadCurveToPoint(path, NULL, ballTopx, ballTopy, ballendx, 0);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:5.0];
    
    SKAction *rotate = [SKAction repeatAction:[SKAction rotateByAngle:2 duration:0.5 ]count:10];
    SKAction *throwGroup = [SKAction group:@[followline,rotate]];
    
    return throwGroup;
}

-(BOOL)checkthrow                           //**********CHECK TRHOW*********//
{
    if(self.rightHasBall && !self.playerFacingRight && self.player.position.x < self.x/2)
    {
        self.shouldThrowBall = YES;
        return YES;
    }
    if(self.leftHasBall && self.playerFacingRight && self.player.position.x > self.x/2)
    {
        self.shouldThrowBall = YES;
        return YES;
    }
    return NO;
    
}

-(void)createSceneContents              //******CREATE SCENE FUNC*************//
{

    [self addChild:[self addBackground]];

}

-(SKSpriteNode *)addBackground          //**********ADD BACKGROUND*************//
{
    
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"AppBackground"];
    background.size = self.scene.size;
    background.anchorPoint = CGPointMake(0, 0);
    background.position = CGPointMake(0, 0);
    
    self.player = [self addPlayer];
    self.leftBaseman = [self addLeftBaseman];
    self.rightBaseman = [self addRightBaseman];
    self.ball = [self addBall];
    //SKSpriteNode *controls = [self addControls];
    //SKSpriteNode *gameOverButtons = [self addGameOverButtons];
    //SKSpriteNode *score = [self addScore];
    
    [background addChild:self.player];
    [background addChild:self.leftBaseman];
    [background addChild:self.rightBaseman];
    [background addChild:self.ball];
    
    return background;
    
    
    
}


-(SKSpriteNode *)addPlayer                   //**************PLAYER**********//
{
    
    
    self.playerFacingRight = YES;
    
     self.characterAnimate = [self determineCharacterFrames];
    
    CGFloat x = [self getParentSizeX];
    CGFloat y = [self getParentSizeY];
    SKSpriteNode *player = [[SKSpriteNode alloc] initWithImageNamed:self.characterAnimate[0]]; //self.characterAnimate[0]]
    NSLog(@"%@",self.characterAnimate[0]);
    player.size = CGSizeMake(1.5*self.x*0.15,1.5*self.y*0.27);
    player.position = CGPointMake(x/2, y*.13);
    
    return player;
    
    
}

-(SKSpriteNode *)addLeftBaseman                 //*********LEFT BASEMAN*******//
{
    SKSpriteNode *baseman = [[SKSpriteNode alloc] initWithImageNamed:@"Baseman"];
    baseman.size = CGSizeMake(self.x*0.1, self.y*0.3);
    baseman.anchorPoint = CGPointMake(1, 0);
    baseman.position = CGPointMake(self.x*0.11, self.y*0.10);
    
    
    return baseman;
    
}

-(SKSpriteNode *)addRightBaseman                //********RIGHT BASEMAN**********//
{
    SKSpriteNode *baseman = [[SKSpriteNode alloc] initWithImageNamed:@"Baseman"];
    baseman.size = CGSizeMake(-(self.x*0.1), self.y*0.3);
    baseman.anchorPoint = CGPointMake(1, 0);
    baseman.position = CGPointMake(self.x*0.89, self.y*0.10);
    
    
    return baseman;
}

-(SKSpriteNode *)addBall                    //******************BALL*****************//
{
    SKSpriteNode *ball = [[SKSpriteNode alloc] initWithImageNamed:@"Baseball"];
    ball.size = CGSizeMake(self.x*0.03, self.x*0.03);
    ball.anchorPoint = CGPointMake(0.5, 0.5);
    CGFloat bally = self.leftBaseman.size.height*0.65 + self.leftBaseman.position.y + ball.size.height/2;
    CGFloat ballx = self.leftBaseman.position.x - ball.size.width/3;
    ball.position = CGPointMake(ballx, bally);
    
    return ball;
}
/*
-(SKSpriteNode *)addControls
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



@end

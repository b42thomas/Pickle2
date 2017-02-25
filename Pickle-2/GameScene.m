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

//physic stuff
static const uint32_t ballCategory     =  0x1 << 0;
static const uint32_t gloveCategory        =  0x1 << 1;






- (void)didMoveToView: (SKView *) view
{
    
    //sizing var
    self.x = [self getParentSizeX];
    self.y = [self getParentSizeY];
    
    //physics stuff
    self.g = -self.y*(0.0);
    self.physicsWorld.gravity = CGVectorMake(0,self.g);
    self.physicsWorld.speed = self.x;
    self.physicsWorld.contactDelegate = self;
    
    
    
    //figure out wich character was selected
    self.characterAnimate = [self determineCharacterFrames];
    
    //set up vars
    self.shouldThrowBall = NO;
    self.leftHasBall = NO;
    self.rightHasBall = NO;
    self.movingRight = YES;
    self.moving = YES;
    
    self.f1 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:0]];
    self.f2 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    self.f3 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:2]];
    self.f4 = [SKTexture textureWithImageNamed:[self.characterAnimate objectAtIndex:1]];
    
    self.charFrames = @[self.f1,self.f2,self.f3,self.f4];
    self.playerSpeed = 1;
    
    //Actions
    self.runAnimation = [SKAction animateWithTextures:self.charFrames timePerFrame:0.15];
    
    self.repeatAnimation = [SKAction repeatActionForever:self.runAnimation];
   
    
    self.runGroup = [SKAction repeatActionForever:[SKAction group:@[self.repeatAnimation]]];
    
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    
    self.gloveDistance = self.rightBaseman.position.x - self.leftBaseman.position.x + 2*self.ball.size.width/3;
   /*  test
    SKSpriteNode *test = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeZero];
    test.color = [SKColor greenColor];
    test.anchorPoint = CGPointMake(0, 0);
    test.position = self.leftBaseman.position;
    test.size = CGSizeMake(self.gloveDistance-self.ball.size.width/3,50);
    [self addChild:test];
    */
    //[self launchBall];
    
    
    //run initial actions - start the game
    self.runRight = [self actionRunRight];
    self.runLeft = [self actionRunLeft];
    [self.player runAction:self.runGroup];
    //[self playerRunRight];
    [self.player runAction:self.runRight withKey:@"changeDirectionL"];

    
    //move ball
    
    
    self.throwBallToLeft = [self tBTL];
    self.throwBallToRight = [self tBTR];
    //self.throwBallToRight = [self.throwBallToLeft reversedAction];
   
    [self.ball runAction:self.throwBallToRight completion:^{
        [self checkthrow];
        self.rightHasBall = YES;
            }];
    
    //[self launchBall];
}                                   //***************TOUCHES BEGAN************.//

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *touchedNode = [self nodeAtPoint:location];
        
        if([touchedNode.name  isEqual: @"leftButton"])
        {
            self.playerFacingRight = NO;
            self.player.size = CGSizeMake(-1.5*self.x*0.15,1.5*self.y*0.27);
            [self.player removeActionForKey:@"ChangeDirectionL"];
            self.runLeft = [self actionRunLeft];
            [self.player runAction:self.runLeft withKey:@"changeDirectionR"];
        }
        if([touchedNode.name  isEqual: @"rightButton"])
        {
            self.playerFacingRight = YES;
            self.player.size = CGSizeMake(1.5*self.x*0.15,1.5*self.y*0.27);
            [self.player removeActionForKey:@"ChangeDirectionR"];
            self.runRight = [self actionRunRight];
            [self.player runAction:self.runRight withKey:@"changeDirectionL"];
        }
        
    }//end for loop
}//end touchBegan

//*********END TOUCHES BEGAN*************//


- (void)didFinishUpdate  //game logic           //*********UPDATE*******//
{
    
   // self.throwBallToLeft = [self tBTL];
   // self.throwBallToRight = [self tBTR];
    
    //check for point
    
    if(self.player.position.x > self.frame.size.width*0.84)
    {
        
        self.playerFacingRight = NO;
        self.player.size = CGSizeMake(-1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
       // [self playerRunLeft];
        [self.player removeActionForKey:@"changeDirectionL"];
        self.runLeft = [self actionRunLeft];
        [self.player runAction:self.runLeft withKey:@"changeDirectionR"];
         
    }
    if(self.player.position.x < self.frame.size.width*0.16)
    {
        
        self.playerFacingRight = YES;
        self.player.size = CGSizeMake(1.5*self.x*0.15,1.5*self.y*0.27);
        self.playerSpeed++;
        //[self playerRunRight];
        [self.player removeActionForKey:@"changeDirectionR"];
        self.runRight = [self actionRunRight];
        [self.player runAction:self.runRight withKey:@"changeDirectionL"];
        
    }
    //decides which direction to run
    if(self.playerFacingRight)
    {
        [self playerRunRight];
    } else{
        [self playerRunLeft];
    }
    
    
    
    
     //check throw
    [self checkthrow];
    
    
}                                                   //*****UPDATE END*******//



-(SKAction *)actionRunRight                       //*************MOVE PLAYER************//
{
    CGFloat dest = self.frame.size.width*0.84;
    CGFloat curr = self.player.position.x;
    CGFloat dist = dest - curr;
    CGFloat speed = self.x*self.player.size.width*(logf(1 + self.playerSpeed));
    CGFloat baseDist = self.frame.size.width*0.84 - self.frame.size.width*0.16;
    CGFloat x = (baseDist/speed)*dist;
    NSLog(@"x %f",x);
    SKAction *runRight = [SKAction moveTo:CGPointMake(dest, self.player.position.y) duration:x];
    return runRight;
    
}
-(SKAction *)actionRunLeft                       //*************MOVE PLAYER************//
{
    CGFloat dest = self.frame.size.width*0.16;
    CGFloat curr = self.player.position.x;
    CGFloat dist = curr - dest;
    CGFloat speed = self.x*-self.player.size.width*(logf(1 + self.playerSpeed));
    CGFloat baseDist = self.frame.size.width*0.84 - self.frame.size.width*0.16;
    CGFloat x = (baseDist/speed)*dist;
    NSLog(@"curr %f",curr);
    NSLog(@"dest %f",dest);
    NSLog(@"dist %f",dist);
    NSLog(@"x %f",x);
    SKAction *runLeft = [SKAction moveTo:CGPointMake(dest, self.player.position.y) duration:x];
    return runLeft;
    
}

-(void)playerRunRight                       //*************MOVE PLAYER************//
{
    
    self.player.position = CGPointMake((self.player.position.x + (1 + logf(self.playerSpeed))),self.y*0.13);
    
}

-(void)playerRunLeft
{
  self.player.position = CGPointMake((self.player.position.x - (1 + logf(self.playerSpeed))),self.y*0.13);
}

-(void)moveBallLeft
{
    CGFloat bally = self.leftBaseman.size.height*0.65 + self.leftBaseman.position.y + self.ball.size.height/2;
    CGFloat ballx = self.leftBaseman.position.x - self.ball.size.width/3;
    //NSLog(@"bally %f",bally);
    
    //CGFloat ymove = self.ball.position.y + 1*sin(self.ball.position.x*M_PI/(self.gloveDistance)+ballx);
    //NSLog(@"bally %f",self.gloveDistance);
    CGFloat ymove = pow((self.ball.position.x-self.x/2)/(self.x/(ballx/2)),2)*-1 + 2*bally +self.ball.size.height ;
    NSLog(@"ymove %f",ymove);
    
    
    self.ball.position = CGPointMake(self.ball.position.x - 2*(1 + logf(self.playerSpeed)),ymove);
    

    if(self.ball.position.x < self.leftBaseman.position.x){
        self.leftHasBall = YES;
        self.moving = NO;
    }
}
-(void)moveBallRight
{
   CGFloat bally = self.leftBaseman.size.height*0.65 + self.leftBaseman.position.y + self.ball.size.height/2;
    CGFloat ballx1 = self.leftBaseman.position.x - self.ball.size.width/3;
    CGFloat ballx2 = self.rightBaseman.position.x + self.ball.size.width/3;
    //NSLog(@"bally %f",bally);
    CGFloat x = self.ball.position.x - ballx1;
    
    CGFloat ymove = self.ball.position.y + -(1*sin((self.ball.position.x*2*M_PI/self.gloveDistance) - ballx1)) ;
       //CGFloat ymove = self.ball.position.y ;
    NSLog(@"ball pos x  %f",self.ball.position.x);
    NSLog(@"ball pos y  %f",self.ball.position.y);
   // CGFloat ymove =
    
    
    self.ball.position = CGPointMake(self.ball.position.x + 2*(1 + logf(self.playerSpeed)),ymove);
    
    if(self.ball.position.x > self.rightBaseman.position.x+ self.ball.size.width/3){
        self.rightHasBall = YES;
        self.moving = NO;
    }
}

-(void)launchBall
{
    CGFloat d = self.rightBaseman.position.x - self.leftBaseman.position.x + self.ball.size.width;
    CGFloat v = sqrtf((d*-(self.g))/2);
    CGVector vector = CGVectorMake(v*10, 0);
    self.ball.physicsBody.velocity = vector;
    //[self.ball.physicsBody applyImpulse:vector];
    
    NSLog(@"launched ball %f", self.g);
}

-(SKAction *)tBTL                       //****THROW BALL LEFT*****//
{
    
    CGSize ballSize = CGSizeMake(self.x*0.03, self.x*0.03);
    CGFloat ballTopy = self.y/3;
    CGFloat balldistx = (self.leftBaseman.position.x);
    //int dur = 20*(1 + logf(self.playerSpeed)); //replace with global variable
    int speed = 1.5*self.player.size.width*(1 + logf(self.playerSpeed));
    CGFloat bally = self.rightBaseman.size.height*0.65 + self.rightBaseman.position.y + self.ball.size.height/2;
    CGFloat ballx = self.rightBaseman.position.x - self.ball.size.width/3;
    /*
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, ballx, bally);
    CGPathAddQuadCurveToPoint(path, NULL, self.x/2, bally + 4*ballSize.height, balldistx, bally);
    SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:NO speed:speed];
    */
    CGFloat dur = 2;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddQuadCurveToPoint(path, NULL, -self.gloveDistance/2, self.y-self.leftBaseman.size.height, -self.gloveDistance, 0);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:dur];
    
    //CGFloat dist = self.rightBaseman.position.x - ballx;

    //CGFloat dur = (ballx - balldistx)/speed;
    
    int spins  = rand() % 8 + 4;
    float rads = 2*M_PI*spins;
    SKAction *rotate = [SKAction repeatAction:[SKAction rotateByAngle:rads duration:dur ]count:1];

     //SKAction *throwGroup = [SKAction group:@[followline]];
    SKAction *throwGroup = [SKAction group:@[followline,rotate]];
    
    CGPathRelease(path);
    
    return throwGroup;

}
-(SKAction *)tBTR                       //****THROW BALL RIGHT*****//
{
    
   
    CGFloat dur = 1;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddQuadCurveToPoint(path, NULL, self.gloveDistance/2, self.y-self.leftBaseman.size.height, self.gloveDistance, 0);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:dur];
    int spins  = rand() % 8 + 4;
    float rads = 2*M_PI*spins;
    SKAction *rotate = [SKAction repeatAction:[SKAction rotateByAngle:rads duration:dur ]count:1];
    SKAction *throwGroup = [SKAction group:@[followline,rotate]];
    
    CGPathRelease(path);
    
    return throwGroup;
}

-(void)checkthrow                           //**********CHECK THROW*********//
{
     //check for throw
    
    /*
     if(self.leftHasBall)
     {
         self.movingRight = YES;
         self.leftHasBall = NO;
         [self moveBallRight];
         self.moving = YES;
        // NSLog(@"1");
        
     } else if (self.rightHasBall)
     {
         self.movingRight = NO;
         self.rightHasBall = NO;
         [self moveBallLeft];
         self.moving = YES;
        // NSLog(@"2");

     } else if (self.movingRight && self.moving)
     {
        // NSLog(@"3");
         [self moveBallRight];
     } else if (!self.movingRight && self.moving){
         [self moveBallLeft];
        // NSLog(@"4");
     }
    */
    
    //check for throw
    if(self.leftHasBall)
    {
        self.leftHasBall = NO;
        [self.ball runAction:self.throwBallToRight completion:^{
            self.rightHasBall = YES;
            self.ball.zRotation = 0;
        }];
        
    } else if (self.rightHasBall)
    {
        self.rightHasBall = NO;
        [self.ball runAction:self.throwBallToLeft completion:^{
            self.leftHasBall = YES;
            self.ball.zRotation = 0;
        }];
        
    }
    
    
}

-(void)projectile:(SKSpriteNode *)ball didCollideWithGlove:(SKSpriteNode *)glove {
    NSLog(@"Hit %f", self.ball.position.x);
    //[ball removeFromParent];
    //[glove removeFromParent];
    //self.ball.physicsBody.dynamic = NO;
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & ballCategory) != 0 &&
        (secondBody.categoryBitMask & gloveCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithGlove:(SKSpriteNode *) secondBody.node];
    }
}


-(void)createSceneContents              //******CREATE SCENE FUNC*************//
{
    self.background = [self addBackground];
    [self addChild:self.background];
    
    [self addChild:[self leftControl]];
    [self addChild:[self rightControl]];

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
    SKTexture *bmText = [SKTexture textureWithImageNamed:@"Baseman"];
    SKSpriteNode *baseman = [[SKSpriteNode alloc] initWithTexture:bmText];
    baseman.size = CGSizeMake(self.x*0.1, self.y*0.3);
    baseman.anchorPoint = CGPointMake(1, 0);
    baseman.position = CGPointMake(self.x*0.11, self.y*0.10);
    //baseman.physicsBody = [SKPhysicsBody bodyWithTexture:bmText size:CGSizeMake(bmText.size.height, bmText.size.width)];
    
    //baseman.physicsBody.dynamic = NO; // 2
    //baseman.physicsBody.categoryBitMask = gloveCategory; // 3
    //baseman.physicsBody.contactTestBitMask = ballCategory; // 4
    //baseman.physicsBody.collisionBitMask = 0; // 5
    
    //self.leftArm = [self addArm];
    //[baseman addChild:self.leftArm];
    
    // self.leftArm.position = CGPointMake(-baseman.size.width/2,baseman.size.height/2);
    
    
    
    return baseman;
    
}

-(SKSpriteNode *)addRightBaseman                //********RIGHT BASEMAN**********//
{
    SKTexture *bmText = [SKTexture textureWithImageNamed:@"Baseman"];
    SKSpriteNode *baseman = [[SKSpriteNode alloc] initWithTexture:bmText];
    baseman.size = CGSizeMake(-(self.x*0.1), self.y*0.3);
    baseman.anchorPoint = CGPointMake(1, 0);
    baseman.position = CGPointMake(self.x*0.89, self.y*0.10);
    CGSizeMake((self.x*0.1), self.y*0.3);
    baseman.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:baseman.size];
    
    baseman.physicsBody.dynamic = YES; // 2
    baseman.physicsBody.categoryBitMask = gloveCategory; // 3
    baseman.physicsBody.contactTestBitMask = ballCategory; // 4
    baseman.physicsBody.collisionBitMask = 0; // 5
    
    
    
    return baseman;
}
-(SKSpriteNode *)addArm
{
    SKSpriteNode *arm = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake((self.x*0.1)/2, self.y*0.03)];
    arm.anchorPoint = CGPointMake(0, 0.5);
    
    return arm;
    
}

-(SKSpriteNode *)addBall                    //******************BALL*****************//
{
    SKTexture *bmText = [SKTexture textureWithImageNamed:@"Baseball"];
    SKSpriteNode *ball = [[SKSpriteNode alloc] initWithTexture:bmText];
    ball.size = CGSizeMake(self.x*0.03, self.x*0.03);
    ball.anchorPoint = CGPointMake(0.5, 0.5);
    CGFloat bally = self.leftBaseman.size.height*0.65 + self.leftBaseman.position.y + ball.size.height/2;
    CGFloat ballx = self.leftBaseman.position.x - ball.size.width/3;
    ball.position = CGPointMake(ballx, bally);
    
    //ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/3];

    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/3];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = gloveCategory;
    ball.physicsBody.collisionBitMask = 0;
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    return ball;
}

-(void)addControls
{
    [self addChild: [self leftControl]];
    [self addChild: [self rightControl]];
}
-(SKSpriteNode *)leftControl
{
    SKSpriteNode * leftButton = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(self.x/2, self.y)];
    leftButton.anchorPoint = CGPointMake(0, 0);
    leftButton.position = CGPointMake(0, 0);
    leftButton.name = @"leftButton";
    return leftButton;
}
-(SKSpriteNode *)rightControl
{
    SKSpriteNode * rightButton = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(self.x/2, self.y)];
    rightButton.anchorPoint = CGPointMake(0, 0);
    rightButton.position = CGPointMake(self.x/2, 0);
    rightButton.name = @"rightButton";
    return rightButton;
}
/*
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



/*  OLD CODE GRAVEYARD
 
 -(SKAction *)tBTL                       ****THROW BALL LEFT****
{
    
    CGSize ballSize = CGSizeMake(self.x*0.03, self.x*0.03);
    CGFloat ballTopy = self.y/3;
    CGFloat balldistx = (self.leftBaseman.position.x);
    //int dur = 20*(1 + logf(self.playerSpeed)); //replace with global variable
    int speed = 1.5*self.player.size.width*(1 + logf(self.playerSpeed));
    CGFloat bally = self.rightBaseman.size.height*0.65 + self.rightBaseman.position.y + self.ball.size.height/2;
    CGFloat ballx = self.rightBaseman.position.x - self.ball.size.width/3;
 
     CGMutablePathRef path = CGPathCreateMutable();
     CGPathMoveToPoint(path, NULL, ballx, bally);
     CGPathAddQuadCurveToPoint(path, NULL, self.x/2, bally + 4*ballSize.height, balldistx, bally);
     SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:NO speed:speed];
 
    CGFloat dur = 1;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddQuadCurveToPoint(path, NULL, -self.gloveDistance/2, self.y-self.leftBaseman.size.height, -self.gloveDistance, 0);
    SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:dur];
    
    //CGFloat dist = self.rightBaseman.position.x - ballx;
    
    //CGFloat dur = (ballx - balldistx)/speed;
    
    int spins  = rand() % 8 + 4;
    float rads = 2*M_PI*spins;
    SKAction *rotate = [SKAction repeatAction:[SKAction rotateByAngle:rads duration:dur ]count:1];
    
    //SKAction *throwGroup = [SKAction group:@[followline]];
    SKAction *throwGroup = [SKAction group:@[followline,rotate]];
    
    CGPathRelease(path);
    
    return throwGroup;
    
}

 
 -(CGFloat *)ax:(CGFloat)ax ay:(CGFloat)ay bx:(CGFloat)bx by:(CGFloat)by cx:(CGFloat)cx cy:(CGFloat)cy
 {
 
 CGFloat d = *[self determinant:ax d2:bx d3:cx];
 CGFloat da = *[self determinant:ay d2:bx d3:cx];
 CGFloat db = *[self determinant:ax d2:by d3:cx];
 CGFloat dc = *[self determinant:ax d2:bx d3:cy];
 
 CGFloat a = da/d;
 CGFloat b = db/d;
 CGFloat c = dc/d;
 
 CGFloat y = a*self.ball.position.x*self.position.x + b*self.ball.position.x + c;
 
 return &y;
 }
 -(CGFloat *)determinant:(CGFloat) ax d2:(CGFloat) bx d3:(CGFloat) cx
 {
 
 CGFloat d;
 CGFloat d1, d2, d3, d4, d5, d6;
 d1 = ax*ax*bx*1;
 d2 = cx*cx*ax*1;
 d3 = bx*bx*cx*1;
 d4 = cx*cx*bx*1;
 d5 = ax*ax*cx*1;
 d6 = bx*bx*ax*1;
 d = d1+d2+d3-d4-d5-d6;
 
 return &d;
 }
 
 
 
 */

//
//  MainMenuScene.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/17/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

//code to create main menu goes here

#import "MainMenuScene.h"


@interface MainMenuScene ()
@property BOOL contentCreated;
@end

@implementation MainMenuScene



- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
   // self.scaleMode = SKSceneScaleModeResizeFill;
    [self addChild: [self newMainMenu]];  //adds main menu to scene
}

-(SKSpriteNode *)newMainMenu  //method to create mainMenu Background image squraes should be filled in image
{
   SKSpriteNode *mainMenu = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenu"];
    mainMenu.position = CGPointMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame));
    mainMenu.size = self.size;
    mainMenu.anchorPoint = CGPointMake(0,0);
    SKSpriteNode *playButton = [self addPlayButton];  //create playbutton sprite
    SKLabelNode *highScore = [self addHighScore];  //create highscore sprite
    SKLabelNode *lastScore = [self addLastScore];  //create lastscore sprite
    SKSpriteNode *gear = [self addGear];//create settings sprite
 
    [mainMenu addChild:playButton];
    [mainMenu addChild:highScore];
    [mainMenu addChild:lastScore];
    [mainMenu addChild:gear];
    
    //place child nodes
    CGRect parentFrame = playButton.parent.frame;
    CGFloat x = CGRectGetMaxX(parentFrame);
    CGFloat y = CGRectGetMaxY(parentFrame);
    //position for Play button
    CGPoint pbpos = CGPointMake( x*0.455, y*0.315);
    playButton.position = pbpos;
    //position for HighScore
    CGPoint hspos = CGPointMake( x*0.25, y*0.5);
    highScore.position = hspos;
    //Position for Lastscore
    CGPoint lspos = CGPointMake( x*0.75, y*0.5);
    lastScore.position = lspos;
    //position for sound settings button
    CGPoint gpos = CGPointMake( x*0.22, y*0.22);
    gear.position = gpos;
    
    //this line is KEY for creating displays that look the same on all iPhones!!!!!!!!
    playButton.size = CGSizeMake(parentFrame.size.width*0.10,parentFrame.size.height*0.175);
    
    gear.size = CGSizeMake(parentFrame.size.width*0.05,parentFrame.size.height*0.09);
    
    
    
    return mainMenu;
}

- (SKSpriteNode *)addPlayButton  //play button, needs a new image with white background
{
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];

    playButton.anchorPoint = CGPointMake(0,0);
       return playButton;
}


- (SKLabelNode *)addHighScore
{
    SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.color = [SKColor whiteColor];
    highScore.text = @"99";
    highScore.fontSize = 76;
       return highScore;
}


- (SKLabelNode *)addLastScore
{
    SKLabelNode *lastScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lastScore.color = [SKColor whiteColor];
    lastScore.text = @"00";
    lastScore.fontSize = 76;
    lastScore.position = CGPointMake(CGRectGetMidX(lastScore.parent.frame) + 160,CGRectGetMidY(lastScore.parent.frame)-15);
    return lastScore;
}

-(SKSpriteNode *)addGear
{
    SKSpriteNode *gear = [SKSpriteNode spriteNodeWithImageNamed:@"Gear"];
    
    gear.anchorPoint = CGPointMake(0,0);
    return gear;
}



@end

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
    self.scaleMode = SKSceneScaleModeAspectFit;
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
 
    [mainMenu addChild:playButton];
    [mainMenu addChild:highScore];
    [mainMenu addChild:lastScore];
    
    //place child nodes
    CGRect parentFrame = playButton.parent.frame;
    CGFloat x = CGRectGetMaxX(parentFrame);
    CGFloat y = CGRectGetMaxY(parentFrame);
    CGPoint pbpos = CGPointMake( x*0.455, y*0.315);
    playButton.position = pbpos;
    
    CGPoint hspos = CGPointMake( x*0.25, y*0.5);
    highScore.position = hspos;
    
    CGPoint lspos = CGPointMake( x*0.75, y*0.5);
    lastScore.position = lspos;
    
    
    
    
    return mainMenu;
}

- (SKSpriteNode *)addPlayButton  //play button, needs a new image with white background
{
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];

    playButton.anchorPoint = CGPointMake(0,0);
    playButton.xScale = 1;
    playButton.yScale = 1;
    return playButton;
}


- (SKLabelNode *)addHighScore
{
    SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.color = [SKColor whiteColor];
    highScore.text = @"99";
    highScore.fontSize = 80;
       return highScore;
}


- (SKLabelNode *)addLastScore
{
    SKLabelNode *lastScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lastScore.color = [SKColor whiteColor];
    lastScore.text = @"00";
    lastScore.fontSize = 80;
    lastScore.position = CGPointMake(CGRectGetMidX(lastScore.parent.frame) + 160,CGRectGetMidY(lastScore.parent.frame)-15);
    return lastScore;
}



@end

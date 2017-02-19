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
    SKSpriteNode *soundSettings = [self addsoundSettings];//create settings sprite
    SKSpriteNode *characterSelectButton = [self addCharacterSelectButton];//create Character Select Sprite
 
    [mainMenu addChild:playButton];
    [mainMenu addChild:highScore];
    [mainMenu addChild:lastScore];
    [mainMenu addChild:gear];
    //[mainMenu addChild:soundSettings];
    [mainMenu addChild:characterSelectButton];
    
    
    
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
    CGPoint gpos = CGPointMake( x*0.23, y*0.22);
    gear.position = gpos;
    //position for soundSettings
    CGPoint sspos = CGPointMake( x*0.25, y*0.25);
    soundSettings.position = sspos;
    //position for character Select button
    CGPoint csbpos = CGPointMake( x*0.73, y*0.22);
    characterSelectButton.position = csbpos;
    
    
    //this line is KEY for creating displays that look the same on all iPhones!!!!!!!!
    playButton.size = CGSizeMake(parentFrame.size.width*0.10,parentFrame.size.height*0.175);
    //gear size
    gear.size = CGSizeMake(parentFrame.size.width*0.05,parentFrame.size.height*0.09);
    //sound settings menu size
    soundSettings.size = CGSizeMake(parentFrame.size.width*0.45,parentFrame.size.height*0.45);
    //character select button size
    characterSelectButton.size = CGSizeMake(parentFrame.size.width*0.05,parentFrame.size.height*0.09);
    
    
    return mainMenu;
}

- (SKSpriteNode *)addPlayButton  //play button, needs a new image with white background
{
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];
    [playButton setName:@"playButton"];

    playButton.anchorPoint = CGPointMake(0,0);
       return playButton;
}


- (SKLabelNode *)addHighScore
{
    SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.color = [SKColor whiteColor];
    highScore.text = @"99";
    highScore.fontSize = 76;
    [highScore setName:@"highScore"];
       return highScore;
}


- (SKLabelNode *)addLastScore
{
    SKLabelNode *lastScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lastScore.color = [SKColor whiteColor];
    lastScore.text = @"00";
    lastScore.fontSize = 76;
    lastScore.position = CGPointMake(CGRectGetMidX(lastScore.parent.frame) + 160,CGRectGetMidY(lastScore.parent.frame)-15);
    [lastScore setName:@"lastScore"];
    return lastScore;
}

-(SKSpriteNode *)addGear
{
    SKSpriteNode *gear = [SKSpriteNode spriteNodeWithImageNamed:@"Gear"];
     [gear setName:@"gear"];
    
    gear.anchorPoint = CGPointMake(0,0);
    return gear;
}

-(SKSpriteNode*)addsoundSettings
{
    SKSpriteNode *soundSettings = [SKSpriteNode spriteNodeWithImageNamed:@"SoundOptionsMenu"];
    [soundSettings setName:@"soundSettings"];
    soundSettings.anchorPoint = CGPointMake(0,0);
    soundSettings.size = CGSizeMake(self.frame.size.width*0.45,self.frame.size.height*0.45);
    SKSpriteNode *musicToggle = [self addBox];
    SKSpriteNode *soundToggle = [self addBox];
    [musicToggle setName:@"musicToggle"];
    [soundToggle setName:@"soundToggle"];
    [soundSettings addChild:musicToggle];
    [soundSettings addChild:soundToggle];

    CGRect parentFrame = soundSettings.frame;
    CGFloat x = CGRectGetMaxX(parentFrame);
    CGFloat y = CGRectGetMaxY(parentFrame);
    soundToggle.position = CGPointMake(x*0.75, y*0.35);
    soundToggle.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);
    
    musicToggle.position = CGPointMake(x*0.75, y*0.7);
    musicToggle.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);

    
    return soundSettings;
    
    
    
}
-(SKSpriteNode *) addBox
{
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithImageNamed:@"UncheckedBox"];
    return box;
}

-(SKSpriteNode *)addCharacterSelectButton
{
    SKSpriteNode *characterSelectButton = [SKSpriteNode spriteNodeWithImageNamed:@"CharacterSelect"];
    [characterSelectButton setName:@"characterSelect"];
    
    characterSelectButton.anchorPoint = CGPointMake(0,0);
    return characterSelectButton;
}


@end

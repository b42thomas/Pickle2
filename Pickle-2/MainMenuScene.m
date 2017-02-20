//
//  MainMenuScene.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/17/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

//code to create main menu goes here

#import "MainMenuScene.h"
#import "RWGameData.h"

@interface MainMenuScene ()
@property BOOL contentCreated;

@property BOOL soundSettingsMenuVisible;
@property BOOL characterMenuVisible;

@property BOOL musicOn;
@property BOOL soundOn;


@property  NSArray *characterSelection; //= [NSArray array];
@property  SKTextureAtlas *characterAtlas;// = [SKTextureAtlas atlasNamed:@"CharacterAtlas"];

@end

@implementation MainMenuScene



- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    if(!self.musicOn)
    {
        self.musicOn = YES;
    }
    if(!self.soundOn)
    {
        self.soundOn = YES;
    }
    
    //*****THIS IS HOW WE ADD CHARACTERS TO A SCENE********
    self.characterAtlas = [SKTextureAtlas atlasNamed:@"MMChars"];

    SKTexture *c0 = [self.characterAtlas textureNamed:@"0BlankCharacter-1"];
    SKTexture *c1 = [self.characterAtlas textureNamed:@"1PickleCharacter-1"];
    
    self.characterSelection = @[c0,c1];
    int ci = [RWGameData sharedGameData].characterIndex;
    SKSpriteNode *test = [SKSpriteNode spriteNodeWithTexture:self.characterSelection[ci]];
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
   // self.scaleMode = SKSceneScaleModeResizeFill;
    [self addChild: [self newMainMenu]];  //adds main menu to scene
}
                                                        //*********START TOUCHES BEGAN*************//
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *touchedNode = [self nodeAtPoint:location];
        
        //when buttons get pressed call a method and put all the work there
        //**********PLAY BUTTON***********
        if (touchedNode && [touchedNode.name isEqual:@"playButton"]) {
            // move to game scene
        }
        
        //***********SOUND SETTINGS******************
        if (touchedNode && [touchedNode.name isEqual:@"gear"]&& !self.characterMenuVisible) {
            // show
            [self addsoundSettings];
            self.soundSettingsMenuVisible = YES;
        }
        if (touchedNode && [touchedNode.name isEqual:@"exitButtonSSM"]) {
            // show
            [touchedNode.parent removeFromParent];
            self.soundSettingsMenuVisible = NO;
        }
        if (touchedNode && [touchedNode.name isEqual:@"musicToggle"]) {
            // show
           if(self.musicOn==YES){
            touchedNode.texture = [SKTexture textureWithImageNamed:@"UncheckedBox"];
            self.musicOn = NO;
           } else{
               touchedNode.texture = [SKTexture textureWithImageNamed:@"CheckedBox"];
               self.musicOn = YES;
           }
        }
        if (touchedNode && [touchedNode.name isEqual:@"soundToggle"]) {
            // show
            if(self.soundOn==YES){
                touchedNode.texture = [SKTexture textureWithImageNamed:@"UncheckedBox"];
                self.soundOn = NO;
            } else{
                touchedNode.texture = [SKTexture textureWithImageNamed:@"CheckedBox"];
                self.soundOn = YES;
            }
        }

        //**********CHARACTER SELECT********************
        if (touchedNode && [touchedNode.name isEqual:@"characterSelect"]&& !self.soundSettingsMenuVisible) {
            // show
            [self addCharacterMenu];
            self.characterMenuVisible = YES;
        }
        if (touchedNode && [touchedNode.name isEqual:@"exitButtonCM"]) {
            // show
            [touchedNode.parent removeFromParent];
            self.characterMenuVisible = NO;
        }
       if (touchedNode && [touchedNode.name isEqual:@"rightButton"]) {
                //NSLog(@"rightButton touched");
            [self nextCharacter];
           
     
     
            }//end touch if
        if (touchedNode && [touchedNode.name isEqual:@"leftButton"]) {
            //NSLog(@"leftButton touched");
           [self previousCharacter];
            
            
        }//end touch if

        }//end for loop
}//end touchBegan

                                                            //*********END TOUCHES BEGAN*************//

//right button is pressed
-(void)nextCharacter
{
    
    if(self.characterSelection[[RWGameData sharedGameData].characterIndex] != [self.characterSelection lastObject])
    {
        [RWGameData sharedGameData].characterIndex++;
        [self childNodeWithName:@"characterMenu"].removeFromParent;
        [self addCharacterMenu];
        NSLog(@"should change char");
    }
    
    
}
//left button is pressed
-(void)previousCharacter
{
    
    if(self.characterSelection[[RWGameData sharedGameData].characterIndex] != [self.characterSelection firstObject])
    {
        [RWGameData sharedGameData].characterIndex--;
        [self childNodeWithName:@"characterMenu"].removeFromParent;
        [self addCharacterMenu];
        NSLog(@"should change char");
    }
    
    
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
    SKSpriteNode *characterSelectButton = [self addCharacterSelectButton];//create Character Select Sprite
    
 
    [mainMenu addChild:playButton];
    [mainMenu addChild:highScore];
    [mainMenu addChild:lastScore];
    [mainMenu addChild:gear];
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
    //position for soundSettings and Character menu
    CGPoint sspos = CGPointMake( x*0.25, y*0.25);
    //position for character Select button
    CGPoint csbpos = CGPointMake( x*0.73, y*0.22);
    characterSelectButton.position = csbpos;
    
    
    
    //this line is KEY for creating displays that look the same on all iPhones!!!!!!!!
    playButton.size = CGSizeMake(parentFrame.size.width*0.10,parentFrame.size.height*0.175);
    //gear size
    gear.size = CGSizeMake(parentFrame.size.width*0.05,parentFrame.size.height*0.09);
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
    highScore.text = [NSString stringWithFormat:@"%ld",[RWGameData sharedGameData].highScore];
    highScore.fontSize = 76;
    [highScore setName:@"highScore"];
       return highScore;
}


- (SKLabelNode *)addLastScore
{
    SKLabelNode *lastScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lastScore.color = [SKColor whiteColor];
    lastScore.text = [NSString stringWithFormat:@"%ld",[RWGameData sharedGameData].score];
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

-(void)addsoundSettings
{
    
    CGRect parentFrame = self.frame;
    CGFloat x = CGRectGetMaxX(parentFrame);
    CGFloat y = CGRectGetMaxY(parentFrame);
    CGPoint sspos = CGPointMake( x*0.25, y*0.25);
    
    SKSpriteNode *soundSettings = [SKSpriteNode spriteNodeWithImageNamed:@"SoundOptionsMenu"];
    [soundSettings setName:@"soundSettings"];
    soundSettings.anchorPoint = CGPointMake(0,0);
    soundSettings.size = CGSizeMake(self.frame.size.width*0.45,self.frame.size.height*0.45);
    soundSettings.position = sspos;
    
    SKSpriteNode *musicToggle = [self addBox];
    SKSpriteNode *soundToggle = [self addBox];
    SKSpriteNode *exitButton = [SKSpriteNode spriteNodeWithImageNamed:@"ExitButton"];
    
    [musicToggle setName:@"musicToggle"];
    [soundToggle setName:@"soundToggle"];
    [exitButton setName:@"exitButtonSSM"];
    
    [soundSettings addChild:musicToggle];
    [soundSettings addChild:soundToggle];
    [soundSettings addChild:exitButton];

    parentFrame = soundSettings.frame;
    x = parentFrame.size.width;
    y = parentFrame.size.height;
   
    //sound toggle box pos and size
    soundToggle.position = CGPointMake(x*0.75, y*0.35);
    soundToggle.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);
    //msuci toggle box pos and sie
    musicToggle.position = CGPointMake(x*0.75, y*0.7);
    musicToggle.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);
    //exit button pos and size
    exitButton.anchorPoint = CGPointMake(1, 1);
    exitButton.position = CGPointMake(x*0, y);
    exitButton.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);
    
    

    [self addChild:soundSettings];
   // return soundSettings;
    
    
    
}

-(void)removeSoundsSettings
{
    
    
}


-(SKSpriteNode *) addBox
{
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithImageNamed:@"CheckedBox"];
    return box;
}

-(SKSpriteNode *)addCharacterSelectButton
{
    SKSpriteNode *characterSelectButton = [SKSpriteNode spriteNodeWithImageNamed:@"CharacterSelect"];
    [characterSelectButton setName:@"characterSelect"];
    
    characterSelectButton.anchorPoint = CGPointMake(0,0);
    return characterSelectButton;
}

-(NSArray *)getTextureArray
{
    //Creat atlas for character selection
    self.characterAtlas = [SKTextureAtlas atlasNamed:@"MMChars"];
    //manually add new characters here..
    SKTexture *c0 = [self.characterAtlas textureNamed:@"0BlankCharacter-1"];
    SKTexture *c1 = [self.characterAtlas textureNamed:@"1PickleCharacter-1"];
    //..and then here
    self.characterSelection = @[c0,c1];

    return self.characterSelection;
    
}

-(int)getCharIndex
{
    int ci = [RWGameData sharedGameData].characterIndex;
    return ci;
}

-(void)addCharacterMenu
{
    
    NSArray *charSelect = [self getTextureArray];
    
    
    CGRect parentFrame = self.frame;
    CGFloat x = CGRectGetMaxX(parentFrame);
    CGFloat y = CGRectGetMaxY(parentFrame);
    CGPoint sspos = CGPointMake( x*0.25, y*0.25);
    
    
    SKSpriteNode *characterMenu = [SKSpriteNode spriteNodeWithImageNamed:@"characterMenu"];
    [characterMenu setName:@"characterMenu"];
    characterMenu.anchorPoint = CGPointMake(0,0);
    characterMenu.size = CGSizeMake(self.frame.size.width*0.45,self.frame.size.height*0.45);
    characterMenu.position = sspos;
    
    parentFrame = characterMenu.frame;
    x = parentFrame.size.width;
    y = parentFrame.size.height;
    
    //center image, charater selected
    //int ci = [RWGameData sharedGameData].characterIndex;
    SKSpriteNode *characterSelected = [SKSpriteNode spriteNodeWithTexture:[charSelect objectAtIndex:[self getCharIndex]]];
    //NSLog(@"Value of characterArray[1] is %@", self.characterArray.firstObject);
    [characterSelected setName:@"name"];
    characterSelected.anchorPoint = CGPointMake(0.5, 0.5);
    characterSelected.size = CGSizeMake(parentFrame.size.width*0.35,parentFrame.size.height*0.65);
    characterSelected.position = CGPointMake(x/2, y/2);
    SKSpriteNode *characterChild = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(0, 0)];
    [characterChild setName:@"characterChild"];
    
    //left and right buttons, using playbutton images
    SKSpriteNode *exitButton = [SKSpriteNode spriteNodeWithImageNamed:@"ExitButton"];
    SKSpriteNode *leftButton = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(characterMenu.frame.size.width*0.3, characterMenu.frame.size.height)];
    SKSpriteNode *rightButton = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(characterMenu.frame.size.width*0.3, characterMenu.frame.size.height)];
    SKSpriteNode *leftButtonImage = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];
    SKSpriteNode *rightButtonImage = [SKSpriteNode spriteNodeWithImageNamed:@"PlayButton"];
    
    [exitButton setName:@"exitButtonCM"];
    [leftButton setName:@"leftButton"];
    [rightButton setName:@"rightButton"];
    [leftButtonImage setName:@"leftButtonImage"];
    [rightButtonImage setName:@"rightButtonImage"];
    
    
    //ADD CHILD
    [characterMenu addChild:exitButton];
    
    [characterMenu addChild:leftButtonImage];
    [leftButtonImage addChild:leftButton];
    
    [characterMenu addChild:rightButtonImage];
    [rightButtonImage addChild:rightButton];
    [characterMenu addChild:characterSelected];
    
    [characterSelected addChild:characterChild];
    
    
    
    //exit button pos and size
    exitButton.anchorPoint = CGPointMake(1, 1);
    exitButton.position = CGPointMake(x*0, y);
    exitButton.size = CGSizeMake(parentFrame.size.width*0.15,parentFrame.size.height*0.23);
    //left button area pos and size
    leftButton.anchorPoint = CGPointMake(0.5, 0.5);
    leftButton.position = CGPointMake(x*0, y*0);
    leftButtonImage.size = CGSizeMake(-(parentFrame.size.width*0.15),parentFrame.size.height*0.23);
    //right button pos and size
    rightButton.anchorPoint = CGPointMake(0.5, 0.5);
    rightButtonImage.size = CGSizeMake((parentFrame.size.width*0.15),parentFrame.size.height*0.23);
    rightButton.position = CGPointMake(0,0);
    
    //parentFrame = leftButton.frame;
   // x = CGRectGetMaxX(parentFrame);
   // y = CGRectGetMaxY(parentFrame);
    //left button image pos
    leftButtonImage.anchorPoint = CGPointMake(0.5, 0.5);
    leftButtonImage.position = CGPointMake(x*0.15, y/2);
    
  //  parentFrame = rightButton.frame;
   // x = CGRectGetMaxX(parentFrame);
   // y = CGRectGetMaxY(parentFrame);
    //left button image pos
    rightButtonImage.anchorPoint = CGPointMake(0.5, 0.5);
    rightButtonImage.position = CGPointMake(x*0.85, y/2);


    
    [self addChild:characterMenu];
    //return characterMenu;
    
    
    
}




@end

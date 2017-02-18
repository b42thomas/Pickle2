//
//  MainMenuScene.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/17/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

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
    [self addChild: [self newMainMenu]];
}

-(SKSpriteNode *)newMainMenu
{
   SKSpriteNode *mainMenu = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenu"];
    mainMenu.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    //mainMenu.scale
    return mainMenu;
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello, World!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    return helloNode;
}

@end

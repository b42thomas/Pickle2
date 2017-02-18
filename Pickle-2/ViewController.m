//
//  ViewController.m
//  Pickle-2
//
//  Created by Billy Thomas on 2/17/17.
//  Copyright © 2017 BIZNIT. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "MainMenuScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    MainMenuScene* mainMenu = [[MainMenuScene alloc] initWithSize:self.view.bounds.size];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: mainMenu];
}

@end

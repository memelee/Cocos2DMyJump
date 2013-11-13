//
//  MenuLayer.m
//  Jump
//
//  Created by Meme on 13-8-26.
//  Copyright 2013年 Meme. All rights reserved.
//

#import "MenuLayer.h"
#import "PlayLayer.h"

@interface MenuLayer () {
    CCLayer *_playerLayer;
}

@end

@implementation MenuLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	MenuLayer *layer = [MenuLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	if( (self=[super init])) {
	}
	return self;
}

- (void)dealloc
{
    [_playerLayer release];
	[super dealloc];
}

- (void)onEnter
{
    [super onEnter];
    [self setAccelerometerEnabled:YES];
    [self setTouchEnabled:YES];
    
    [self genBackground];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColor];
    
    _playerLayer = [[CCLayer alloc] init];
    NSMutableArray *playerList = [CCArray array];
    
    for (int i=0; i<36; i++) {
//        CCSprite *player = [CCSprite spriteWithFile:[NSString stringWithFormat:@"p%d.jpg",i]];
//        player.scale = 0.5;
//        player.position = CGPointMake(winSize.width/2 + winSize.width*i, winSize.height/2 + 50);
//        [_playerLayer addChild:player z:0];
        
        CCMenuItemImage *player = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"p%d.jpg",i] selectedImage:[NSString stringWithFormat:@"p%d.jpg",i] target:self selector:@selector(play:)];
        player.tag = i;
        player.scale = 0.5;
        player.position = CGPointMake(winSize.width/2 + winSize.width*i, winSize.height/2 + 50);
        [playerList addObject:player];
    }
    CCMenu *menu = [CCMenu menuWithArray:playerList];
    menu.position = CGPointMake(0, 0);
    
    [_playerLayer addChild:menu z:0];
    [self addChild:_playerLayer z:0];    
}

- (void)genBackground
{
//    ccColor4F color = [self randomBrightColor];
    ccColor4B color = ccc4(255, 255, 255, 255);
    CCLayerColor *backgroung = [CCLayerColor layerWithColor:color];
    [self addChild:backgroung z:-1];
}

- (ccColor4F)randomBrightColor
{
    while (true) {
        float requiredBrightness = 192;
        ccColor4B randomColor =
        ccc4(arc4random() % 255,
             arc4random() % 255,
             arc4random() % 255,
             255);
        if (randomColor.r > requiredBrightness ||
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }
    }
}

- (void)draw
{
    CC_NODE_DRAW_SETUP();
    
    
}

- (void)play:(CCMenuItemImage *)player
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[PlayLayer sceneWithFile:[[NSString stringWithFormat:@"p%d.jpg",player.tag] retain]]]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    float locationX = [touch locationInView:touch.view].x;
    float newLocationX = [touch previousLocationInView:touch.view].x;
    NSLog(@"%f",_playerLayer.position.x);
    _playerLayer.position = CGPointMake(_playerLayer.position.x + (locationX - newLocationX)*2, _playerLayer.position.y);
}

@end

//
//  OverLayer.m
//  Jump
//
//  Created by Meme on 13-8-23.
//  Copyright 2013年 Meme. All rights reserved.
//

#import "OverLayer.h"
#import "PlayLayer.h"
#import "MenuLayer.h"

@interface OverLayer () {
    NSString *_finalScore;
    CCLabelTTF *_title;
    CCLabelTTF *_score;
}

- (void)replay;

@end

@implementation OverLayer

+ (CCScene *) sceneWithScore:(NSString *)score
{
	CCScene *scene = [CCScene node];
	OverLayer *layer = [[[OverLayer alloc] initWithScore:score] autorelease];
	[scene addChild: layer];
	return scene;
}

- (id)initWithScore:(NSString *)score
{
	if( (self=[super init])) {
        _finalScore = score;
	}
	return self;
}

- (void)dealloc
{
    [_finalScore release];
    [_title release];
    [_score release];
    
    [super dealloc];
}

- (void)onEnter
{
    [super onEnter];
    [self setTouchEnabled:YES];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    _title = [[CCLabelTTF alloc] initWithString:@"Your Score" fontName:@"Marker Felt" fontSize:30];
    _title.position = ccp(winSize.width/2, winSize.height/2 + 100);
    _title.color = ccc3(255, 255, 255);
    [self addChild:_title z:0];
    
    _score = [[CCLabelTTF alloc] initWithString:_finalScore fontName:@"Marker Felt" fontSize:20];
    _score.position = ccp(winSize.width/2, winSize.height/2 + 50);
    _score.color = ccc3(255, 255, 255);
    [self addChild:_score z:0];
    
    [self genReplayButton];
}

- (void)genReplayButton
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItemFont *replayButton = [CCMenuItemFont itemWithString:@"replay" target:self selector:@selector(replay)];
    replayButton.fontSize = 20;
    
    CCMenu *menu = [CCMenu menuWithItems:replayButton, nil];
    menu.position = ccp(winSize.width/2, winSize.height/2 - 50);
    [self addChild:menu z:0];
}

- (void)replay
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:[MenuLayer scene]]];
}

@end

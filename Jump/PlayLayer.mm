//
//  HelloWorldLayer.mm
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright Meme 2013年. All rights reserved.
//

#import "PlayLayer.h"
#import "OverLayer.h"
#import "Player.h"
#import "Board.h"
#import "MyContactFilter.h"
#import "MyContactListener.h"
#import "GLES-Render.h"

#define kOnceBoardRatio 5
#define kBrokenBoardRatio 5

@interface PlayLayer() {
    b2World *_world;
    CCSprite *_background1;
    CCSprite *_background2;
//    CCLayerColor *_background;
    
    GLESDebugDraw *_debugDraw;
    
    Player *_player;
    Board *_curBoard;
    CCArray *_boardArray;
    CCLabelTTF *_score;
    
    float _offsetY;
    BOOL _tapDown;
    UITouch *_touch;
    
    NSString *_file;
}

@end

@implementation PlayLayer

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [[PlayLayer alloc] init];
	[scene addChild: layer];
	return scene;
}

+ (CCScene *)sceneWithFile:(NSString *)file
{
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [[PlayLayer alloc] initWithFile:file];
	[scene addChild: layer];
	return scene;
}

- (id)initWithFile:(NSString *)file
{
	if( (self=[super init])) {
        _file = file;
	}
	return self;
}

- (void)dealloc
{
    [_score release];
    [_player release];
    [_curBoard release];
    [_boardArray release];
    [_touch release];
    
    delete _debugDraw;
    _debugDraw = NULL;
    
    delete _world;
    _world = NULL;
    
	[super dealloc];
}

- (void)onEnter
{
    [super onEnter];
    [self setAccelerometerEnabled:YES];
    [self setTouchEnabled:YES];
    
    [self setupWorld];
    [self setupDebugDraw];
    [self genBackground];
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColor];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _player = [[Player alloc] initWithWorld:_world file:_file];
    [self addChild:_player z:1];
    
    CGPoint position = CGPointMake(winSize.width/2, BOARD_WIDTH);
    _curBoard = [[Board alloc] initWithWorld:_world andPosition:position];
    [self addChild:_curBoard z:0];
    _player.curBoard = _curBoard;
    
    _boardArray = [[CCArray alloc] init];
    [_boardArray addObject:_curBoard];
    
    _offsetY = 0;
    _tapDown = NO;
    [self genBoardWithNum:15 andStartY:BOARD_WIDTH andRange:winSize.height - BOARD_WIDTH];
    
    _score = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Marker Felt" fontSize:18];
    _score.position = ccp(winSize.width/2, winSize.height - 30);
    _score.color = ccc3(255, 0, 0);
    [self addChild:_score z:0];
    
    [self scheduleUpdate];
}

- (void)setupDebugDraw
{
    _debugDraw = new GLESDebugDraw(PTM_RATIO);
    _world->SetDebugDraw(_debugDraw);
    _debugDraw->SetFlags(GLESDebugDraw::e_shapeBit | GLESDebugDraw::e_jointBit);
}

- (void)setupWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, -35.0f);
    bool doSleep = true;
    _world = new b2World(gravity);
    _world->SetAllowSleeping(doSleep);
    _world->SetContactFilter(new MyContactFilter);
    _world->SetContactListener(new MyContactListener);
}

- (void)genBoardWithNum:(int)num andStartY:(float)startY andRange:(float)range
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int boardN = num;
    
    static float maxY = 0;
    
    for (int i = 0; i < boardN; i++) {
//        float x = winSize.width/2;
        float x = arc4random() % (int)(winSize.width - 2*BOARD_LENGTH) + BOARD_LENGTH;
        float y = arc4random() % (int)range + startY;
        
        float minY = winSize.height;
        BOOL isInvalid = NO;
        for (Board *lastBoard in _boardArray) {
            minY = MIN(minY, fabsf(y - lastBoard.position.y));
            if(fabsf(x - lastBoard.position.x) <= 2*BOARD_LENGTH + 5 && fabsf(y - lastBoard.position.y) <= 2*BOARD_WIDTH + 5) {
                isInvalid = YES;
                break;
            }
        }
        if (minY > 160) {
            isInvalid = YES;
        }
        if (isInvalid) {
            i--;
            continue;
        }
        
        maxY = MAX(maxY, y);
        CGPoint position = CGPointMake(x, y);
        int once = arc4random() % kOnceBoardRatio;
        int broken = arc4random() % kBrokenBoardRatio;
        Board *board = [[Board alloc] initWithWorld:_world andPosition:position];
        if (once == 0) {
            board.isOnce = YES;
        } else if (broken == 0) {
            board.isBroken = YES;
        }
        [_boardArray addObject:board];
        [self addChild:board z:0];
        [board release];
    }
    
    float dt = startY + range - maxY;
//    NSLog(@"%f,%f",maxY,dt);
    if (dt > 160) {
        [self genBoardWithNum:dt/50 andStartY:maxY andRange:dt];
    }
}

- (void)genBackground
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
//    _background1 = [CCSprite spriteWithFile:@"bg.png"];
//    _background2 = [CCSprite spriteWithFile:@"bg.png"];
//    
//    _background1.position = CGPointMake(winSize.width/2, _background1.contentSize.height/2);
//    _background2.position = CGPointMake(winSize.width/2, _background1.contentSize.height/2 + _background1.contentSize.height);
//    
//    [self addChild:_background1 z:-1];
//    [self addChild:_background2 z:-1];
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
    
    _world->DrawDebugData();
}

- (void)update:(ccTime)delta
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    static double updateInterval = 1.0f/60.0f;
    static int velocityIterations = 8;
    static int positionIterations = 1;
    _world->Step(updateInterval, velocityIterations, positionIterations);
    
    [_player update];
    if (_player.position.y + PLAYER_RADIUS <= _offsetY) {
        CCScene *nextScene = [OverLayer sceneWithScore:[_score.string retain]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.7 scene:nextScene]];
    }
    
    float locationX = [_touch locationInView:_touch.view].x;
    if (_tapDown) {
        if (locationX > winSize.width/2) {
            [_player transformX:YES];
        } else {
            [_player transformX:NO];
        }
    }
    
    [_score setString:[NSString stringWithFormat:@"%d", (int)(_player.curBoard.position.y + _offsetY)]];
    
    float dt = _player.curBoard.position.y - winSize.height/3.0f - _offsetY;
    if (dt > 0 && !_player.curBoard.isMove) {
        CCMoveBy *layerMoveBy = [CCMoveBy actionWithDuration:0.2 position:CGPointMake(0, -dt)];
        [self runAction:layerMoveBy];
        
        CCMoveBy *scoreMoveBy = [CCMoveBy actionWithDuration:0.2 position:CGPointMake(0, dt)];
        [_score runAction:scoreMoveBy];
        
        _player.curBoard.isMove = YES;
        
        [self genBoardWithNum:dt/50 andStartY:winSize.height + _offsetY andRange:dt];
        _offsetY += dt;
    }
    
    for (Board *board in _boardArray) {
        
        if (board.position.y + BOARD_WIDTH <= _offsetY || board.isToDestroy) {
            [board removeBody];
            [board removeFromParentAndCleanup:YES];
            [_boardArray removeObject:board];
        }
    }
    
//    if (_background2.position.y <= _offsetY) {
//        _background1.position = CGPointMake(_background1.position.x, _background2.position.y + _background2.contentSize.height);
//    }
//    if (_background1.position.y <= _offsetY) {
//        _background2.position = CGPointMake(_background2.position.x, _background1.position.y + _background1.contentSize.height);
//    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touch = [[touches anyObject] retain];
    _tapDown = YES;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _tapDown = NO;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _tapDown = NO;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
}

@end

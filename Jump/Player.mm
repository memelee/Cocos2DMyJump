//
//  Player.m
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "Player.h"
#import "Board.h"

@interface Player () {
    b2World *_world;
    b2Body *_body;
}

@end

@implementation Player

- (id)initWithWorld:(b2World *)world file:(NSString *)file
{
    self = [super init];
//    self = [super initWithFile:file rect:CGRectMake(100, 0, 280, 386)];
    if (self) {
//        self.scale = 0.1;
        _world = world;
        [self createBody];
    }
    return self;
}

- (void)createBody
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint startPosition = ccp(winSize.width/2.0f, BOARD_WIDTH*2 + PLAYER_RADIUS);
    
    b2BodyDef bd;
    bd.type = b2_dynamicBody;
    bd.userData = self;
    bd.position.Set(startPosition.x/PTM_RATIO, startPosition.y/PTM_RATIO);
    _body = _world->CreateBody(&bd);
    
    b2CircleShape shape;
    shape.m_radius = PLAYER_RADIUS/PTM_RATIO;
    
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    fd.restitution = 1.0f;
    fd.friction = 0.0f;
    _body->CreateFixture(&fd);
    
    _body->SetActive(true);
    _body->SetLinearVelocity(b2Vec2(0.0f, 20.0f));
}

- (void)update
{
    _body->SetActive(true);
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (_body->GetPosition().x < 0)
        _body->SetTransform(b2Vec2(_body->GetPosition().x + winSize.width/PTM_RATIO, _body->GetPosition().y), 0);
    if (_body->GetPosition().x > winSize.width/PTM_RATIO)
        _body->SetTransform(b2Vec2(_body->GetPosition().x - winSize.width/PTM_RATIO, _body->GetPosition().y), 0);
    
    self.position = ccp(_body->GetPosition().x*PTM_RATIO, _body->GetPosition().y*PTM_RATIO);
    
//    NSLog(@"%f,%f",_body->GetPosition().x*PTM_RATIO,_body->GetPosition().y*PTM_RATIO);
}

- (void)transformX:(BOOL)right
{
    if(right) {
        _body->ApplyForce(b2Vec2(10, 0),_body->GetPosition());
    } else {
        _body->ApplyForce(b2Vec2(-10, 0),_body->GetPosition());
    }
}

@end

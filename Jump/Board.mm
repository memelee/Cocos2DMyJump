//
//  Board.m
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "Board.h"

@interface Board () {
    b2World *_world;
    b2Body *_body;
}

@end

@implementation Board

- (id)initWithWorld:(b2World *)world andPosition:(CGPoint)position
{
    self = [super init];
    if (self) {
        _world = world;
        self.isOnce = NO;
        self.isBroken = NO;
        self.isMove = NO;
        self.isToDestroy = NO;
        self.position = position;
        [self createBodyWithPositon:position];
    }
    return self;
}

- (void)createBodyWithPositon:(CGPoint)position
{    
    b2BodyDef bd;
    bd.type = b2_staticBody;
    bd.userData = self;
    bd.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    _body = _world->CreateBody(&bd);
    
    b2PolygonShape shape;
    shape.SetAsBox(BOARD_LENGTH/PTM_RATIO, BOARD_WIDTH/PTM_RATIO);
    
    _body->CreateFixture(&shape,0);
}

- (void)update
{    
    self.position = ccp(_body->GetPosition().x*PTM_RATIO, _body->GetPosition().y*PTM_RATIO);
    //NSLog(@"%f,%f",_body->GetPosition().x*PTM_RATIO,_body->GetPosition().y*PTM_RATIO);
}

- (void)removeBody
{
    _world->DestroyBody(_body);
}

@end

//
//  Board.h
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "Box2D.h"
#import "CCSprite.h"

@interface Board : CCSprite

@property (assign, nonatomic) BOOL isOnce;
@property (assign, nonatomic) BOOL isBroken;
@property (assign, nonatomic) BOOL isMove;

@property (assign, nonatomic) BOOL isToDestroy;

- (id)initWithWorld:(b2World *)world andPosition:(CGPoint)position;
- (void)update;
- (void)removeBody;

@end

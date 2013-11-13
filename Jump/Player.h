//
//  Player.h
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "Box2D.h"
#import "CCSprite.h"

@class Board;
@interface Player : CCSprite

@property (retain, nonatomic) Board *curBoard;

- (id)initWithWorld:(b2World *)world file:(NSString *)file;
- (void)update;
- (void)transformX:(BOOL)right;

@end

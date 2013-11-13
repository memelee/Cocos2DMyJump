//
//  MyContactListener.cpp
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "MyContactFilter.h"
#import "Board.h"

bool MyContactFilter::ShouldCollide(b2Fixture *fixtureA, b2Fixture *fixtureB)
{
    b2Body *bodyA = fixtureA->GetBody();
    b2Body *bodyB = fixtureB->GetBody();
    
    if (bodyA->GetType() == b2_dynamicBody
         && bodyA->GetLinearVelocity().y < 0
         && bodyA->GetPosition().y - PLAYER_RADIUS/PTM_RATIO > bodyB->GetPosition().y
        ) {
        
        Board *board = (Board *)(bodyB->GetUserData());
        if (board.isBroken == YES) {
            board.isToDestroy = YES;
            return false;
        } else {
            return true;
        }
    }
    
    if (bodyB->GetType() == b2_dynamicBody
         && bodyB->GetLinearVelocity().y < 0
         && bodyB->GetPosition().y - PLAYER_RADIUS/PTM_RATIO > bodyA->GetPosition().y
         ) {
//            NSLog(@"%f,%f",bodyA->GetLinearVelocity().y,bodyB->GetLinearVelocity().y);
        
        Board *board = (Board *)(bodyA->GetUserData());
        if (board.isBroken == YES) {
            board.isToDestroy = YES;
            return false;
        } else {
            return true;
        }
    }
    
    return false;
}
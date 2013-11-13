//
//  MyContactListener.cpp
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#import "MyContactListener.h"
#import "Player.h"
#import "Board.h"

void MyContactListener::BeginContact(b2Contact *contact)
{
    
} //当刚体发生碰撞开始的时候调用

void MyContactListener::EndContact(b2Contact *contact)
{
    b2Body *bodyA = contact->GetFixtureA()->GetBody();
    b2Body *bodyB = contact->GetFixtureB()->GetBody();
    
    if (bodyA->GetType() == b2_dynamicBody) {
        Board *board = (Board *)(bodyB->GetUserData());
        
        ((Player *)bodyA->GetUserData()).curBoard = board;
        bodyA->SetLinearVelocity(b2Vec2(0.0f, 20.0f));
        
        if (board.isOnce) {
            board.isToDestroy = YES;
        }
    }
    
    if (bodyB->GetType() == b2_dynamicBody) {
        Board *board = (Board *)(bodyA->GetUserData());
        
        ((Player *)bodyB->GetUserData()).curBoard = board;
        bodyB->SetLinearVelocity(b2Vec2(0.0f, 20.0f));
        
        if (board.isOnce) {
            board.isToDestroy = YES;
        }
    }
}//当刚体结束碰撞时调用
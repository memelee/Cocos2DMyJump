//
//  MyContactListener.h
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#ifndef __Jump__MyContactFilter__
#define __Jump__MyContactFilter__

#import "Box2D.h"

class MyContactFilter : public b2ContactFilter {
public:
    virtual bool ShouldCollide(b2Fixture* fixtureA, b2Fixture* fixtureB);
};

#endif /* defined(__Jump__MyContactListener__) */

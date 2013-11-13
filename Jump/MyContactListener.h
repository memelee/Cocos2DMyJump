//
//  MyContactListener.h
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright (c) 2013年 Meme. All rights reserved.
//

#ifndef __Jump__MyContactListener__
#define __Jump__MyContactListener__

#import "Box2D.h"

class MyContactListener : public b2ContactListener {
public:    
    virtual void BeginContact(b2Contact *contact);
    virtual void EndContact(b2Contact *contact);
};

#endif /* defined(__Jump__MyContactListener__) */

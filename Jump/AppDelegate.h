//
//  AppDelegate.h
//  Jump
//
//  Created by Meme on 13-8-15.
//  Copyright Meme 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end

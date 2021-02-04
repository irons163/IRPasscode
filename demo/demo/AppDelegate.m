//
//  AppDelegate.m
//  demo
//
//  Created by Phil on 2019/11/15.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Utilities.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [Utilities removeSecurityPin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Utilities openSecurityPinPage];
}

@end

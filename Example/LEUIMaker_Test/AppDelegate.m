//
//  AppDelegate.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/10/31.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LEEmoji.h"
#import "LEUIMaker.h"
#import <FMDB/FMDB.h>
@interface AppDelegate ()

@end

@implementation AppDelegate{
    
} 
 //



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController * curVC=[[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:curVC]; 
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [nav setNavigationBarHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    [[LEEmoji sharedInstance] leInitEmojiWithDeleteIcon:[UIImage imageNamed:LEEmojiDeleteIcon] KeyboardIcon:[UIImage imageNamed:LEEmojiSwitchToKeyboard] EmojiIcon:[UIImage imageNamed:LEEmojiSwitchToEmoji]];
    [[LEEmoji sharedInstance] leSetCategoryIcons:LEEmojiIcons Emojis:LEEmojiData];
    
//    UIImage *img2x=[UIImage imageNamed:@"LE_qrcode_scan_bg@2x"];
//    UIImage *img3x=[UIImage imageNamed:@"LE_qrcode_scan_bg@3x"];
////    UIImage *img2x=[UIImage imageNamed:@"LE_qrcode_scan_line@2x"];
////    UIImage *img3x=[UIImage imageNamed:@"LE_qrcode_scan_line@3x"];
//    NSData *data=UIImagePNGRepresentation(img2x);
//    NSString *imgStr=[data base64EncodedStringWithOptions:0];
//    LELogObject(imgStr)
//    data=UIImagePNGRepresentation(img3x);
//    imgStr=[data base64EncodedStringWithOptions:0];
//    LELogObject(imgStr) 
    
    
    
    
    
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

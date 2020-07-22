//
//  AppDelegate.m
//  断点续传尝试
//
//  Created by 张晓旭 on 2020/7/11.
//  Copyright © 2020 张晓旭. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (NSURLSession *)backgroundURLSession {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"zxxSessionConfig"];
       NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
//       NSURL *requestUrl = [NSURL URLWithString:@"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4"];
//       NSMutableURLRequest *downLoadRequest = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
//       [downLoadRequest setHTTPMethod:@"GET"];
//        self.downLoadTask = [self.session downloadTaskWithRequest:downLoadRequest];
//       [self.downLoadTask resume];
    return session;
}

#pragma mark - UISceneSession lifecycle

//- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
//    NSURLSession *backgroundSession = [self backgroundURLSession];
//    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
//    // 保存 completion handler 以在处理 session 事件后更新 UI
////    [self addCompletionHandler:completionHandler forSession:identifier];
//}
// - (void)addCompletionHandler:(CompletionHandlerType)handler
//  forSession:(NSString *)identifier {
//        if ([self.completionHandlerDictionary objectForKey:identifier]) {
//           NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
//        }
//        [self.completionHandlerDictionary setObject:handler forKey:identifier];
//}
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%@",identifier);
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMyNotificationTerminate"
//    object:nil];
}

@end

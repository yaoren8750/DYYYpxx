//
//  FLEXManager+Networking.m
//  FLEX
//
//  Created by Tanner on 2/1/20.
//  Copyright © 2020 FLEX Team. All rights reserved.
//

#import "FLEXManager+Networking.h"
#import "FLEXManager+Private.h"
#import "FLEXNetworkObserver.h"
#import "FLEXNetworkRecorder.h"
#import "FLEXObjectExplorerFactory.h"
#import "NSUserDefaults+FLEX.h"

@implementation FLEXManager (Networking)

+ (void)load {
    if (NSUserDefaults.standardUserDefaults.flex_registerDictionaryJSONViewerOnLaunch) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Register array/dictionary viewer for JSON responses
            [self.sharedManager setCustomViewerForContentType:@"application/json"
                viewControllerFutureBlock:^UIViewController *(NSData *data) {
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if (jsonObject) {
                        return [FLEXObjectExplorerFactory explorerViewControllerForObject:jsonObject];
                    }
                    return nil;
                }
            ];
        });
    }
}

- (BOOL)isNetworkDebuggingEnabled {
    return FLEXNetworkObserver.isEnabled;
}

- (void)setNetworkDebuggingEnabled:(BOOL)networkDebuggingEnabled {
    FLEXNetworkObserver.enabled = networkDebuggingEnabled;
}

- (NSUInteger)networkResponseCacheByteLimit {
    return FLEXNetworkRecorder.defaultRecorder.responseCacheByteLimit;
}

- (void)setNetworkResponseCacheByteLimit:(NSUInteger)networkResponseCacheByteLimit {
    FLEXNetworkRecorder.defaultRecorder.responseCacheByteLimit = networkResponseCacheByteLimit;
}

- (NSMutableArray<NSString *> *)networkRequestHostDenylist {
    return FLEXNetworkRecorder.defaultRecorder.hostDenylist;
}

- (void)setNetworkRequestHostDenylist:(NSMutableArray<NSString *> *)networkRequestHostDenylist {
    FLEXNetworkRecorder.defaultRecorder.hostDenylist = networkRequestHostDenylist;
}

- (void)setCustomViewerForContentType:(NSString *)contentType
            viewControllerFutureBlock:(FLEXCustomContentViewerFuture)viewControllerFutureBlock {
    NSParameterAssert(contentType.length);
    NSParameterAssert(viewControllerFutureBlock);
    NSAssert(NSThread.isMainThread, @"此方法必须从主线程调用.");

    self.customContentTypeViewers[contentType.lowercaseString] = viewControllerFutureBlock;
}

@end

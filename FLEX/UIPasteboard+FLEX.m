//
//  UIPasteboard+FLEX.m
//  FLEX
//
//  Created by Tanner Bennett on 12/9/19.
//  Copyright © 2020 FLEX Team. All rights reserved.
//

#import "UIPasteboard+FLEX.h"

@implementation UIPasteboard (FLEX)

- (void)flex_copy:(id)object {
    if (!object) {
        return;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        UIPasteboard.generalPasteboard.string = object;
    } else if([object isKindOfClass:[NSData class]]) {
        [UIPasteboard.generalPasteboard setData:object forPasteboardType:@"public.data"];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        UIPasteboard.generalPasteboard.string = [object stringValue];
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"尝试复制不受支持的类型: %@", [object class]];
    }
}

@end

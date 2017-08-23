//
//  UIImageView+LCURL.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "UIImageView+LCURL.h"

#import <objc/runtime.h>

static char *nameKey = "UIImageView+LCURL";

@implementation UIImageView (LCURL)

- (void)setlc_URLString:(NSString *)urlString {
    objc_setAssociatedObject(self, nameKey, urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lc_URLString {
    return objc_getAssociatedObject(self, nameKey);
}

- (void)lc_setImageWithURLString:(NSString *)urlString {
    [self setlc_URLString:urlString];
    __weak typeof(self) weakSelf = self;
    .(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if ([[self lc_URLString] isEqualToString:urlString]) {
                    [strongSelf setImage:[UIImage imageWithData:imageData]];
                }
            });
        }
    });
}

@end

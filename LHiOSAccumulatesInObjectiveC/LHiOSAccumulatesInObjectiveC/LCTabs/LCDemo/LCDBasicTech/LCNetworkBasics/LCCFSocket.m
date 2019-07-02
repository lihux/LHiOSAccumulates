//
//  LCCFSocket.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/2.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCCFSocket.h"

#import <arpa/inet.h>
#import <CoreFoundation/CFSocket.h>

void serverCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    if (data == NULL) {
        printf("CFSocket 建立连接成功");
    } else {
        printf("CFSocket 建立连接失败");
    }
}

@interface LCCFSocket ()

@property (nonatomic, assign) CFSocketRef clientSocketfd;

@end

@implementation LCCFSocket

- (void)connect {
    [self connectToServer:@"127.0.0.1" port:54321];
}

- (void)connectToServer:(NSString *)ip port:(int)port {
    if (self.clientSocketfd) {//断开连接
        CFSocketInvalidate(self.clientSocketfd);
        CFRelease(self.clientSocketfd);
        self.clientSocketfd = NULL;
        return;
    }
    
    //建立新的连接
    
    self.clientSocketfd = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack, serverCallBack, NULL);
    if (self.clientSocketfd) {
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr, sizeof(addr));
        CFSocketError result = CFSocketConnectToAddress(self.clientSocketfd, address, 3);
        CFRelease(address);
        if (result == kCFSocketSuccess) {
            printf("CFSocket 建立连接成功");
            [self sendData];
        }
    }
}

- (void)sendData {
    char *str = "\nThis message was send from Lihux's Personal APP Using CFSocket!\n";
    ssize_t sendLen = send(CFSocketGetNative(self.clientSocketfd), str, strlen(str), 0);
    if (sendLen == -1) {
        NSLog(@"发送失败");
    } else {
        NSLog(@"发送成功");
    }
}

@end


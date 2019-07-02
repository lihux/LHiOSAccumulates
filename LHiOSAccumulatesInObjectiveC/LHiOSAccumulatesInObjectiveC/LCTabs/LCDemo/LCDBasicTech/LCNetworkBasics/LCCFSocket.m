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

//https://www.cnblogs.com/QianChia/p/6391989.html

void clientSideCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    if (data == NULL) {
        printf("CFSocket 建立连接成功");
    } else {
        printf("CFSocket 建立连接失败");
    }
}

void readStream(CFReadStreamRef iStream, CFStreamEventType eventType, void * clientCallBackInfo){
    
    char buf[2048];
    bzero(buf, sizeof(buf));
    
    do {
        // 接收数据
        CFIndex dex = CFReadStreamRead(iStream, (UInt8 *)buf, sizeof(buf));
        if (dex > 0) {
            printf("s服务器收到数据：%s", buf);
        }
        sleep(1);
        
    } while (strcmp(buf, "exit") != 0);
}

void serverSideCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    if (type != kCFSocketAcceptCallBack) {
        return;
    }
    CFSocketNativeHandle nativeHandle = *(CFSocketNativeHandle *)data;
    uint8_t name[SOCK_MAXADDRLEN];
    socklen_t nameLen = sizeof(name);
    if (getpeername(nativeHandle, (struct sockaddr *)name, &nameLen) != 0) {
        printf("服务器获取信息失败");
        return;
    }
    struct sockaddr_in *addr_in = (struct sockaddr_in *)name;
    char *ip_addr = inet_ntoa(addr_in->sin_addr);
    int ip_port = addr_in->sin_port;
    printf("\n服务器已连接：%s, port:%d\n", ip_addr, ip_port);

    CFReadStreamRef iStream;
    CFWriteStreamRef oStream;
    
    // 创建一组可读/写的 CFStreame
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeHandle, &iStream, &oStream);
    
    if (iStream && oStream) {
        
        // 打开输入流和输出流
        CFReadStreamOpen(iStream);
        CFWriteStreamOpen(oStream);
        
        CFStreamClientContext streamContext = {0, NULL, NULL, NULL};
        
        // if have data to read   call the readStream function
        if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable, readStream, &streamContext)) {
            exit(1);
        }
        
        CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    }
}

@interface LCCFSocket ()

@property (nonatomic, assign) CFSocketRef clientSocketfd;
@property (nonatomic, assign) CFSocketRef serverSocketfd;
@property (nonatomic, strong) dispatch_queue_t serverQueue;

@end

@implementation LCCFSocket

- (void)connect {
    [self buildServerWithIP:@"127.0.0.1" port:5431];
    [self connectToServer:@"127.0.0.1" port:5431];
}

- (void)connectToServer:(NSString *)ip port:(int)port {
    if (self.clientSocketfd) {//断开连接
        CFSocketInvalidate(self.clientSocketfd);
        CFRelease(self.clientSocketfd);
        self.clientSocketfd = NULL;
        return;
    }
    
    //建立新的连接
    self.clientSocketfd = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack, clientSideCallBack, NULL);
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

- (void)buildServerWithIP:(NSString *)ip port:(int)port {
    if (self.serverSocketfd) {
        CFSocketInvalidate(self.serverSocketfd);
        CFRelease(self.serverSocketfd);
        self.serverSocketfd = NULL;
        return;
    }
    self.serverSocketfd = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, serverSideCallBack, NULL);
    if (self.serverSocketfd) {
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr, sizeof(addr));
        int optVal = 1;
        setsockopt(CFSocketGetNative(self.serverSocketfd), SOL_SOCKET, SO_REUSEADDR, (void *)&optVal, sizeof(optVal));
        CFSocketError err = CFSocketSetAddress(self.serverSocketfd, address);
        CFRelease(address);
        if (err == kCFSocketSuccess) {
            self.serverQueue = dispatch_queue_create("queue.server.me.lihux", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(self.serverQueue, ^{
                CFRunLoopRef runloop = CFRunLoopGetCurrent();
                CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.serverSocketfd, 0);
                CFRunLoopAddSource(runloop, source, kCFRunLoopCommonModes);
                CFRelease(source);
                CFRunLoopRun();
            });
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

- (void)dealloc {
    if (self.clientSocketfd) {
        CFRelease(self.clientSocketfd);
    }
    if (self.serverSocketfd) {
        CFRelease(self.serverSocketfd);
    }
}

@end


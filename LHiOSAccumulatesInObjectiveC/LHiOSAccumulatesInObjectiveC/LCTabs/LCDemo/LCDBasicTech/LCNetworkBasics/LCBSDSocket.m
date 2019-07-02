//
//  LCBSDSocket.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/2.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCBSDSocket.h"

#import <arpa/inet.h>

@interface LCBSDSocket ()

@property (nonatomic, assign) int clientSocket;

@end

@implementation LCBSDSocket

-(void)connect {
    [self connectToServer:@"127.0.0.1" port:54321];
}

//建立连接
- (void)connectToServer:(NSString *)ip port:(int)port {
    if (self.clientSocket) {
        shutdown(self.clientSocket, SHUT_RDWR);
        close(self.clientSocket);
        self.clientSocket = 0;
        return;
    }
    /*
     1.AF_INET: ipv4 执行ip协议的版本
     2.SOCK_STREAM：指定Socket类型,面向连接的流式socket 传输层的协议
     3.IPPROTO_TCP：指定协议。 IPPROTO_TCP 传输方式TCP传输协议
     返回值 大于0 创建成功
     */
    self.clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip.UTF8String);
    int connectResult = connect(self.clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
    if (connectResult == 0) {
        NSLog(@"连接成功");
        [self sendData];
    } else {
        NSLog(@"连接失败");
    }
}

- (void)sendData {
    char *str = "\nThis message was send from Lihux's Personal APP!\n";
    ssize_t sendLen = send(self.clientSocket, str, strlen(str), 0);
    if (sendLen == -1) {
        NSLog(@"发送失败");
    }
}

@end

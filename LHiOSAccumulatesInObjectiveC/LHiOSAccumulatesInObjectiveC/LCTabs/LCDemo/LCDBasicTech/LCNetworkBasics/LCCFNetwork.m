//
//  LCCFNetwork.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/3.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCCFNetwork.h"

#import <CFNetwork/CFNetwork.h>
#import <arpa/inet.h>

void host_call_back(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info){}

@interface LCCFNetwork ()

@end

@implementation LCCFNetwork

- (void)connect {
    [self fetchAddressFromHost];
}

- (void)fetchAddressFromHost {
    NSString *str = @"www.mucang.cn";
    //https://www.cnblogs.com/onlywish/p/4189006.html
    CFHostRef host = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)str);
    Boolean success;
    CFArrayRef adds = CFHostGetAddressing(host, &success);
    if (success) {
        printf("成功解决百度地址");
    } else {
        [self.class getIpAddress:str label:@"天王盖地虎"];
    }
}

+(NSArray *)getIpAddress:(NSString *)host label:(NSString *)label;
{
    NSMutableDictionary *dic;
    if (dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
    }
    
    if ([dic objectForKey:label] != nil) {
        return nil;
    }
    
    //添加取消接口
    NSPort *port = [NSPort port];
//    [dic setObject:port forKey:label];
    [dic setValue:port forKey:label];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
    
    //解析域名代码
    CFHostRef hostref = CFHostCreateWithName(NULL,(__bridge CFStringRef)(host));
    
    //设置异步
    CFHostClientContext context;
    memset(&context,0,sizeof(CFHostClientContext));
    CFHostSetClient(hostref, host_call_back, &context);
    
    //添加至runloop
    CFHostScheduleWithRunLoop(hostref,[[NSRunLoop currentRunLoop] getCFRunLoop],kCFRunLoopDefaultMode);
    
    NSLog(@"正在解析....");
    //开始解析
    CFHostStartInfoResolution(hostref,kCFHostAddresses,NULL);
    
    //等待完成
    [[NSRunLoop currentRunLoop] acceptInputForMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    //取消运行循环
    CFHostUnscheduleFromRunLoop(hostref, [[NSRunLoop currentRunLoop] getCFRunLoop], kCFRunLoopDefaultMode);
    
    //移除取消接口
    [dic removeObjectForKey:label];
    [port invalidate];
    
    NSLog(@"解析完成....");
    Boolean flag;
    
    //取得解析的ip地址
    NSArray * array = (__bridge NSArray *)CFHostGetAddressing(hostref, &flag);
    //释放解析对象
    CFRelease(hostref);
    if (flag == NO)
        return nil;
    
    struct sockaddr_in *sock_ptr;
    
    NSMutableArray * result = [NSMutableArray array];
    
    for(NSData * ipaddr in array)
    {
        sock_ptr = (struct sockaddr_in *)[ipaddr bytes];
        
        NSString * ip = [NSString stringWithUTF8String:inet_ntoa(sock_ptr->sin_addr)];
        
        [result addObject:ip];
        
        NSLog(@"ip ========= %@",ip);
    }
    
    //CFRelease((__bridge CFTypeRef)(array));
    return result;
}

@end

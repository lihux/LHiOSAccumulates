//
//  LCDComputerSystemCh2ViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/25.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDComputerSystemCh2ViewController.h"

#import "LCDCSCh2ShowBytes.h"
#import "LCDCSLogHelper.h"

@implementation LCDComputerSystemCh2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self testShowBytes];
}

/**
 源码or习题所在页码：《深入理解计算机系统3》Ch2-P39
 输出结果为：
 不同类型的数据的最大值、最小值系列:
 max_int:    ff ff ff 7f
 min_int:    00 00 00 80
 max_int16:    ff 7f
 min_int16:    00 80
 max_int32:    ff ff ff 7f
 min_int32:    00 00 00 80
 max_int64:    ff ff ff ff ff ff ff 7f
 min_int64:    00 00 00 00 00 00 00 80
 max_long:    ff ff ff ff ff ff ff 7f
 min_long:    00 00 00 00 00 00 00 80
 max_llong:    ff ff ff ff ff ff ff 7f
 min_llong:    00 00 00 00 00 00 00 80
 
 不同类型的数据的具体值系列:
 
 byte: A    41
 today_int16: 20170625    e1 07
 today_int: 20170625    81 c7 33 01
 today_int32: 20170625   81 c7 33 01
 today_int64: 20170625   81 c7 33 01 00 00 00 00
 today_long: 20170625   81 c7 33 01 00 00 00 00
 today_llong: 20170625   81 c7 33 01 00 00 00 00
 today_double: 20170625000000000000.0   d1 69 1a 49 c7 7e f1 43
 today_float: 20170625000000000000.0   3a f6 8b 5f
 today_negativeDouble: -20170625000000000000.0   d1 69 1a 49 c7 7e f1 c3
 today_negativeFloat: -20170625000000000000.0   d1 69 1a 49
 */
- (void)testShowBytes {
    Byte byte = 'A';
    int today_int = 20170625;
    int16_t today_int16 = 2017;
    int32_t today_int32 = 20170625;
    int64_t today_int64 = 20170625;
    long today_long = 20170625;
    long long today_llong = 20170625;
    double today_double = 20170625000000000000.0;
    float today_float = 20170625000000000000.0;
    double today_negativeDouble = -20170625000000000000.0;
    double today_negativeFloat = -20170625000000000000.0;
    
    int max_int = INT_MAX;
    int min_int = INT_MIN;
    int16_t max_int16 = INT16_MAX;
    int16_t min_int16 = INT16_MIN;
    int32_t max_int32 = INT32_MAX;
    int32_t min_int32 = INT32_MIN;
    int64_t max_int64 = INT64_MAX;
    int64_t min_int64 = INT64_MIN;
    long max_long = LONG_MAX;//long 是long int 的简写
    long min_long = LONG_MIN;
    long long max_llong = LLONG_MAX;//long long 是long long int的简写长整型
    long long min_llong = LLONG_MIN;
    
    LCDCS_REDIRECT_LOG_TO_FILE
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    printf("All kings of max and min value:");
    printf("max_int:   ");
    lc_show_bytes(&max_int, sizeof(int));
    printf("min_int:   ");
    lc_show_bytes(&min_int, sizeof(int));
    
    printf("max_int16:   ");
    lc_show_bytes(&max_int16, sizeof(int16_t));
    printf("min_int16:   ");
    lc_show_bytes(&min_int16, sizeof(int16_t));
    
    printf("max_int32:   ");
    lc_show_bytes(&max_int32, sizeof(int32_t));
    printf("min_int32:   ");
    lc_show_bytes(&min_int32, sizeof(int32_t));
    
    printf("max_int64:   ");
    lc_show_bytes(&max_int64, sizeof(int64_t));
    printf("min_int64:   ");
    lc_show_bytes(&min_int64, sizeof(int64_t));
    
    printf("max_long:   ");
    lc_show_bytes(&max_long, sizeof(long));
    printf("min_long:   ");
    lc_show_bytes(&min_long, sizeof(long));
    
    printf("max_llong:   ");
    lc_show_bytes(&max_llong, sizeof(long long));
    printf("min_llong:   ");
    lc_show_bytes(&min_llong, sizeof(long long));
    
    printf("\n\nAll kinds of value that we use normally:\n\n");
    printf("byte: A   ");
    lc_show_bytes(&byte, sizeof(byte));
    
    printf("today_int16: 20170625   ");
    lc_show_bytes(&today_int16, sizeof(int16_t));
    
    printf("today_int: 20170625   ");
    lc_show_bytes(&today_int, sizeof(int));
    
    printf("today_int32: 20170625  ");
    lc_show_bytes(&today_int32, sizeof(int32_t));
    
    printf("today_int64: 20170625  ");
    lc_show_bytes(&today_int64, sizeof(int64_t));
    
    printf("today_long: 20170625  ");
    lc_show_bytes(&today_long, sizeof(long));
    
    printf("today_llong: 20170625  ");
    lc_show_bytes(&today_llong, sizeof(long long));
    
    printf("today_double: 20170625000000000000.0  ");
    lc_show_bytes(&today_double, sizeof(double));
    
    printf("today_float: 20170625000000000000.0  ");
    lc_show_bytes(&today_float, sizeof(float));
    
    printf("today_negativeDouble: -20170625000000000000.0  ");
    lc_show_bytes(&today_negativeDouble, sizeof(double));
    
    printf("today_negativeFloat: -20170625000000000000.0  ");
    lc_show_bytes(&today_negativeFloat, sizeof(float));
    
    printf("\n\n=======lihux.me=======\n\n");
    printf("\ntestUnderstandTwosComplement:\n\n");
    short x = 12345;
    short mx = -x;
#pragma clang diagnostic pop
    
    //《深入理解计算机系统3》Ch2-P48 补码的理解（Two's Complement）
    printf("short 12345's Two's Complement is \n");
    lc_show_bytes((lc_byte_pointer)&x, sizeof(short));
    printf("short -12345's Two's Complement is \n");
    lc_show_bytes((lc_byte_pointer)&mx, sizeof(short));
    
    LCDCS_FINISH_FILE_LOG_AND_PRINT
}

@end

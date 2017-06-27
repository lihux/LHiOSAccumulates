//
//  LCDCSLogHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#ifndef LCDCSLogHelper_h
#define LCDCSLogHelper_h

#define LCDCS_REDIRECT_LOG_TO_FILE     NSString *logTempFile = [NSTemporaryDirectory() \
stringByAppendingPathComponent:@"lc_logtempFile"]; \
if ([[NSFileManager defaultManager] fileExistsAtPath:logTempFile]) { \
    NSError *error; \
    [[NSFileManager defaultManager] removeItemAtPath:logTempFile error:&error]; \
} \
FILE *logFile = freopen([logTempFile cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);

#define LCDCS_FINISH_FILE_LOG_AND_PRINT     fclose(logFile); \
printf("结束printf定向到文件"); \
NSError *error; \
NSString *logString = [NSString stringWithContentsOfFile:logTempFile encoding:NSNonLossyASCIIStringEncoding error:&error]; \
if (!error) { \
    [self log:logString]; \
}


#endif /* LCDCSLogHelper_h */

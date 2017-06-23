//
//  LCBShelfViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBShelfViewController.h"

#import "LCBookCoreDataManager.h"
#import "LCBShelfTableViewCell.h"

#import <AVFoundation/AVFoundation.h>

@interface LCBShelfViewController () <UITableViewDelegate, UITableViewDataSource, AVCaptureMetadataOutputObjectsDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) LCBookCoreDataManager *manager;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic, strong)AVCaptureSession *session;//输入输出的中间桥梁
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation LCBShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeLihuxStyleOfView:self.containerView];
    //300为正方形扫描区域边长
#if TARGET_OS_SIMULATOR
    [self startScanWithSize:300];
#else
    [self fetchBookInfoWithISBN:@"9787111453833"];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchBookInfoWithISBN:@"9787111453833"];
}

-(UIView *)logAnchorView {
    return self.containerView;
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.manager numberOfBooksInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCBShelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBShelfTableViewCell class])];
    cell.book = [self.manager bookForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark -- 开始扫描
- (void)startScanWithSize:(CGFloat)sizeValue {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input) {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        self.session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //设置为宽高为200的正方形区域相对于屏幕居中
        layer.frame = CGRectMake((self.view.bounds.size.width - sizeValue) / 2.0, (self.view.bounds.size.height - sizeValue) / 2.0, sizeValue, sizeValue);
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获图像:
        [_session startRunning];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
#pragma mark - 扫面结果在这个代理方法里获取到
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count>0) {
        //获取到信息后停止扫描:
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串:
        NSLog(@"%@", metaDataObject.stringValue);
        [self log:[NSString stringWithFormat:@"扫描成功，条形码为：%@", metaDataObject.stringValue]];
        [self log:@"下面开始用扫描出来的ISBN条形码数据去获取这本书的详细信息："];
        [self fetchBookInfoWithISBN:metaDataObject.stringValue];
        //移除扫描视图:
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
    }
}

- (void)fetchBookInfoWithISBN:(NSString *)ISBNString {
    NSString *temp = [NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/%@", ISBNString];
    NSURL *url = [NSURL URLWithString:temp];
    [[self.urlSession dataTaskWithURL:url] resume];
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    [self log:[NSString stringWithFormat:@"会话：%@收到了HTTPS 的challenge:\n%@，予以了正确处理，请求正确执行", session, challenge]];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (completionHandler) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSError *error;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        [self log:[NSString stringWithFormat:@"解析数据发生问题：%@", error]];
    } else {
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)jsonData;
            NSMutableString *string = [NSMutableString string];
            for (NSString *key in dic.allKeys) {
                [string appendFormat:@"\n%@ = %@", key, dic[key]];
            }
            NSLog(@"\n\n收到图书信息：%@", string);
            [self log:[NSString stringWithFormat:@"NSURLSessionDataDelegate-didReceiveData\n收到响应%@", string]];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    [self log:[NSString stringWithFormat:@"NSURLSessionTaskDelegate-didCompleteWithError\n%@%@%@", session, task, error]];
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self log:[NSString stringWithFormat:@"NSURLSessionDataDelegate-didReceiveResponse\n收到响应%@", response]];
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - lazy load
- (LCBookCoreDataManager *)manager {
    if (_manager) {
        return _manager;
    }
    _manager = [[LCBookCoreDataManager alloc] init];
    return _manager;
}

- (NSURLSession *)urlSession {
    if (_urlSession) {
        return _urlSession;
    }
    NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
    _urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    return _urlSession;
}

@end

//
//  LCBookScanViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookScanViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface LCBookScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, copy) LCBookScanCompletionBlock completionBlock;
@property(nonatomic, strong)AVCaptureSession *session;//输入输出的中间桥梁
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scanModelSegmentControl;

@end

@implementation LCBookScanViewController

+ (instancetype)scanWithCompletionBlock:(LCBookScanCompletionBlock)block {
    LCBookScanViewController *vc = [super loadViewControllerFromStoryboard:@"LCBookShelf"];
    vc.completionBlock = block;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if TARGET_OS_SIMULATOR
    [self finishScanWithResults:@[@"9787111453833"] error:nil];
#else
    [self startScanWithSize:300];
#endif
}

- (UIView *)logAnchorView {
    return self.containerView;
}

- (IBAction)segmentControlValueChange:(UISegmentedControl *)sender {
}

#pragma mark -
- (void)finishScanWithResults:(NSArray <NSString *> *)results error:(NSError *)error{
    if (self.completionBlock) {
        self.completionBlock(results, error);
    }
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
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        NSString *isbnString = metaDataObject.stringValue;
        [self log:[NSString stringWithFormat:@"扫描成功，条形码为：%@", isbnString]];
        //输出扫描字符串:
        if (self.scanModelSegmentControl.selectedSegmentIndex == 0) {
            //移除扫描视图:
            AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
            [layer removeFromSuperlayer];
            return;
        }
        [self.session startRunning];
    }
}

@end

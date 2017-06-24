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
@property (weak, nonatomic) IBOutlet UIView *scanLayerBackedView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scanModelSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *flyingLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyingViewStartConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *shoppingImageView;

@property (nonatomic, strong) NSMutableSet <NSString *> * results;

@end

@implementation LCBookScanViewController

+ (instancetype)scanWithCompletionBlock:(LCBookScanCompletionBlock)block {
    LCBookScanViewController *vc = [super loadViewControllerFromStoryboard:@"LCBookShelf"];
    vc.completionBlock = block;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.results = [NSMutableSet set];
    [self makeLihuxStyleOfView:self.containerView];
#if TARGET_OS_SIMULATOR
    [self finishScanWithISBN:@"9787111453833"];
#else
    [self startScan];
#endif
}

#pragma mark -
- (void)finishScanWithISBN:(NSString *)ISBN{
    if (self.completionBlock) {
        self.completionBlock(ISBN);
    }
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
}

- (void)addISBN:(NSString *)ISBNString {
    if (self.scanModelSegmentControl.selectedSegmentIndex == 0) {
        [self.results removeAllObjects];
        [self.results addObject:ISBNString];
        [self finishScanWithISBN:ISBNString];
        [self goBack];
        return;
    }
    if (![self.results containsObject:ISBNString]) {
        [self finishScanWithISBN:ISBNString];
        [self.results addObject:ISBNString];
        NSString *count = [NSString stringWithFormat:@"%zd", self.results.count];
        self.flyingLabel.text = count;
        [NSLayoutConstraint deactivateConstraints:self.flyingViewStartConstraints];
        [UIView animateWithDuration:0.8 animations:^{
            [self.view layoutIfNeeded];
            self.flyingLabel.alpha = 0.8;
        } completion:^(BOOL finished) {
            [NSLayoutConstraint activateConstraints:self.flyingViewStartConstraints];
            [self.view layoutIfNeeded];
            self.flyingLabel.alpha = 0;
            self.countLabel.text = count;
            [self.session startRunning];
        }];
    } else {
        [self.session startRunning];
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentControllerValueChanged:(UISegmentedControl *)sender {
    BOOL hidden = sender.selectedSegmentIndex == 0;
    self.shoppingImageView.hidden = hidden;
    self.countLabel.hidden = hidden;
    self.flyingLabel.hidden = hidden;
    NSInteger count = self.results.count;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", count];
    self.flyingLabel.text = [NSString stringWithFormat:@"%zd", count];
}

#pragma mark -- 开始扫描
- (void)startScan {
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
        layer.frame = self.scanLayerBackedView.bounds;
        [self.scanLayerBackedView.layer insertSublayer:layer atIndex:0];
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
        [self addISBN:isbnString];
    }
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self goBack];
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    [self cleanLog];
}

@end

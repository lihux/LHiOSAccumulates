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
#import "LCBookScanViewController.h"

@interface LCBShelfViewController () <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDataDelegate, LCBookCoreDataManagerDelegate>

@property (nonatomic, strong) LCBookCoreDataManager *manager;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSURLSession *urlSession;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LCBShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeLihuxStyleOfView:self.containerView];
    self.manager = [[LCBookCoreDataManager alloc] init];
    self.manager.delegate = self;
    [self.tableView reloadData];
}

- (UIView *)logAnchorView {
    return self.containerView;
}

- (NSString *)rightItemText {
    return @"录入图书";
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

- (void)fetchBookInfoWithISBN:(NSString *)ISBNString {
    LCBook *book = [self.manager bookForISBN:ISBNString];
    if ([self.manager bookForISBN:ISBNString]) {
        [self log:[NSString stringWithFormat:@"从本地数据库拿到了书籍信息：%@", book]];
    } else {
        NSString *temp = [NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/%@", ISBNString];
        NSURL *url = [NSURL URLWithString:temp];
        [[self.urlSession dataTaskWithURL:url] resume];
    }
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
            [self.manager inserNewBookFromJsonData:jsonData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    LCBookScanViewController *scanViewController = [LCBookScanViewController scanWithCompletionBlock:^(NSString *ISBN) {
        [self log:[NSString stringWithFormat:@"扫描获取的图书ISBN码为：%@", ISBN]];
    }];
    [self.navigationController pushViewController:scanViewController animated:YES];
    [self cleanLog];
}

#pragma mark - LCBookCoreDataManagerDelegate
-(void)dataHasChanged {
    [self.tableView reloadData];
}

#pragma mark - lazy load
- (NSURLSession *)urlSession {
    if (_urlSession) {
        return _urlSession;
    }
    NSURLSessionConfiguration *configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
    _urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    return _urlSession;
}

@end

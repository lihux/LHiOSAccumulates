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
#import "LCBookViewController.h"

#import <CoreData/CoreData.h>

@interface LCBShelfViewController () <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDataDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) LCBookCoreDataManager *manager;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSURLSession *urlSession;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchBookController;

@end

@implementation LCBShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[LCBookCoreDataManager alloc] init];
    self.fetchBookController = [self.manager fetchBookController];
    self.fetchBookController.delegate = self;
    [self.tableView reloadData];
}

#pragma mark - 子类继承设置
- (UIView *)lihuxStyleView {
    return self.containerView;
}

- (UIView *)logAnchorView {
    return self.containerView;
}

- (NSString *)rightItemText {
    return @"录入图书";
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchBookController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchBookController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCBShelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBShelfTableViewCell class])];
    cell.book = [self.manager bookForRowAtIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchBookController managedObjectContext];
        [context deleteObject:[self.fetchBookController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
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

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
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
        [self fetchBookInfoWithISBN:ISBN];
    }];
    [self.navigationController pushViewController:scanViewController animated:YES];
    [self cleanLog];
}

#pragma mark - LCBookCoreDataManagerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self log:@"controllerWillChangeContent"];
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    [self log:@"didChangeSection forChangeType"];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [self log:@"didChangeObject forChangeType"];
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            LCBShelfTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.book = anObject;
        }
            break;
            
        case NSFetchedResultsChangeMove: {
            LCBShelfTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.book = anObject;
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self log:@"controllerDidChangeContent forChangeType"];
    [self.tableView endUpdates];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBookDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LCBook *book = [self.fetchBookController objectAtIndexPath:indexPath];
        LCBookViewController *bookViewController = (LCBookViewController *)segue.destinationViewController;
        bookViewController.book = book;
    }
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

//
//  ViewController.m
//  断点续传尝试
//
//  Created by 张晓旭 on 2020/7/11.
//  Copyright © 2020 张晓旭. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downLoadTask;
@property (nonatomic, strong) NSOutputStream *movieStream;
@property (nonatomic, strong) UILabel *progress;
@property (nonatomic, strong)NSMutableData *mutableData;
@property (nonatomic, assign) bool isBreakPoint;//标志是意外退出或者是调用了cancelwithresumedata方法
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"aaa");
    // Do any additional setup after loading the view.
//    self.movieStream = [NSOutputStream outputStreamToFileAtPath:[self getPath] append:YES];
    NSLog(@"%daaaa",_isBreakPoint);
    //由于第一次进来需要调loadMoview方法，所以将_isBreakPoint设为yes
    _isBreakPoint = YES;
//    这里是关键，配置相同的session系统会去检测这个session是否之前是否因为意外中断了，如果检测到了会调用这个session的didCompleteWithError的代理方法，在这个方法中我们可以获得上次下载了多少data（这里需要后台支持range方式传递，并且只能是get方式，并且数据没发生变化）。然后拿到data后调用downloadtast的downloadTaskWithResumeData方法接着下载
    _sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"zxxSessionConfig"];
    self.session = [NSURLSession sessionWithConfiguration:_sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    self.mutableData = [NSMutableData data];
    [self makeSubViews];
//    [self loadMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willOut) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)willOut {
    NSLog(@"我进来了");
    NSLog(@"%@",self.downLoadTask);
    [self cancelDownTask];

    NSLog(@"我退出了");
}

- (void)cancelDownTask {
    [self.downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        //    不知道为啥进不来
        NSLog(@"111");
        [resumeData writeToFile:[self getPath] atomically:YES];
    }];
}

- (void)makeSubViews {
    self.progress = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.progress.textColor = [UIColor blackColor];
    [self.view addSubview:self.progress];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.selected = NO;
    btn.frame = CGRectMake(100, 500, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"开始/暂停" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction:(UIButton *)button {
    if (!button.selected) {
        if (_isBreakPoint) {
            [self loadMovie];
        } else {
            [self.downLoadTask resume];
        }
        NSLog(@"开始");
    } else {
        _isBreakPoint = NO;
        [self.downLoadTask suspend];
    }
    button.selected = !button.selected;
}

- (void)loadMovie {
    NSData *resumeData = [NSData dataWithContentsOfFile:[self getPath]];
    NSURL *requestUrl = [NSURL URLWithString:@"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4"];
    NSMutableURLRequest *downLoadRequest = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [downLoadRequest setHTTPMethod:@"GET"];
    if (resumeData) {
        self.downLoadTask = [self.session downloadTaskWithResumeData:resumeData];
//        [self.downLoadTask resume];
    } else {
        self.downLoadTask = [self.session downloadTaskWithRequest:downLoadRequest];
    }
//    0x600002ad08f0
//    0x600002ad0990
    NSLog(@"%@--%@",_downLoadTask.originalRequest,_downLoadTask.currentRequest);
    if (_downLoadTask.state != NSURLSessionTaskStateRunning) {
        [self.downLoadTask resume];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"111");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"%lld\n%lld\n%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    double progress = 100 *(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
    
    self.progress.text = [NSString stringWithFormat:@"%.2f",progress];
    NSLog(@"%@",[self getPath]);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"%@",location);
    NSData *data = [NSData dataWithContentsOfURL:location];
    [data writeToFile:[self getPath] atomically:YES];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSData *data = [error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
        NSLog(@"didCompleteWithError:%@",[error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"]);
        if (data) {
//            [data writeToFile:[self getPath] atomically:YES];
            _isBreakPoint = YES;
        }
    } else {
//        task.response
    }
    NSLog(@"%@",[self getPath]);
}

- (NSString *)getPath {
    NSArray *documentsPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",documentsPathArray);
    NSString *document = [documentsPathArray lastObject];
    NSLog(@"%@",document);
    NSString *path = [document stringByAppendingString:@"/zxxshipin.mp4"];
    return path;
}

@end

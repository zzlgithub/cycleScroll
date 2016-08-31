//
//  ViewController.m
//  07-图片无限循环滚动
//
//  Created by liuda065 on 16/7/8.
//  Copyright © 2016年 liuda065. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

#define KSCREENSIZE ([UIScreen mainScreen].bounds.size)  //屏幕尺寸
#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define imageW  300
#define imageH  130

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger rightIndex;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KSCREEN_WIDTH, self.view.height = KSCREEN_HEIGHT;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.width = 300, scrollView.height = 130;
    scrollView.center = self.view.center;
    scrollView.contentSize = CGSizeMake(300 * 3, 0);
    scrollView.contentOffset = CGPointMake(300, 0);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled= YES;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    self.leftIndex = 4;
    self.leftImageView.image = self.images[self.leftIndex];
    self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW, 0, imageW, imageH)];
    self.currentIndex = 0;
    self.currentImageView.image = self.images[self.currentIndex];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW * 2, 0, imageW, imageH)];
    self.rightIndex = 1;
    self.rightImageView.image = self.images[self.rightIndex];
    
    [scrollView addSubview:self.leftImageView];
    [scrollView addSubview:self.currentImageView];
    [scrollView addSubview:self.rightImageView];
    
    
    [self.view addSubview:self.pageControl];
    
    self.leftIndex = 4;
    self.currentIndex = 0;
    self.rightIndex = 1;
    [self startTimer];
    
    [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew context:nil];
//    scrollView.bounds
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;
    if (offset.x >= imageW * 2) { // 向左滑动
        self.leftIndex = self.currentIndex;
        self.currentIndex = self.rightIndex;
        self.rightIndex++;
        if (self.rightIndex == 5) {
            self.rightIndex = 0;
        }
        
        
    } else if (offset.x <= 0) {
        self.rightIndex = self.currentIndex;
        self.currentIndex = self.leftIndex;
        self.rightIndex--;
        if (self.leftIndex == -1) {
            self.leftIndex = 4;
        }
        
    } else {
        return;
    }
    
    self.leftImageView.image = self.images[self.leftIndex];
    self.currentImageView.image = self.images[self.currentIndex];
    self.rightImageView.image = self.images[self.rightIndex];
    self.pageControl.currentPage = self.currentIndex;
    self.scrollView.contentOffset = CGPointMake(imageW, 0);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)startTimer {   //如果只有一张图片，则直接返回，不开启定时器
    if (_images.count <= 1) return;   //如果定时器已开启，先停止再重新开启
    if (self.timer)
        [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage
{    //动画改变scrollview的偏移量就可以实现自动滚动
    
    CGFloat offsetX = imageW * 2;
    CGPoint offset = CGPointMake(offsetX, 0);
    
    // 动画
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)stopTimer
{
    // 停止定时器（一旦定时器被停止了，就不能再使用）
    [self.timer invalidate];
    self.timer = nil;
}

- (NSArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (NSInteger i = 1; i <= 5; i++) {
            NSString *name = [NSString stringWithFormat:@"img_0%ld", i];
            UIImage *image = [UIImage imageNamed:name];
            [_images addObject:image];
        }
    }
    return _images;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, self.scrollView.y + 100,_scrollView.width, 30);
        _pageControl.centerX = _scrollView.centerX;
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    
    return _pageControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  添加一个新的分支
 */

@end

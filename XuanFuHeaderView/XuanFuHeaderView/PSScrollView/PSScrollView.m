//
//  PSScrollView.m
//  LoopsSrollView
//
//  Created by pingsheng on 15/4/30.
//  Copyright (c) 2015年 pingsheng.zhao. All rights reserved.
//

#import "PSScrollView.h"
#import "UIImageView+WebCache.h"
#define kImageViewTag 100
@interface PSScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong)UIPageControl * pageControl;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UICollectionViewDidSelectItemAtIndexPathForRow callBack;
@property (nonatomic, assign)NSTimeInterval timeInterval;
@property (nonatomic, strong)NSString *placeholderImageName;
@property (nonatomic, assign)PSImageType imageType;
@end

@implementation PSScrollView

+ (instancetype)psScrollViewWithFrame:(CGRect)frame placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSTimeInterval)timeInterval completion:(UICollectionViewDidSelectItemAtIndexPathForRow)completion psImageType:(PSImageType)imageType{
    PSScrollView * psScrollView = [[PSScrollView alloc] initWithFrame:frame];
    psScrollView.placeholderImageName = placeholderImageName;
    psScrollView.imageType = imageType;
    psScrollView.callBack = completion;
    psScrollView.timeInterval = timeInterval;
    [psScrollView setupMainView];
    [psScrollView setupPageControl];
    psScrollView.imagesGroup = @[placeholderImageName];
    [psScrollView setupTimer];
    return psScrollView;
}

- (void)setImagesGroup:(NSArray *)imagesGroup{
    NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:imagesGroup];
    [mutableArray insertObject:[imagesGroup lastObject] atIndex:0];
    [mutableArray addObject:[imagesGroup firstObject]];
    _imagesGroup = [mutableArray copy];
    _pageControl.numberOfPages = _imagesGroup.count - 2;
    
    [_mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _mainView.contentSize = CGSizeMake(_mainView.frame.size.width * _imagesGroup.count, 0);
    for (int i = 0; i < _imagesGroup.count; i++) {
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapGesture:)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _mainView.frame.size.width, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = kImageViewTag + i;
        if (_imageType == PSImageLocal) {
            imageView.image = [UIImage imageNamed:_imagesGroup[i]];
        }else if (_imageType == PSImageUrl){
            [imageView sd_setImageWithURL:_imagesGroup[i] placeholderImage:[UIImage imageNamed:_placeholderImageName]];
        }
        [imageView addGestureRecognizer:tapGesture];
        [_mainView addSubview:imageView];
    }
    _mainView.contentOffset = CGPointMake(_mainView.frame.size.width, 0);
}

- (void)imageViewTapGesture:(UITapGestureRecognizer *)tap{
    UIImageView * tapView = (UIImageView *)tap.view;
    NSInteger index, tapViewTag = tapView.tag - kImageViewTag;
    if (tapViewTag == 0 || tapViewTag == _imagesGroup.count - 2) {
        index = _imagesGroup.count - 2;
    }if (tapViewTag == 1 || tapViewTag == _imagesGroup.count - 1) {
        index = 1;
    }else{
        index = tapViewTag;
    }
    if (_callBack) {
        _callBack(index);
    }
}

- (void)setupMainView {
    self.mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.pagingEnabled = YES;
    _mainView.delegate = self;
    [self addSubview:_mainView];
}

- (void)setupPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _mainView.frame.size.height - 20, _mainView.frame.size.width, 20)];
    _pageControl.numberOfPages = _imagesGroup.count - 2;
    _pageControl.backgroundColor = [UIColor blackColor];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.alpha = 0.5;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _mainView.frame = self.bounds;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if ((contentOffsetX / scrollView.frame.size.width) < 0 && contentOffsetX < scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(_mainView.frame.size.width * (_imagesGroup.count - 2), 0) animated:NO];
    }else if ((contentOffsetX / scrollView.frame.size.width) > _imagesGroup.count - 1 && contentOffsetX > scrollView.frame.size.width * (_imagesGroup.count - 1)) {
        [scrollView setContentOffset:CGPointMake(_mainView.frame.size.width, 0) animated:NO];
    }
    
    if (contentOffsetX == 0) {
        _pageControl.currentPage = _imagesGroup.count - 3;
    }else if (contentOffsetX == scrollView.frame.size.width * (_imagesGroup.count - 1)) {
        _pageControl.currentPage = 0;
    }else {
        _pageControl.currentPage = (contentOffsetX / scrollView.frame.size.width) - 1;
    }
}

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)automaticScroll {
    int currentIndex = _mainView.contentOffset.x / _mainView.frame.size.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _imagesGroup.count) {
        targetIndex = 2;
        [_mainView setContentOffset:CGPointMake(_mainView.frame.size.width, 0) animated:NO];
    }
    [_mainView setContentOffset:CGPointMake(_mainView.frame.size.width * targetIndex, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}
@end

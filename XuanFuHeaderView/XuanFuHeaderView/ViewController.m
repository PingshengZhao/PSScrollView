//
//  ViewController.m
//  XuanFuHeaderView
//
//  Created by pingsheng on 15/11/9.
//  Copyright © 2015年 pingsheng.zhao. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"
#import "PSScrollView.h"
#import "UINavigationBar+Awesome.h"
#import "BlocksKit.h"
#import "SDImageCache.h"
#define kHeaderViewHeight 200
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define NAVBAR_CHANGE_POINT -200
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (strong, nonatomic) MyView *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轮播图";
    /*
     仿appstore悬浮headerView效果，
     当tabView向下滑动的时候，顶部的headerView不动，
     当tabView向上滑动的时候，顶部的headerView在跟随tabView向上移动，
     PSScrollView是循环广告栏
     */
    [[SDImageCache sharedImageCache] clearDisk];
    
    self.headerView = [[MyView alloc] initWithFrame:CGRectMake(0, -kHeaderViewHeight, self.view.frame.size.width, kHeaderViewHeight)];
    _headerView.backgroundColor = [UIColor whiteColor];
    PSScrollView * psView = [PSScrollView psScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, _headerView.frame.size.height) placeholderImageName:@"qwer.jpg" timeInterval:5 completion:^(NSInteger index) {
        NSLog(@"你点击了弟%ld张图片", index);
    } psImageType:PSImageLocal];
    
//   [self bk_performBlock:^(id obj) {
//       psView.imagesGroup = @[@"http://images.jhrx.cn/attachment/forum/pw/Mon_1206/48_158056_6e7ad5b6cc4f406.jpg", @"http://img.pconline.com.cn/images/upload/upc/tx/itbbs/1309/17/c28/25794786_1379404775838_mthumb.jpg", @"http://www.bz55.com/uploads/allimg/150721/140-150H1142005.jpg", @"http://img8.zol.com.cn/bbs/upload/21102/21101929.jpg"];
//   } afterDelay:3];
    psView.imagesGroup = @[@"h1.jpg", @"h2.jpg", @"h3.jpg", @"h4.jpg"];
    [_headerView addSubview:psView];
    [_tabView addSubview:_headerView];
    _tabView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
    [_tabView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tabView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark KVC 回调
//本例设置headerView的最大高度为200
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (-offset.y >= kHeaderViewHeight + kNavigationBarHeight) {
            _headerView.frame = CGRectMake(0, offset.y + kNavigationBarHeight, self.view.frame.size.width, kHeaderViewHeight);
//            NSLog(@"%f  %f    %f", kNavigationBarHeight, offset.y, _tabView.frame.origin.y);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第几行%ld", indexPath.row];
    return cell;
}

@end

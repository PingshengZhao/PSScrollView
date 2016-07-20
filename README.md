# PSScrollView
![循环轮播](http://img.blog.csdn.net/20160720170445326)

## 安装PSScrollView
*Installation with CocoaPods：`pod 'PSScrollView'`

*注意PSScrollView为私有仓库需要在Podfile文件下面加上：`source 'https://github.com/PingshengZhao/PSScrollView.git'`

#使用
*导入`#import "PSScrollView.h"`

```
PSScrollView * psView = [PSScrollView psScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) placeholderImageName:@"qwer.jpg" timeInterval:5 completion:^(NSInteger index) {
        NSLog(@"你点击了弟%ld张图片", index);
    } psImageType:PSImageUrl];
/**psImageType:是一个枚举值； PSImageUrl表示轮播的图片为url资源，PSImageLocal表示为本地图片资源*/ 
psView.imagesGroup = @[@"http://url1",@"http://url2"];
psView.imagesGroup = @[@"本地图名字1",@"本地图名字2"];
[self.view addSubview:psView];

```

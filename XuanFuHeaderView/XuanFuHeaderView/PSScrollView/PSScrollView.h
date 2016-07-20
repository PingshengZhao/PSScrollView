//
//  PSScrollView.h
//  LoopsSrollView
//
//  Created by pingsheng on 15/4/30.
//  Copyright (c) 2015年 pingsheng.zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UICollectionViewDidSelectItemAtIndexPathForRow)(NSInteger index);
#define kScreeHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

typedef NS_ENUM(NSInteger, PSImageType) {
    PSImageLocal,
    PSImageUrl
};

@interface PSScrollView : UIView
@property (nonatomic, strong)NSArray * imagesGroup;
+ (instancetype)psScrollViewWithFrame:(CGRect)frame placeholderImageName:(NSString *)placeholderImageName timeInterval:(NSTimeInterval)timeInterval completion:(UICollectionViewDidSelectItemAtIndexPathForRow)completion psImageType:(PSImageType)imageType;
@end

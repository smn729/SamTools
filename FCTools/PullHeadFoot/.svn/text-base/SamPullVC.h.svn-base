//
//  SamPullVC.h
//  SamPullRefreshAndLoad
//
//  Created by Sam on 14-7-14.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SamCircleView.h"

@protocol SamPullDelegate;

@interface SamPullVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *targetTableView;
@property (nonatomic, weak) id<SamPullDelegate> delegate;
@property (nonatomic, strong) NSString *uniqueTimekey; // 用于保存时间信息的key，务必唯一

////////////////////////////////////// Optional Property //////////////////////////////////////////////

@property (nonatomic, strong, readonly) UIView *headView; // headView将会添加到targetTableView背后
@property (nonatomic, readonly) BOOL isHeadViewRefreshing;
@property (nonatomic, strong, readonly) NSDate *headViewLastUpdateDate;
@property (nonatomic, strong, readonly) NSString *headViewIntervalSinceLastUpdateString;
@property (nonatomic) float timeIntervalToNextRefresh; // 下次刷新间隔，间隔之内不会触发自动刷新;默认1分钟

// Foot View
@property (nonatomic, strong, readonly) UIView *footView; // footView将会添加到targetTableView的tableFootView
@property (nonatomic) NSUInteger footViewShoulAutoLoadTimes; // Default 3
@property (nonatomic, readonly) BOOL isFootViewRefreshing;

#pragma mark - Method

- (void)setup;

/**
 *  刷新完成后调用该方法，隐藏头部
 */
- (void)headViewUpdateDone;
- (void)headViewTriggeUpdateManualForce:(BOOL)isForce; // 主动调用更新，触发更新调用

- (void)footViewUpdateDoneHaveMoreData:(BOOL)moreData; // 是否有更多数据，关系到footVie刷新结束后的状态显示
- (void)footViewTriggeUpdateManual;

@end


#pragma mark - Protocol

@protocol SamPullDelegate <NSObject>

@required
- (void)headViewBeginUpdate:(SamPullVC *)pullVC;
- (void)footViewBeginUpdate:(SamPullVC *)pullVC;

@optional

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

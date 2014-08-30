//
//  SamPullVC.m
//  SamPullRefreshAndLoad
//
//  Created by Sam on 14-7-14.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import "SamPullVC.h"

#define PullHeadViewHeight              50.0f
#define PullHeadCirlceRadius            8.0f
#define PullHeadCircleTopMargin         10.0f
#define PullHeadTimeLabelToCircleBottom 4.0f
#define PullHeadTimeLabelWidth          100.0f
#define PullHeadTimeLabelHeight         10.0f
#define PullHeadPullTrigeCircleDelta    10.0f // 延迟绘制圆
#define SamPullHeadAnimateDuration      0.25

#define PullFootViewHeight              50.0f
#define PullFootViewIndicatorViewWidth  20.0f
#define PullFootViewIndicatorAndInfoLabelSpace 8.0f
#define PullFootViewAutoLoadTimes       3

@interface SamPullVC ()
{
    NSUInteger autoLoadTimes;
    BOOL isForceRefresh;
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSDate *headViewLastUpdateDate;
@property (nonatomic, strong) SamCircleView *headViewCircleView;
@property (nonatomic, strong) UILabel *headViewTimeLabel;
@property (nonatomic) BOOL isHeadViewRefreshing;
@property (nonatomic) BOOL isFootViewRefreshing;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *footViewInfoLabel;
@property (nonatomic, strong) UIActivityIndicatorView *footViewIndicatorView;
@property (nonatomic, strong) UIButton *footViewButton;
@property (nonatomic) BOOL isFootViewCanRequestMore;
//@property (nonatomic) NSUInteger footViewAutoLoadTimes;
@end




@implementation SamPullVC

#pragma mark - Wrapper

- (float)timeIntervalToNextRefresh
{
    if (_timeIntervalToNextRefresh == 0)
    {
        _timeIntervalToNextRefresh = 60.0;
    }
    
    return _timeIntervalToNextRefresh;
}

- (UIView *)headView
{
    if (_headView == nil)
    {
        CGRect frame = CGRectZero;
        frame.origin = self.targetTableView.frame.origin;
        frame.size.width = self.targetTableView.bounds.size.width;
        frame.size.height = PullHeadViewHeight;
        _headView = [[UIView alloc] initWithFrame:frame];
        _headView.backgroundColor = [UIColor clearColor];
        
        [_headView addSubview:self.headViewCircleView];
        [_headView addSubview:self.headViewTimeLabel];
    }
    
    return _headView;
}

- (UIView *)footView
{
    if (_footView == nil)
    {
        CGRect frame = CGRectZero;
        frame.origin = CGPointZero;
        frame.size.width = self.targetTableView.bounds.size.width;
        frame.size.height = PullFootViewHeight;
        
        _footView = [[UIView alloc] initWithFrame:frame];
//        _footView.backgroundColor = [UIColor clearColor];
        _footView.backgroundColor = [UIColor whiteColor];
        
        [_footView addSubview:self.footViewIndicatorView];
        [_footView addSubview:self.footViewInfoLabel];
        [_footView addSubview:self.footViewButton];
        
        self.isFootViewCanRequestMore = YES;
        if (self.footViewShoulAutoLoadTimes > 0)
		{
            autoLoadTimes = self.footViewShoulAutoLoadTimes;
        }
        else
        {
            self.footViewShoulAutoLoadTimes = PullFootViewAutoLoadTimes;
        }
    }
    
    return _footView;
}

- (void)setFootViewShoulAutoLoadTimes:(NSUInteger)footViewShoulAutoLoadTimes
{
    _footViewShoulAutoLoadTimes = footViewShoulAutoLoadTimes;
    autoLoadTimes = footViewShoulAutoLoadTimes;
}

- (UIButton *)footViewButton
{
    if (_footViewButton == nil)
    {
        CGRect frame = CGRectZero;
        frame.origin = CGPointZero;
        frame.size.width = self.targetTableView.bounds.size.width;
        frame.size.height = PullFootViewHeight;
        
        _footViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footViewButton.frame = frame;
        [_footViewButton addTarget:self action:@selector(footViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _footViewButton;
}

- (UIActivityIndicatorView *)footViewIndicatorView
{
    if (_footViewIndicatorView == nil)
    {
        _footViewIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _footViewIndicatorView.frame = CGRectMake(0, 0, PullFootViewIndicatorViewWidth, PullFootViewIndicatorViewWidth);
        _footViewIndicatorView.hidesWhenStopped = YES;
    }
    
    return _footViewIndicatorView;
}

- (UILabel *)footViewInfoLabel
{
    if (_footViewInfoLabel == nil)
    {
        _footViewInfoLabel = [[UILabel alloc] init];
        _footViewInfoLabel.backgroundColor = [UIColor clearColor];
        _footViewInfoLabel.font = [UIFont systemFontOfSize:15];
        _footViewInfoLabel.textColor = [UIColor darkGrayColor];
        _footViewInfoLabel.textAlignment = NSTextAlignmentCenter;
        _footViewInfoLabel.frame = CGRectZero;
    }
    
    return _footViewInfoLabel;
}

- (SamCircleView *)headViewCircleView
{
    if (_headViewCircleView == nil)
    {
        CGRect frame = CGRectZero;
        frame.origin.x = (self.headView.bounds.size.width - 2 * PullHeadCirlceRadius) / 2.0f;
        frame.origin.y = PullHeadCircleTopMargin;
        frame.size.width = 2 * PullHeadCirlceRadius;
        frame.size.height = 2 * PullHeadCirlceRadius;
        
        _headViewCircleView = [[SamCircleView alloc] initWithFrame:frame];
        
        _headViewCircleView.shouldFill = NO;
        _headViewCircleView.endDegrees = 320.0f;
        _headViewCircleView.progress = 0.5;
        _headViewCircleView.lineWidth = 1.2f;
        
    }
    
    return _headViewCircleView;
}

- (UILabel *)headViewTimeLabel
{
    if (_headViewTimeLabel == nil)
    {
        CGRect frame = CGRectZero;
        frame.origin.x = (self.headView.bounds.size.width - PullHeadTimeLabelWidth) / 2.0f;
        frame.origin.y = PullHeadCircleTopMargin + 2 * PullHeadCirlceRadius + PullHeadTimeLabelToCircleBottom;
        frame.size.width = PullHeadTimeLabelWidth;
        frame.size.height = PullHeadTimeLabelHeight;
        
        _headViewTimeLabel = [[UILabel alloc] initWithFrame:frame];
        
        _headViewTimeLabel.textColor = [UIColor darkGrayColor];
        _headViewTimeLabel.backgroundColor = [UIColor clearColor];
        _headViewTimeLabel.textAlignment = NSTextAlignmentCenter;
        _headViewTimeLabel.font = [UIFont systemFontOfSize:9];
        _headViewTimeLabel.text = @"上次刷新：从未";
        
    }
    
    return _headViewTimeLabel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)dealloc
{
    [self cleanup];
}


#pragma mark - Public Method

- (void)setup
{
    if (![self.targetTableView isKindOfClass:[UITableView class]])
    {
        NSLog(@"PULL HEAD VIEW WILL \"ONLY\" WORK WITH UITableView !!!");
        return;
    }
    
    [self cleanup];
    
    self.targetTableView.backgroundColor = [UIColor clearColor];
    ((UIScrollView *)self.targetTableView).delegate = self;
    
    // Add HeadView
    UIView *headSuperView = self.targetTableView.superview;
    if (headSuperView)
    {
        [headSuperView insertSubview:self.headView belowSubview:self.targetTableView];
    }
    
    // Add FootView
    self.targetTableView.tableFooterView = self.footView;
    
    [self footViewStateShowMore];
}

- (void)headViewUpdateDone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endUpdate];
        [self renewUpdateTime];
        autoLoadTimes = self.footViewShoulAutoLoadTimes;
    });
}

- (void)headViewTriggeUpdateManualForce:(BOOL)isForce
{
    isForceRefresh = isForce;
    if (!isForce)
    {
        float timeInterval = [[self getLastUpdateTime] timeIntervalSinceNow];
        timeInterval = fabsf(timeInterval);
        if (timeInterval < self.timeIntervalToNextRefresh && timeInterval > 0)
        {
            NSLog(@"刷新间隔不足一分钟, 不触发自动刷新");
            return;
        }
    }
    
    if ([self.targetTableView isKindOfClass:[UITableView class]])
    {
        [UIView animateWithDuration:SamPullHeadAnimateDuration animations:^{
            [self.targetTableView setContentOffset:CGPointMake(0, -PullHeadViewHeight)];
        } completion:^(BOOL finished)
         {
             if (finished)
             {
                 [self scrollViewDidEndDragging:self.targetTableView willDecelerate:YES];
             }
         }];
    }
}

- (void)footViewUpdateDoneHaveMoreData:(BOOL)moreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.isFootViewRefreshing = NO;
        self.isFootViewCanRequestMore = moreData;
        
        if (moreData)
        {
            [self footViewStateShowMore];
        }
        else
        {
            [self footViewStateNoMore];
        }
    });
}

- (void)footViewTriggeUpdateManual
{
    [self triggerFootViewRefresh];
}

#pragma mark - Private Method

// 刷新timeLabel
- (void)renewUpdateTimeLabel
{
    if (!self.uniqueTimekey)
    {
        NSLog(@"Pull Head View Got No \"uniqueTimekey\" !!!");
        return;
    }
    
    NSDate *headViewLastUpdateDate = [self getLastUpdateTime];
    NSTimeInterval deltaTime = fabs([headViewLastUpdateDate timeIntervalSinceNow]);
    NSString *text = [self transIntervelToString:deltaTime];
    
    self.headViewTimeLabel.text = text;
}

// 保存当前更新时间
- (void)renewUpdateTime
{
    if (self.uniqueTimekey)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:self.uniqueTimekey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 获取上次刷新时间
- (NSDate *)getLastUpdateTime
{
    NSDate *headViewLastUpdateDate = nil;
    if (self.uniqueTimekey)
    {
        headViewLastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.uniqueTimekey];
    }
    
    return headViewLastUpdateDate;
}

#define Sam_TimeIntervel_Minute     60.0
#define Sam_TimeIntervel_Hour       (60.0 * 60.0)
#define Sam_TimeIntervel_Day        (24.0 * 60.0 * 60.0)
#define Sam_TimeIntervel_Mouth      (30 * 24.0 * 60.0 * 60.0)
#define Sam_TimeIntervel_Year       (12 * 30 * 24.0 * 60.0 * 60.0)

// 将时间转换为至今间隔字符串
- (NSString *)transIntervelToString:(NSTimeInterval)intervel
{
    NSString *result = nil;
    if (intervel <= 0)
    {
        result = @"上次刷新：从未";
    }
    else if (intervel <= Sam_TimeIntervel_Minute)
    {
        result = @"上次刷新：刚刚";
    }
    else if (intervel <= Sam_TimeIntervel_Hour)
    {
        int num = intervel / Sam_TimeIntervel_Minute;
        result = [NSString stringWithFormat:@"上次刷新：%d分钟前", num];
    }
    else if (intervel <= Sam_TimeIntervel_Day)
    {
        int num = intervel / Sam_TimeIntervel_Hour;
        result = [NSString stringWithFormat:@"上次刷新：%d小时前", num];
    }
    else if (intervel <= Sam_TimeIntervel_Mouth)
    {
        int num = intervel / Sam_TimeIntervel_Day;
        result = [NSString stringWithFormat:@"上次刷新：%d天前", num];
    }
    else if (intervel <= Sam_TimeIntervel_Year)
    {
        int num = intervel / Sam_TimeIntervel_Mouth;
        result = [NSString stringWithFormat:@"上次刷新：%d个月前", num];
    }
    else
    {
        result = [NSString stringWithFormat:@"上次刷新：很久很久以前"];
    }
    
    return result;
}



- (void)cleanup
{
    [self.headView removeFromSuperview];
    [self.footView removeFromSuperview];
    self.headView = nil;
    self.footView = nil;
    
    self.headViewLastUpdateDate = nil;
    self.headViewCircleView = nil;
    self.headViewTimeLabel = nil;
}

// 开启刷新状态
- (void)beginUpdate
{
    if (self.isHeadViewRefreshing && !isForceRefresh)
    {
        NSLog(@"Head View is refreshing !!!");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(headViewBeginUpdate:)])
    {
        [UIView animateWithDuration:SamPullHeadAnimateDuration animations:^{
            self.targetTableView.contentInset = UIEdgeInsetsMake(PullHeadViewHeight, 0, 0, 0);
            [self.headViewCircleView startRotate];

        } completion:^(BOOL finished) {
            if (finished)
            {
                self.isHeadViewRefreshing = YES;
                [self.delegate headViewBeginUpdate:self];
            }
        }];
    }
    else
    {
        NSLog(@"PullHeadView beginUpdate: Error!!!");
    }
}

// 结束刷新状态
- (void)endUpdate
{
    [UIView animateWithDuration:SamPullHeadAnimateDuration animations:^{
        [self.targetTableView setContentInset:UIEdgeInsetsZero];
    } completion:^(BOOL finished) {
        if (finished)
		{
            [self.headViewCircleView stopRotate];
            self.isHeadViewRefreshing = NO;
        }
    }];
}

- (void)footViewButtonClick:(UIButton *)sender
{
    NSLog(@"footViewButtonClick");
    [self triggerFootViewRefresh];
}

- (void)footViewStateShowMore
{
    [self.footViewIndicatorView stopAnimating];
    self.footViewButton.enabled = YES;
    
    CGRect labelFrame = CGRectZero;
    
    self.footViewInfoLabel.text = @"显示更多";
    [self.footViewInfoLabel sizeToFit];
    
    labelFrame.size = self.footViewInfoLabel.bounds.size;
    labelFrame.origin.x = (self.targetTableView.bounds.size.width - self.footViewInfoLabel.bounds.size.width) / 2.0f;
    labelFrame.origin.y = (PullFootViewHeight - self.footViewInfoLabel.bounds.size.height) / 2.0f;
    
    self.footViewInfoLabel.frame = labelFrame;
    
}

- (void)footViewStateNoMore
{
    [self.footViewIndicatorView stopAnimating];
    self.footViewButton.enabled = NO;
    
    CGRect labelFrame = CGRectZero;
    
    self.footViewInfoLabel.text = @"没有更多内容了";
    [self.footViewInfoLabel sizeToFit];
    
    labelFrame.size = self.footViewInfoLabel.bounds.size;
    labelFrame.origin.x = (self.targetTableView.bounds.size.width - self.footViewInfoLabel.bounds.size.width) / 2.0f;
    labelFrame.origin.y = (PullFootViewHeight - self.footViewInfoLabel.bounds.size.height) / 2.0f;
    
    self.footViewInfoLabel.frame = labelFrame;
}

- (void)footViewStateLoading
{
    [self.footViewIndicatorView startAnimating];
    self.footViewButton.enabled = NO;
    
    CGRect labelFrame = CGRectZero;
    
    self.footViewInfoLabel.text = @"正在载入";
    [self.footViewInfoLabel sizeToFit];
    
    labelFrame.size = self.footViewInfoLabel.bounds.size;
    labelFrame.origin.x = (self.targetTableView.bounds.size.width - self.footViewInfoLabel.bounds.size.width) / 2.0f;
    labelFrame.origin.y = (PullFootViewHeight - self.footViewInfoLabel.bounds.size.height) / 2.0f;
    
    self.footViewInfoLabel.frame = labelFrame;
    
    CGRect indicatorFrame = CGRectZero;
    indicatorFrame.origin.x = self.footViewInfoLabel.frame.origin.x - PullFootViewIndicatorViewWidth - PullFootViewIndicatorAndInfoLabelSpace;
    indicatorFrame.origin.y = (PullFootViewHeight - PullFootViewIndicatorViewWidth) / 2.0f;
    indicatorFrame.size.width = PullFootViewIndicatorViewWidth;
    indicatorFrame.size.height = PullFootViewIndicatorViewWidth;
    
    self.footViewIndicatorView.frame = indicatorFrame;
}

// 触发footView的刷新
- (void)triggerFootViewRefresh
{
    if (self.isFootViewRefreshing)
    {
//        NSLog(@"Foot View is Refresh alread!");
        return;
    }
    
    if (!self.isFootViewCanRequestMore)
    {
//        NSLog(@"Foot View Have No More Data To Request!");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(footViewBeginUpdate:)])
    {
        [self.delegate footViewBeginUpdate:self];
        self.isFootViewRefreshing = YES;
        [self footViewStateLoading];
        
        autoLoadTimes = autoLoadTimes > 0 ? (autoLoadTimes - 1) : 0;
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    // Foot View
    CGFloat distenceTouchEnd = scrollView.contentSize.height - self.targetTableView.bounds.size.height - currentOffsetY;
    distenceTouchEnd = distenceTouchEnd < 0 ? 0 : distenceTouchEnd;
    if (autoLoadTimes > 0 && distenceTouchEnd < PullFootViewHeight && scrollView.contentSize.height > self.targetTableView.bounds.size.height)
    {
        [self triggerFootViewRefresh];
    }
    
    // Head View
    if (currentOffsetY >= 0)
    {
        return;
    }
    
    if (!self.isHeadViewRefreshing)
    {
        currentOffsetY = fabsf(currentOffsetY);
        self.headViewCircleView.progress = (currentOffsetY - PullHeadPullTrigeCircleDelta) / (PullHeadViewHeight - PullHeadPullTrigeCircleDelta);
        [self renewUpdateTimeLabel];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO || scrollView.contentOffset.y >= 0)
    {
        return;
    }
    
    CGFloat offsetY = fabsf(scrollView.contentOffset.y);
    if (offsetY >= PullHeadViewHeight)
    {
        isForceRefresh = YES;
        [self beginUpdate];
    }
}









@end

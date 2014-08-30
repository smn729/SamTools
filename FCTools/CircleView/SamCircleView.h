//
//  SamCircleView.h
//  SamCircleView
//
//  Created by Sam on 14-7-10.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIAN(degrees)      ((degrees) * M_PI / 180.0f)
#define RADIAN_TO_DEGREES(radian)       ((radian) * 180.0f / M_PI)

#define SamCircleAnimateDuration       1.0f

@interface SamCircleView : UIView

@property (nonatomic) float progress;               // 0 - 1

- (UIImage *)getCurrrentImage;

- (void)startRotate;
- (void)stopRotate;

// Optional
@property (nonatomic) BOOL shouldFill;              // Detault YES
@property (nonatomic) float lineWidth;              // Default 2.0f
@property (nonatomic) float startDegrees;           // Default 0.0f (Center Top)
@property (nonatomic) float endDegrees;             // Default 360.0f
@property (nonatomic, strong) UIColor *lineColor;   // Default red
@property (nonatomic, strong) UIColor *fillColor;   // Default red

@end

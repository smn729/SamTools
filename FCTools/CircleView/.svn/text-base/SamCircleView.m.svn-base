//
//  SamCircleView.m
//  SamCircleView
//
//  Created by Sam on 14-7-10.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import "SamCircleView.h"

@interface SamCircleView()
{
    CGFloat circleCenterX;
    CGFloat circleCenterY;
    CGFloat circleRadius;
    CGFloat circleStartRadian;
    CGFloat circleEndRadian;
}


@end

static NSString *CircleRotateKey = @"kCircleRotete";

@implementation SamCircleView

- (void)setStartDegrees:(float)startDegrees
{
    _startDegrees = startDegrees - 90.0f;
}

- (void)setEndDegrees:(float)endDegrees
{
    _endDegrees = endDegrees - 90.0f + 1.5f;
}

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"progress"];
}

- (void)drawRect:(CGRect)rect
{
//    NSLog(@"drawRect Circle");
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawTheViewWithContext:context];
}

#pragma mark - Public Method

- (UIImage *)getCurrrentImage
{
    UIImage *image = nil;

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawTheViewWithContext:context];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)startRotate
{
    [self stopRotate];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2];
    rotationAnimation.duration = SamCircleAnimateDuration;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.layer addAnimation:rotationAnimation forKey:CircleRotateKey];

}

- (void)stopRotate
{
    [self.layer removeAllAnimations];
}

#pragma mark - Private Method

- (void)setup
{
    [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    self.shouldFill = YES;
    self.lineWidth = 2.0f;
    self.startDegrees = 0.0f;
    self.endDegrees = 360.0f;
    self.lineColor = [UIColor redColor];
    self.fillColor = [UIColor redColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"])
    {
//        NSLog(@"progress %f", self.progress);
        if (self.progress > 1)
		{
            self.progress = 1;
        }
        else if (self.progress < 0)
        {
            self.progress = 0;
        }
        [self setNeedsDisplay];
    }
}

- (void)drawCircleWithContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    circleStartRadian = DEGREES_TO_RADIAN(self.startDegrees);
    circleEndRadian = DEGREES_TO_RADIAN(self.progress * (self.endDegrees - self.startDegrees) + self.startDegrees);
    circleRadius  = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    circleRadius = circleRadius / 2.0f - (self.lineWidth / 2.0f);

    circleCenterX = self.bounds.size.width / 2.0f;
    circleCenterY = self.bounds.size.height / 2.0f;
    
    CGContextAddArc(context, circleCenterX, circleCenterY, circleRadius, circleStartRadian, circleEndRadian, 0);
    
    UIGraphicsPopContext();
}

- (void)drawCircleBeginLineWithContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGFloat centerX = self.bounds.size.width / 2.0f;
    CGFloat centerY = self.bounds.size.height / 2.0f;
    CGContextMoveToPoint(context, centerX, centerY);
    CGContextAddLineToPoint(context, centerX, 0);
        
    UIGraphicsPopContext();
}

- (void)drawTheViewWithContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGFloat centerX = self.bounds.size.width / 2.0f;
    CGFloat centerY = self.bounds.size.height / 2.0f;
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if (self.shouldFill)
    {
        CGFloat lineWidth = 1.0f;
        CGContextSetLineWidth(context, lineWidth);

        
        [self drawCircleBeginLineWithContext:context];
//        [self drawCircleWithContext:context];
//        CGContextClosePath(context);
        
        
        
        
        
        
        
        
//        // Begin Line

//        CGContextMoveToPoint(context, centerX, centerY);
//        CGContextAddLineToPoint(context, centerX, 0);
        
        //Circle
        circleStartRadian = DEGREES_TO_RADIAN(self.startDegrees);
        circleEndRadian = DEGREES_TO_RADIAN(self.progress * (self.endDegrees - self.startDegrees) + self.startDegrees);
        circleRadius  = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
        circleRadius = circleRadius / 2.0f - (lineWidth / 2.0f);
        circleCenterX = self.bounds.size.width / 2.0f;
        circleCenterY = self.bounds.size.height / 2.0f;
        CGContextAddArc(context, centerX, centerY, circleRadius, circleStartRadian, circleEndRadian, 0);
        
        // End Line
        CGContextAddLineToPoint(context, self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
        
        
        
        
        
        
        
        
        
        
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else
    {
        [self drawCircleWithContext:context];
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    UIGraphicsPopContext();

}





@end

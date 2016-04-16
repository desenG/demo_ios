//
//  CircularProgressTimer.m
//  CircularProgressTimer
//
//  Created by mc on 6/30/13.
//  Copyright (c) 2013 mauricio. All rights reserved.
//

#import "CircularProgressTimer.h"

@implementation CircularProgressTimer

@synthesize instanceColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setup];
    }
    
    return self;
}

- (void) drawRectCheckedInCircleFrame: (CGRect) circleFrame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* checkmarkBlue2 = [UIColor blackColor];
    
    //// Shadow Declarations
    UIColor* shadow2 = [UIColor blackColor];
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 2.5;
    
    //// Frames
    CGRect frame = circleFrame;
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + 3, CGRectGetMinY(frame) + 3, CGRectGetWidth(frame) - 6, CGRectGetHeight(frame) - 6);
    
    
    //// Group
    {
        //// CheckedOval Drawing
        UIBezierPath* checkedOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.00000 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.5) - floor(CGRectGetWidth(group) * 0.00000 + 0.5), floor(CGRectGetHeight(group) * 1.00000 + 0.5) - floor(CGRectGetHeight(group) * 0.00000 + 0.5))];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
        [checkmarkBlue2 setFill];
        [checkedOvalPath fill];
        CGContextRestoreGState(context);
        
        [[UIColor whiteColor] setStroke];
        checkedOvalPath.lineWidth = 1;
        [checkedOvalPath stroke];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.27083 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.54167 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.41667 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.68750 * CGRectGetHeight(group))];
        [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.75000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.35417 * CGRectGetHeight(group))];
        bezierPath.lineCapStyle = kCGLineCapSquare;
        
        [[UIColor whiteColor] setStroke];
        bezierPath.lineWidth = 1.3;
        [bezierPath stroke];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawCircleInFrame:rect withCircleRadius:40];
}

- (void)drawCircleInFrame:(CGRect)containerframe
          withCircleRadius:(int)circleRadius
{
    float half_w_container=containerframe.size.width/2;
    float half_h_container=containerframe.size.height/2;
    
    // Allowing to change the circle color at runtime
    UIColor *color;
    if (!instanceColor) {
        color = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    } else {
        color = instanceColor;
    }
    
    float initialAngleFactor = 1.5 * M_PI;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(containerframe.size.width / 2, containerframe.size.height / 2)
                          radius:circleRadius
                      startAngle:0 + initialAngleFactor
                        endAngle:(_percent * M_PI) / 30.0 + initialAngleFactor
                       clockwise:YES];
    
    if(_minutesLeft==0 && _secondsLeft==0)
    {
       [self drawRectCheckedInCircleFrame:CGRectMake(half_w_container-circleRadius, half_h_container-circleRadius, circleRadius*2, circleRadius*2)];
        
        UILabel *postLabel = [UILabel new];
        [postLabel setFrame:CGRectMake(0,half_h_container+circleRadius,containerframe.size.width, 14)];
        [postLabel setBackgroundColor:[UIColor clearColor]];
        [postLabel setTextColor:[UIColor whiteColor]];
        [postLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:12]];
        [postLabel setText:@"Posted"];
        [postLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:postLabel];
    }
    else{
        bezierPath.lineWidth = 1.3;
        [[UIColor whiteColor] setStroke];
        [bezierPath stroke];
    }
}

- (void)setup
{
    UIImageView *circularBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    circularBackground.image = [UIImage imageNamed:@"circle"];
    [self addSubview:circularBackground];
}

@end

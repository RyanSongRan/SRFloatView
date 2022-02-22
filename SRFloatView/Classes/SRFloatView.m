//
//  SRFloatView.m
//  SRFloatView
//
//  Created by iOS Developer on 2022/2/21.
//

#import "SRFloatView.h"

@interface SRFloatView ()

@property (nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation SRFloatView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    
    return self;
}

#pragma mark - Responder

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGFloat containerWidth = CGRectGetWidth(self.superview.frame);
    CGFloat containerHeight = CGRectGetHeight(self.superview.frame);
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGestureRecognizer translationInView:self];
            CGRect newFrame = self.frame;
            newFrame.origin.x = self.frame.origin.x + translation.x;
            newFrame.origin.y = self.frame.origin.y + translation.y;
            
            if (self.crossingBounds == NO) {
                newFrame.origin.x = MIN(newFrame.origin.x, containerWidth - CGRectGetWidth(self.frame));
                newFrame.origin.x = MAX(newFrame.origin.x, 0);
                newFrame.origin.y = MIN(newFrame.origin.y, containerHeight - CGRectGetHeight(self.frame));
                newFrame.origin.y = MAX(newFrame.origin.y, 0);
            }
            
            self.frame = newFrame;
            [panGestureRecognizer setTranslation:CGPointZero inView:self];
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.edgeAdsorption) {
                CGFloat mininumSpace = MAX(containerWidth, containerHeight);
                CGRect frame = self.frame;
                
                if ((self.supportedEdge & SRFloatViewEdge_Left) && CGRectGetMinX(self.frame) < mininumSpace) {
                    mininumSpace = CGRectGetMinX(self.frame);
                    frame = self.frame;
                    frame.origin.x = 0;
                }
                
                if ((self.supportedEdge & SRFloatViewEdge_Right) && containerWidth - CGRectGetMaxX(self.frame) < mininumSpace) {
                    mininumSpace = containerWidth - CGRectGetMaxX(self.frame);
                    frame = self.frame;
                    frame.origin.x = containerWidth - CGRectGetWidth(self.frame);
                }
                
                if ((self.supportedEdge & SRFloatViewEdge_Top) && CGRectGetMinY(self.frame) < mininumSpace) {
                    mininumSpace = CGRectGetMinY(self.frame);
                    frame = self.frame;
                    frame.origin.y = 0;
                }
                
                if ((self.supportedEdge & SRFloatViewEdge_Bottom) && containerHeight - CGRectGetMaxY(self.frame) < mininumSpace) {
                    mininumSpace = containerHeight - CGRectGetMaxY(self.frame);
                    frame = self.frame;
                    frame.origin.y = containerHeight - CGRectGetHeight(self.frame);
                }
                
                if (CGPointEqualToPoint(self.frame.origin, frame.origin) == NO) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = frame;
                    }];
                }
            }

            if (self.delegate && [self.delegate respondsToSelector:@selector(floatViewDidEndDragging:)]) {
                [self.delegate floatViewDidEndDragging:self];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Private

- (void)initialize {
    self.crossingBounds = NO;
    self.edgeAdsorption = YES;
    self.supportedEdge = SRFloatViewEdge_Left | SRFloatViewEdge_Right;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self addGestureRecognizer:panGestureRecognizer];
    self.panGestureRecognizer = panGestureRecognizer;
}

@end

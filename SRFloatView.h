//
//  SRFloatView.h
//  SRFloatView
//
//  Created by iOS Developer on 2022/2/21.
//

#import <UIKit/UIKit.h>
@protocol SRFloatViewDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, SRFloatViewEdge) {
    SRFloatViewEdge_Left = 1,
    SRFloatViewEdge_Right = 1 << 1,
    SRFloatViewEdge_Top = 1 << 2,
    SRFloatViewEdge_Bottom = 1 << 3,
};

/// 一个可拖动的浮动视图。
@interface SRFloatView : UIView

@property (nonatomic, weak) id<SRFloatViewDelegate> delegate;
/// 拖动手势。
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
/// 可拖动超出父视图的边界。默认为 NO。
@property (nonatomic) BOOL crossingBounds;
/// 拖动结束时，吸附到父视图边界。默认为 YES。
@property (nonatomic) BOOL edgeAdsorption;
/// 可吸附到父视图边界时，支持的边，最终吸附时，选择距离最近的一条边。默认为横向两条边。
@property (nonatomic) SRFloatViewEdge supportedEdge;

@end

@protocol SRFloatViewDelegate <NSObject>

@optional;
- (void)floatViewDidEndDragging:(SRFloatView *)floatView;

@end

NS_ASSUME_NONNULL_END

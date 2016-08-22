//
//  TimeScrollView.h
//  框架
//
//  Created by wzp on 16/4/13.
//  Copyright © 2016年 wzp. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    NonAutomaticScrollStyle,    //非自动滚动  默认
    AutomaticScrollStyle        //自动滚动

}Scrollstyle;//滚动模式

typedef enum {
    
    LeftDirection,              //向左   默认
    RightDirection              //向右
    
}ScrollDirectionStyle;//滚动方向



@interface TimeScrollView : UIView
{
    NSInteger imageCount;       //源数据的元素个数

}

/** 滚动方向 */
@property(nonatomic)ScrollDirectionStyle scrollDirectionStyle;
/** 滚动类型 */
@property(nonatomic)Scrollstyle scrollstyle;




/** 初始化方法 
 *  imagesArr 图片数组,数组元素为UIImage * image
 */
- (instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imagesArr;

/** 更新图片的方法 
 *  imagesArr 图片数组,数组元素为UIImage * image
 */
- (void)reloadDataWithImagesArr:(NSArray*)imagesArr;

/** 开始滚动 
 *  timeInterval 滚动的时间间隔,设置2秒效果最好,调用此方法后1秒后开始滚动
                 滚动动画的执行时间为 timeInterval/2
 */
- (void)beginScrollWithDuration:(NSTimeInterval)timeInterval;

/** 停止滚动 */
- (void)stopScroll;

/** 继续滚动 */
- (void)continueScroll;

/** 添加页面控制器 */
- (void)addPageControl;

@end

# cycleScrollView
轮播图(自动轮播和非自动轮播可选,可设置自动轮播的速度，滚动方向，可暂停，继续)

使用方法


导入头文件  #import "TimeScrollView.h"


需要设置self.automaticallyAdjustsScrollViewInsets=NO;否则图片位置会出错

需要设置self.automaticallyAdjustsScrollViewInsets=NO;否则图片位置会出错

需要设置self.automaticallyAdjustsScrollViewInsets=NO;否则图片位置会出错

重要的事情说三遍


创建对象  需要准备好图片数组,该数组内元素为 UIImage 类型的对象
- (instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imagesArr;

刷新图片
- (void)reloadDataWithImagesArr:(NSArray*)imagesArr;


自动滚动需要以下设置

设置自动滚动或非自动滚动
scrollstyle属性  AutomaticScrollStyle为自动滚动,默认手动

设置滚动方向(左或右)
scrollDirectionStyle属性  RightDirection 为向右滚,默认向左滚

设置滚动时间间隔并在一秒后开始滚动
- (void)beginScrollWithDuration:(NSTimeInterval)timeInterval;

停止滚动
- (void)stopScroll;

继续滚动,注意如果不调用beginScrollWithDuration方法,那么此方法无效
- (void)continueScroll;


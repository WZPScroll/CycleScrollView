//
//  TimeScrollView.m
//  框架
//
//  Created by wzp on 16/4/13.
//  Copyright © 2016年 wzp. All rights reserved.
//

#import "TimeScrollView.h"




#define TSWidth self.frame.size.width
#define TSHeight self.frame.size.height



@interface TimeScrollView ()<UIScrollViewDelegate>
{
    NSInteger currentNum;//当前图片的原位置
}

/** 计时器 */
@property(nonatomic,strong)NSTimer * timer;
/** 时间间隔 */
@property(nonatomic,assign)NSTimeInterval timeInterval;
/** 最底层的滚动视图 */
@property(nonatomic,strong)UIScrollView * mainView;
/** 上一张图片 */
@property(nonatomic,strong)UIImageView * lastImage;
/** 当前的图片 */
@property(nonatomic,strong)UIImageView * currentImage;
/** 下一张图片 */
@property(nonatomic,strong)UIImageView * nextImage;
/** 提示信息 */
@property(nonatomic,strong)UILabel * messageLabel;
/** 页面控制器 */
@property(nonatomic,strong)UIPageControl * pageControll;
/** 图片数组 */
@property(nonatomic,strong)NSMutableArray * imagesArr;
/** 位置数组 */
@property(nonatomic,strong)NSMutableArray * indexArr;//记录图片的顺序

@end


@implementation TimeScrollView

#pragma mark
#pragma mark 自定义方法

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imagesArr{
    self=[super initWithFrame:frame];
    if (self) {
        [self relayout];
        [self addSubview:self.mainView];
        [self getImagesWithImagesArr:imagesArr];
        [self loadImages];
    }
    return self;
}
/** 添加页面控制器 */
- (void)addPageControl{
    self.pageControll.numberOfPages=imageCount;
    self.pageControll.currentPage=0;
    self.pageControll.pageIndicatorTintColor=[UIColor redColor];
    self.pageControll.currentPageIndicatorTintColor=[UIColor blueColor];
    [self addSubview:self.pageControll];
}

#pragma mark 逻辑处理相关方法
/** 更新图片的方法 */
- (void)reloadDataWithImagesArr:(NSArray*)imagesArr{
    [self getImagesWithImagesArr:imagesArr];
    [self loadImages];
}

/** 拷贝图片 */
- (void)getImagesWithImagesArr:(NSArray*)imagesArr{
    [self.imagesArr removeAllObjects];
    [self.indexArr removeAllObjects];
    for (UIImage * image in imagesArr) {
        [self.imagesArr addObject:image];
        static  int num=0;
        NSString * index=[NSString stringWithFormat:@"%d",num];
        [self.indexArr addObject:index];
        num++;
    }
    imageCount=[self.imagesArr count];
}

/** 加载图片 */
- (void)loadImages{
    if (imageCount==0) {
        _mainView.scrollEnabled=NO;//不能滑动,提示没有传入图片
        
        self.messageLabel.hidden=NO;//显示提示信息
    }else if (imageCount==1) {
        _mainView.scrollEnabled=NO;//不能滑动,只展示一张图
        
        UIImage * image1=self.imagesArr[0];//当前的图片
        self.currentImage.image=image1;
        
        self.messageLabel.hidden=YES;//隐藏提示信息

    }else{
        _mainView.scrollEnabled=YES;//可以滑动
        
        UIImage * image=self.imagesArr[imageCount-1];//上一张图片
        self.lastImage.image=image;

        UIImage * image1=self.imagesArr[0];//当前的图片
        self.currentImage.image=image1;
        
        UIImage * image2=self.imagesArr[1];//下一张图片
        self.nextImage.image=image2;
        
        self.messageLabel.hidden=YES;//隐藏提示信息
        
        NSString * index=self.indexArr[0];
        currentNum=[index integerValue];//记录当前图片的位置

    }
 }

/** 重新布局 */
- (void)relayout{
    [self.lastImage removeFromSuperview];
    [self.currentImage removeFromSuperview];
    [self.nextImage removeFromSuperview];
    [self.mainView addSubview:self.lastImage];
    [self.mainView addSubview:self.currentImage];
    [self.mainView addSubview:self.nextImage];
    self.mainView.contentOffset=CGPointMake(TSWidth, 0);
    self.pageControll.currentPage=currentNum;
}

/** 往左滑动修改数据 */
- (void)changeimagesArrLeft{
    UIImage * firstImage=self.imagesArr[0];
    [self.imagesArr removeObject:firstImage];
    [self.imagesArr addObject:firstImage];
    
    NSString * index=self.indexArr[0];
    [self.indexArr removeObject:index];
    [self.indexArr addObject:index];
}

/** 往右滑动修改数据 */
- (void)changeimagesArrRight{
    UIImage * lastImage=self.imagesArr[imageCount-1];
    [self.imagesArr removeObject:lastImage];
    [self.imagesArr insertObject:lastImage atIndex:0];
    
    NSString * index=self.indexArr[imageCount-1];
    [self.indexArr removeObject:index];
    [self.indexArr insertObject:index atIndex:0];
}

#pragma mark 自动滚动相关方法
/** 开始滚动 */
- (void)beginScrollWithDuration:(NSTimeInterval)timeInterval{
    if (self.scrollstyle==AutomaticScrollStyle) {
        //自动滚动
        self.timeInterval=timeInterval;
        [self performSelector:@selector(createTimer) withObject:nil afterDelay:1];
    }
}

/** 创建计时器 */
- (void)createTimer{
    _timer=[NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer setFireDate:[NSDate distantPast]];
}

/** 停止滚动 */
- (void)stopScroll{
    [_timer setFireDate:[NSDate distantFuture]];//关闭计时器
}

/** 继续滚动 */
- (void)continueScroll{
    [_timer setFireDate:[NSDate distantPast]];
}

/** 滚动 */
- (void)scroll{
    [UIView beginAnimations:@"attribute" context:(__bridge void * _Nullable)(self.mainView)];//执行动画的对象
    [UIView setAnimationDuration:_timeInterval/2];//动画时间
    [UIView setAnimationDelegate:self];//代理
    if (self.scrollDirectionStyle==RightDirection) {
        self.mainView.contentOffset=CGPointMake(0,0);//对象将要做的改变
    }else{
        self.mainView.contentOffset=CGPointMake(TSWidth*2,0);//对象将要做的改变
    }
    [UIView setAnimationWillStartSelector:@selector(animationWillStart:context:)];//将要开始前执行此方法
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];//已经结束后执行此方法
    [UIView commitAnimations];//提交动画
}

/** 动画代理(动画开始前) */
- (void)animationWillStart:(NSString *)animationID context:(void *)context{
    if (self.scrollDirectionStyle==RightDirection) {
        [self changeimagesArrRight];
    }else{
        [self changeimagesArrLeft];
    }}

/** 动画代理(动画结束后) */
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [self loadImages];
    [self relayout];
    
}



#pragma mark
#pragma mark 懒加载

/** 底层滚动视图 */
- (UIScrollView *)mainView{
    if (!_mainView) {
        _mainView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, TSWidth, TSHeight)];
        _mainView.scrollEnabled=YES;
        _mainView.delegate=self;
        _mainView.contentSize=CGSizeMake(TSWidth*3, 0);
        _mainView.contentOffset=CGPointMake(TSWidth, 0);
        _mainView.pagingEnabled=YES;
        _mainView.bounces=NO;
        _mainView.showsHorizontalScrollIndicator=NO;
    }
    return _mainView;
}
/** 页面控制器 */
- (UIPageControl *)pageControll{
    if (!_pageControll) {
        _pageControll=[[UIPageControl alloc] initWithFrame:CGRectMake(0, TSHeight-30, TSWidth, 30)];
    }
    return _pageControll;
}

/** 图片数组 */
- (NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr=[NSMutableArray array];
    }
    return _imagesArr;
}

/** 位置数组 */
- (NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr=[NSMutableArray array];
    }
    return _indexArr;
}

/** 上一张图片 */
- (UIImageView *)lastImage{
    if (!_lastImage) {
        _lastImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TSWidth, TSHeight)];
    }
    return _lastImage;
}

/** 当前的图片 */
- (UIImageView *)currentImage{
    if (!_currentImage) {
        _currentImage=[[UIImageView alloc] initWithFrame:CGRectMake(TSWidth, 0, TSWidth, TSHeight)];
        [_currentImage addSubview:self.messageLabel];
    }
    return _currentImage
    ;
}

/** 下一张图片 */
- (UIImageView *)nextImage{
    if (!_nextImage) {
        _nextImage=[[UIImageView alloc] initWithFrame:CGRectMake(TSWidth*2, 0, TSWidth, TSHeight)];
    }
    return _nextImage;
}

/** 提示信息 */
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TSHeight/2-15, TSWidth, 30)];
        _messageLabel.text=@"传入图片数组错误";
        _messageLabel.textAlignment=1;
        _messageLabel.textColor=[UIColor grayColor];
        _messageLabel.hidden=YES;
    }
    return _messageLabel;
}

#pragma mark 
#pragma mark 滚动的代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentSetX=self.mainView.contentOffset.x;
    if (self.scrollstyle==NonAutomaticScrollStyle) {//自动滚动不做处理
        if (contentSetX==0) {//向右滚动
            [self changeimagesArrRight];
            [self loadImages];
            [self relayout];
        }else if (contentSetX==TSWidth*2){//向左滚动
            [self changeimagesArrLeft];
            [self loadImages];
            [self relayout];
        }
    }
}





@end

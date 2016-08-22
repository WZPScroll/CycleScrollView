//
//  ViewController.m
//  自动无限轮播图
//
//  Created by WZP on 16/8/22.
//  Copyright © 2016年 123. All rights reserved.
//

#import "ViewController.h"
#import "TimeScrollView.h"

@interface ViewController ()

@property(nonatomic,strong)TimeScrollView * scrollView;//是它是它就是它

@end



#define WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    
    //这个很重要哦~
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //初始化一个图片数组，里面放的必须是UIImage类型的对象
    NSMutableArray * imageArr=[NSMutableArray array];
    
    for (int i=1; i<5; i++) {
        NSString * imgName=[NSString stringWithFormat:@"图%d",i];
        UIImage * image = [UIImage imageNamed:imgName];
        [imageArr addObject:image];
    }
    
    //初始化要传入一个图片数组，这个数组不能为空
    self.scrollView=[[TimeScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 300) withImageArr:imageArr];
    [self.view addSubview:self.scrollView];
    
    
    
 //以上部分是基础设置，这样不会自动滚动，需要自动滚动的注释掉上面的代码，再看下面   -----------------------------------------------------------------------
    
    
    
//    //这个很重要哦~
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    
//    //初始化一个图片数组，里面放的必须是UIImage类型的对象
//    NSMutableArray * imageArr=[NSMutableArray array];
//    
//    for (int i=1; i<5; i++) {
//        NSString * imgName=[NSString stringWithFormat:@"图%d",i];
//        UIImage * image = [UIImage imageNamed:imgName];
//        [imageArr addObject:image];
//    }
//    
//    //初始化要传入一个图片数组，这个数组不能为空
//    self.scrollView=[[TimeScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 300) withImageArr:imageArr];
//    
//    //设置为自动滚动
//    self.scrollView.scrollstyle=AutomaticScrollStyle;
//    
//    //设置滚动方向,这里设置为向右，默认向左
//    self.scrollView.scrollDirectionStyle=RightDirection;
//    
//    //添加在屏幕上
//    [self.view addSubview:self.scrollView];
//    
//    //一秒后开始滚动,2代表滚动间隔
//    [self.scrollView beginScrollWithDuration:2];
//
//
//    UIButton * stop=[[UIButton alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
//    stop.tag=11;
//    stop.backgroundColor=[UIColor blackColor];
//    [stop setTitle:@"停" forState:0];
//    [stop setTitleColor:[UIColor whiteColor] forState:0];
//    [self.view addSubview:stop];
//    [stop addTarget:self action:@selector(eventButton:) forControlEvents:UIControlEventTouchUpInside];
//    


}

- (void)eventButton:(UIButton*)button{
    if (button.tag==11) {
        button.tag=22;
        [button setTitle:@"滚" forState:0];
        [self.scrollView stopScroll];
    }else{
        button.tag=11;
        [button setTitle:@"停" forState:0];
       // 继续滚动,注意如果不调用beginScrollWithDuration方法,那么此方法无效
        [self.scrollView continueScroll];
    }



}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

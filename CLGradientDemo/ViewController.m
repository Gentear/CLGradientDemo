//
//  ViewController.m
//  YJ_渐变demo
//
//  Created by yangjian on 2017/2/5.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define width_dpi SCREEN_WIDTH / 320
#define height_dpi SCREEN_HEIGHT/568


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *topImageView1;
    UIImageView *topImageView2;
    UIImageView *topImageView3;
    
    
    CGFloat start_Y;//记录需要移动的初始位置
    CGFloat end_Alpha;//记录手指离开时的透明度
}
@property (strong,nonatomic) UITableView *tableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}  //关闭自动偏移
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,110 * width_dpi + 50 + 50 * height_dpi)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround"]];
    [self.view addSubview:backView];
    
    topImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH,50*height_dpi)];
    topImageView1.image = [UIImage imageNamed:@"image_1"];
    [self.view addSubview:topImageView1];
    
    topImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView1.frame), SCREEN_WIDTH,110*width_dpi)];
    topImageView2.image = [UIImage imageNamed:@"image_2"];
    [self.view addSubview:topImageView2];
    
    topImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH,55*height_dpi)];
    topImageView3.image = [UIImage imageNamed:@"image_3"];
    topImageView3.alpha = 0;
    [self.view addSubview:topImageView3];
    [self tableView];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView1.frame), SCREEN_WIDTH,SCREEN_HEIGHT - CGRectGetMaxY(topImageView1.frame)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        UIView * clearview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topImageView2.frame.size.height)];
        clearview.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView = clearview;
        [self.view addSubview:tableView];
        tableView.bounces = NO;
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat topImageView2y = 110*width_dpi + CGRectGetMaxY(topImageView1.frame);
    float contentOffsety = scrollView.contentOffset.y;
    topImageView1.alpha = (topImageView1.bounds.size.height + 20 -contentOffsety) / (topImageView1.bounds.size.height + 20);
    
    if (contentOffsety >= 0) {
        topImageView3.alpha = 1 - (110*width_dpi - contentOffsety)/(110*width_dpi - topImageView1.bounds.size.height - 20);
        [topImageView2 setY:(CGRectGetMaxY(topImageView1.frame) - contentOffsety * 0.5)];
    }
    NSLog(@"%f",contentOffsety);
    topImageView2.alpha = (topImageView2y - contentOffsety * 2)/topImageView2y;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float contentOffsety = scrollView.contentOffset.y;
    if (contentOffsety <= 129 && contentOffsety >= 0) {
        if (topImageView2.alpha <0.2) {
            topImageView2.frame = CGRectMake(0, CGRectGetMaxY(topImageView1.frame)-topImageView2.bounds.size.height, SCREEN_WIDTH,110*height_dpi);
            topImageView2.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                topImageView1.alpha = 0;
                topImageView3.alpha = 1;
                [self.tableView setContentOffset:CGPointMake(0, topImageView2.frame.size.height)];
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                topImageView1.alpha = 1;
                topImageView3.alpha = 0;
                topImageView2.alpha = 1;
                topImageView2.frame = CGRectMake(0, CGRectGetMaxY(topImageView1.frame), SCREEN_WIDTH,110*height_dpi);
                [self.tableView setContentOffset:CGPointMake(0, 0)];
            }];
        }
    }
}

@end

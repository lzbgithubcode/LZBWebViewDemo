//
//  ViewController.m
//  LZBWebViewDemo
//
//  Created by zibin on 16/11/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LZBDIYFooterView.h"
#import "LZBDIYHeaderView.h"
#import "LZBBottomViewRefreshView.h"

#define LZBScreenWidth [UIScreen mainScreen].bounds.size.width
#define LZBScreenHeight [UIScreen mainScreen].bounds.size.height

#define LZBDefault_BottomViewHeight  44
@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scroollView;
@property (nonatomic, strong) UIView *firstPageView;
@property (nonatomic, strong) UIView *secondPageView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat bottomRefreshHeight;
@property (nonatomic, assign) CGFloat startbottomY;

@property(nonatomic, strong) LZBBottomViewRefreshView *bottomRefreshView;
//firstView
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scroollView];
    self.bottomButton.frame = CGRectMake(0, CGRectGetMaxY(self.scroollView.frame), LZBScreenWidth, LZBDefault_BottomViewHeight);
    [self setupFirstPageView];
   
}

- (void)setupFirstPageView
{
    [self.scroollView addSubview:self.firstPageView];
    self.firstPageView.frame = self.scroollView.bounds;
    //
    [self.firstPageView addSubview:self.coverImageView];
    self.coverImageView.frame = CGRectMake(0, 0, LZBScreenWidth, LZBScreenWidth);
    [self.firstPageView addSubview:self.contentLabel];
    self.contentLabel.frame = CGRectMake(0, CGRectGetMaxY( self.coverImageView.frame), LZBScreenWidth, 400);
    [self.contentLabel sizeToFit];
//    self.firstPageView.frame = CGRectMake(0, 0, LZBScreenWidth, CGRectGetMaxY(self.contentLabel.frame));
    [self.firstPageView addSubview:self.bottomRefreshView];
    
    self.bottomRefreshHeight = self.firstPageView.bounds.size.height -  CGRectGetMaxY(self.contentLabel.frame);
    self.startbottomY = CGRectGetMaxY(self.contentLabel.frame);
    self.bottomRefreshView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), LZBScreenWidth,self.bottomRefreshHeight );
    [self setupSecondPageView];
    NSLog(@"+++++++%@",NSStringFromCGRect(self.bottomRefreshView.frame));
    
}

- (void)setupSecondPageView
{
    [self.scroollView addSubview:self.secondPageView];
    self.secondPageView.frame = CGRectMake(0, LZBScreenHeight-LZBDefault_BottomViewHeight, LZBScreenWidth, LZBScreenHeight-LZBDefault_BottomViewHeight);
    
    
    LZBDIYHeaderView *headView = [LZBDIYHeaderView headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.scroollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            self.scroollView.scrollEnabled = YES;
        }];
        [headView endRefreshing];
    }];
    headView.backgroundColor = [UIColor redColor];
    self.tableView.mj_header = headView;
    
    [self.secondPageView addSubview:self.tableView];
    self.tableView.frame = self.secondPageView.bounds;
    [self.scroollView addSubview:self.secondPageView];
    self.scroollView.contentSize = CGSizeMake(LZBScreenWidth, (LZBScreenHeight-LZBDefault_BottomViewHeight) * 2);
}

- (void)loadMoreData
{
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

    CGRect cellFrame = self.bottomRefreshView.frame;
   
    if(scrollView.contentOffset.y >0 )
    {
        //拿到最后一个cell
        
        if(scrollView.contentOffset.y <  LZBScreenWidth)
        {
        cellFrame.size.height = self.bottomRefreshHeight + scrollView.contentOffset.y;
       // cellFrame.origin.y = self.startbottomY + scrollView.contentOffset.y;
        self.bottomRefreshView.frame = cellFrame;
        self.secondPageView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomRefreshView.frame), LZBScreenWidth, LZBScreenHeight-LZBDefault_BottomViewHeight);
        }
        else
        {
        self.secondPageView.frame = CGRectMake(0,LZBScreenHeight-LZBDefault_BottomViewHeight , LZBScreenWidth, LZBScreenHeight-LZBDefault_BottomViewHeight);
        }
     
        NSLog(@"+++++++%@",NSStringFromCGRect(self.bottomRefreshView.frame));
    }
}


#pragma mark- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第二页的第%ld行",indexPath.row];
    return cell;
}


#pragma mark - lazy
- (UIScrollView *)scroollView
{
  if(_scroollView == nil)
  {
      _scroollView = [UIScrollView new];
      _scroollView.delegate = self;
      _scroollView.frame = CGRectMake(0.0, 0.0, LZBScreenWidth, LZBScreenHeight-LZBDefault_BottomViewHeight);
      _scroollView.pagingEnabled = YES;//进行分页
      _scroollView.showsVerticalScrollIndicator = NO;
  }
    return _scroollView;
}

- (UIView *)firstPageView
{
  if(_firstPageView == nil)
  {
      _firstPageView = [UIView new];
  }
    return _firstPageView;
}

- (UIView *)secondPageView
{
    if(_secondPageView == nil)
    {
        _secondPageView = [UIView new];
    }
    return _secondPageView;
}

- (UIButton *)bottomButton
{
  if(_bottomButton == nil)
  {
      _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_bottomButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
      [_bottomButton setTitle:@"立即购买" forState:UIControlStateNormal];
      [self.view addSubview:_bottomButton];
      _bottomButton.backgroundColor = [UIColor yellowColor];
  }
    return _bottomButton;
}

- (UIImageView *)coverImageView
{
  if(_coverImageView == nil)
  {
      _coverImageView = [UIImageView new];
      _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
      _coverImageView.clipsToBounds = YES;
      _coverImageView.image = [UIImage imageNamed:@"hangbing"];
  }
    return _coverImageView;
}

- (UILabel *)contentLabel
{
  if(_contentLabel == nil)
  {
      _contentLabel = [UILabel new];
      _contentLabel.numberOfLines = 0;
      _contentLabel.textAlignment = NSTextAlignmentCenter;
      _contentLabel.textColor = [UIColor blueColor];
      _contentLabel.text = @"伴随着每一发弓箭从她的上古寒冰弓上发射，艾希证明了她是一位神射手。她小心的选择每一个目标，等待正确的时机，射出精准有力的箭矢。她抱着同样的愿景和专注于她的目标，为了寻求弗雷尔卓德部族的统一并将他们打造成一个强大的国家。游戏中的艾希则是一名拥有强大减速和控制能力的远程射手。";
  }
    return _contentLabel;
}

- (UITableView *)tableView
{
  if(_tableView == nil)
  {
      _tableView = [[UITableView alloc]initWithFrame:self.secondPageView.bounds style:UITableViewStylePlain];
      _tableView.dataSource = self;
      _tableView.delegate = self;
  }
    return _tableView;
}

- (LZBBottomViewRefreshView *)bottomRefreshView
{
  if(_bottomRefreshView == nil)
  {
      _bottomRefreshView = [LZBBottomViewRefreshView new];
      _bottomRefreshView.backgroundColor = [UIColor greenColor];
  }
    return _bottomRefreshView;
}




@end

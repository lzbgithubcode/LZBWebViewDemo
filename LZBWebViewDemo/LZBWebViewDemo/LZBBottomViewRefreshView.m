//
//  LZBBottomViewRefreshView.m
//  LZBWebViewDemo
//
//  Created by zibin on 16/11/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LZBBottomViewRefreshView.h"

@interface LZBBottomViewRefreshView()

@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation LZBBottomViewRefreshView
-(instancetype)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame])
  {
      [self addSubview:self.contentLabel];
  }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentLabel sizeToFit];

}



- (UILabel *)contentLabel
{
    if(_contentLabel == nil)
    {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor purpleColor];
        _contentLabel.text = @"上拉查看更多详细内容";
    }
    return _contentLabel;
}

@end

//
//  HMAlertView.m
//  H2ome
//
//  Created by hongyu on 2016/12/29.
//  Copyright © 2016年 Shanghai h2ome information technology co., LTD. All rights reserved.
//

#import "HMAlertView.h"

static const CGFloat bgViewAlpla = 0.5f;
static const CGFloat AlertWScale = 0.72f;
static const CGFloat AlertHScale = 0.23f;
static const CGFloat AlertOffset = 400.f;
static const CGFloat buttonFonts = 17.f;

#define HMALERT_WIDTH  [UIScreen mainScreen].bounds.size.width
#define HMALERT_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HMALERT_RGBA(R, G, B, A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
#define HMALERT_GRAYCOLOR HMALERT_RGBA(206, 206, 206, 1)
#define HMALERT_TEXTCOLOR HMALERT_RGBA(115, 115, 115, 1)
#define HMALERT_BUTGRAY   HMALERT_RGBA(153, 153, 153, 1)
#define HMALERT_BUTBLUE   HMALERT_RGBA(73, 157, 242, 1)
#define HMALERT_PX_LINE (1.0f / [UIScreen mainScreen].scale)

@interface HMAlertView ()

@property (strong, nonatomic) UIView   *bgView;
@property (strong, nonatomic) UIView   *hmAlertView;
@property (strong, nonatomic) UILabel  *contentLabel;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation HMAlertView

- (instancetype)initWithContent:(NSString *)content
                         cancel:(NSString *)cancel
                           sure:(NSString *)sure
                     buttonType:(HMAlertButtonType)type
                    sureBtBlock:(sureButtonBlock)sureBlock
                  cancelBtBlock:(cancelButtonBlock)cancelBlock
{
    if (self = [super init]) {
        self.alpha        = 0;
        self.frame        = [UIScreen mainScreen].bounds;
        self.sure_block   = sureBlock;
        self.cancel_block = cancelBlock;
        //alertView
        _hmAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMALERT_WIDTH * AlertWScale, HMALERT_HEIGHT * AlertHScale)];
        _hmAlertView.backgroundColor = [UIColor whiteColor];
        _hmAlertView.center          = CGPointMake(HMALERT_WIDTH / 2, HMALERT_HEIGHT / 2);
        _hmAlertView.layer.cornerRadius  = 8;
        _hmAlertView.layer.masksToBounds = YES;
        [self addSubview:_hmAlertView];
        //content
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _hmAlertView.frame.size.width - 30, 0.7 * _hmAlertView.frame.size.height)];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.numberOfLines   = 0;
        _contentLabel.text            = content;
        _contentLabel.font            = [UIFont systemFontOfSize:15];
        _contentLabel.textColor       = HMALERT_TEXTCOLOR;
        _contentLabel.textAlignment   = NSTextAlignmentCenter;
        [_hmAlertView addSubview:_contentLabel];
        UILabel *contentBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame), _hmAlertView.frame.size.width, HMALERT_PX_LINE)];
        contentBottomLabel.backgroundColor = HMALERT_GRAYCOLOR;
        [_hmAlertView addSubview:contentBottomLabel];
        //cancel button
        _cancelButton   = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, CGRectGetMaxY(contentBottomLabel.frame), _hmAlertView.frame.size.width / 2, _hmAlertView.frame.size.height - CGRectGetMaxY(contentBottomLabel.frame));
        [_cancelButton setTitle:cancel forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:buttonFonts]];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_hmAlertView addSubview:_cancelButton];
        // sure between cancel one px line
        UILabel *betweenLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cancelButton.frame.size.width, CGRectGetMaxY(contentBottomLabel.frame), HMALERT_PX_LINE, _cancelButton.frame.size.height)];
        betweenLabel.backgroundColor = HMALERT_GRAYCOLOR;
        [_hmAlertView addSubview:betweenLabel];
        //sure button
        _sureButton   = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(CGRectGetMaxX(betweenLabel.frame), _cancelButton.frame.origin.y, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
        [_sureButton setTitle:sure forState:UIControlStateNormal];
        [_sureButton setTitleColor:HMALERT_BUTBLUE forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_hmAlertView addSubview:_sureButton];
        [self setButtonType:type];
        //backGroundView
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:bgViewAlpla];
        _bgView.alpha = 0;
    }
    return self;
}

+ (instancetype)sharedAlertManager
{
    static dispatch_once_t onceToken;
    static HMAlertView *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HMAlertView new];
    });
    return sharedInstance;
}

- (instancetype)AlertWithContent:(NSString *)content cancel:(NSString *)cancel sure:(NSString *)sure buttonType:(HMAlertButtonType)type sureBtBlock:(sureButtonBlock)sureBlock cancelBtBlock:(cancelButtonBlock)cancelBlock
{
    HMAlertView *hmAlertView = [[HMAlertView alloc] initWithContent:content cancel:cancel sure:sure buttonType:type sureBtBlock:sureBlock cancelBtBlock:cancelBlock];
    [hmAlertView showAlertAnimation];
    return hmAlertView;
}

- (void)showAlertAnimation
{
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __block CGPoint alertViewCenter = self.hmAlertView.center;
    alertViewCenter.y      += AlertOffset;
    self.hmAlertView.center = alertViewCenter;
    alertViewCenter.y      -= AlertOffset + 15;
    [UIView animateWithDuration:0.25 animations:^{
        self.hmAlertView.center = alertViewCenter;
        alertViewCenter.y      += 15;
        self.alpha        = 1;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.hmAlertView.center = alertViewCenter;
        }];
    }];
}

- (void)dissAlertAnimation
{
    __block CGPoint alertViewCenter = self.hmAlertView.center;
    alertViewCenter.y      += AlertOffset;
    [UIView animateWithDuration:0.25 animations:^{
        self.hmAlertView.center = alertViewCenter;
        self.alpha        = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (void)cancelAction
{
    [self dissAlertAnimation];
    self.cancel_block();
}

- (void)sureAction
{
    [self dissAlertAnimation];
    self.sure_block();
}

- (void)setButtonType:(HMAlertButtonType)type
{
    switch (type) {
        case HMAlertTypeDefault:
            [_sureButton.titleLabel setFont:[UIFont boldSystemFontOfSize:buttonFonts]];
            [_cancelButton setTitleColor:HMALERT_BUTGRAY forState:UIControlStateNormal];
            break;
        case HMAlertTypeBlue:
            [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:buttonFonts]];
            [_cancelButton setTitleColor:HMALERT_BUTBLUE forState:UIControlStateNormal];      
            break;
    }
}

@end

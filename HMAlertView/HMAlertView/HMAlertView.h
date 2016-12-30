//
//  HMAlertView.h
//  H2ome
//
//  Created by hongyu on 2016/12/29.
//  Copyright © 2016年 Shanghai h2ome information technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureButtonBlock)();
typedef void(^cancelButtonBlock)();

typedef NS_ENUM(NSUInteger, HMAlertButtonType) {
    HMAlertTypeDefault = 0,
    HMAlertTypeBlue    = 1
};

@interface HMAlertView : UIView

@property (copy, nonatomic) sureButtonBlock   sure_block;
@property (copy, nonatomic) cancelButtonBlock cancel_block;

+ (instancetype)sharedAlertManager;

- (instancetype)AlertWithContent:(NSString *)content
                          cancel:(NSString *)cancel
                            sure:(NSString *)sure
                      buttonType:(HMAlertButtonType)type
                     sureBtBlock:(sureButtonBlock)sureBlock
                   cancelBtBlock:(cancelButtonBlock)cancelBlock;

@end

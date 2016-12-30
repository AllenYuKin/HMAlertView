# HMAlertView

调用

 [[HMAlertView sharedAlertManager] AlertWithContent:@"确认充值电费预付费 30 元？" cancel:@"取消" sure:@"确定" 
 
 buttonType:HMAlertTypeDefault sureBtBlock:^{
       NSLog(@"确定");
       
   } cancelBtBlock:^{
    NSLog(@"取消");
       
   }];

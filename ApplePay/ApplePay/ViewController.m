//
//  ViewController.m
//  ApplePay
//
//  Created by 周剑 on 16/2/29.
//  Copyright © 2016年 bukaopu. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>

// CardIO免费的二维码扫描框架

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController


#pragma mark - 支付按钮的点击事件
- (IBAction)payButtonDidClicked:(UIButton *)sender {
    /**
     支付请求对象
     */
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"商品名称" amount:[NSDecimalNumber decimalNumberWithString:@"商品价格"]];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"真皮坐垫" amount:[NSDecimalNumber decimalNumberWithString:@"200"]];
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"收款方" amount:[NSDecimalNumber decimalNumberWithString:@"总价"]];
    
    // 指定界面上显示的是哪些商品,最后一个item为付给
    request.paymentSummaryItems = @[item1, item2, item3];
    
    // 指定地区编码
    request.countryCode = @"CN";
    
    // 指定货币类型
    request.currencyCode = @"CNY";
    
    // 指定支持的网银支付类型
    request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard];
    
    // 限制权限
    request.merchantCapabilities = PKMerchantCapabilityEMV;
    
    // 商户id(开发者账号上面的id)
    request.merchantIdentifier = @"merchant.bukaopuPay";
    
    /**
     创建用户显示信息的控制器
     */
    PKPaymentAuthorizationViewController *PKVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    PKVC.delegate = self;
    
    if (!PKVC) {
        NSLog(@"出错了");
        // 手动放置一个崩溃信息
        @throw [NSException exceptionWithName:@"CQ_ERROR" reason:@"创建控制器失败" userInfo:nil];
        return;
    }else {
        // 模态显示控制器
        [self presentViewController:PKVC animated:YES completion:nil];
    }
    
}

/**
 在支付的过程中会调用这个方法
 
 @param controller 显示信息的控制器
 @param payment    订单的支付信息,主要包含订单的地址,订单的token(确认是否验证成功的东西)
 @param completion 用这个block块可以用来指定界面上显示的支付结果
 */
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSString *city = payment.billingContact.postalAddress.city;
    NSLog(@"city:%@", city);
    // 拿到信息验证
    PKPaymentToken *token = payment.token;
    NSLog(@"%@", token);
    // 将地址信息还有token信息发送到自己的服务器上,由自己的服务器返回结果
    
    // 订单的结果枚举
    PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusSuccess;
    // 将变量的值影响到界面上,在界面上显示订单结果
    completion(status);
}

/**
 支付完成的方法
 
 @param controller 显示信息的控制器
 */
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end

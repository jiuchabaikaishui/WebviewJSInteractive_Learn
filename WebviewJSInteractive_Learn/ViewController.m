//
//  ViewController.m
//  WebviewJSInteractive_Learn
//
//  Created by 綦 on 16/11/9.
//  Copyright © 2016年 PowesunHolding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathStr]]];
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function button1Action(){alert('哈哈');}"]];
}

#pragma mark - <UIWebViewDelegate>代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 处理事件
    NSString *requestString = [[[request URL] absoluteString] stringByRemovingPercentEncoding];
    NSLog(@"%@", requestString);
    NSArray *requestsArr = [requestString componentsSeparatedByString:@":"];
    if (requestsArr != nil && [requestsArr count] > 0) {
        NSString *pocotol = [requestsArr objectAtIndex:0];
        if ([pocotol isEqualToString:@"test"]) {
            NSString *commandStr = [requestsArr objectAtIndex:1];
            NSArray *commandArr = [commandStr componentsSeparatedByString:@"?"];
            if (commandArr != nil && [commandArr count] > 0) {
                NSString *command = [commandArr objectAtIndex:0];
                NSString *parameterStr = [commandArr objectAtIndex:1];
                NSArray *parameterArray = [parameterStr componentsSeparatedByString:@"&"];
                if ([command isEqualToString:@"showAlertView"]) {
                    NSString *title;
                    NSString *message;
                    NSArray *otherButtonTitles;
                    if (parameterArray && parameterArray.count > 0) {
                        title = parameterArray[0];
                    }
                    if (parameterArray && parameterArray.count > 1) {
                        message = parameterArray[1];
                    }
                    if (parameterArray && parameterArray.count > 2) {
                        otherButtonTitles = [parameterArray subarrayWithRange:NSMakeRange(2, parameterArray.count - 2)];
                    }
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAction;
                    for (NSString *buttonTitle in otherButtonTitles) {
                        alertAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:alertAction];
                    }
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                if ([command isEqualToString:@"alert"]) {
                    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"alert('%@');", [parameterArray firstObject]]];
                }
            }
            
            return NO;
        }
    }
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var test = {}; (function initialize()  {    test.showMessageAction = function showMessageAction(){ alert('哈哈');    };   })()"]];
}

#pragma mark - 自定义方法
/**
 * 弹出消息对话框
 */
- (void)showAleart: (NSString *) message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

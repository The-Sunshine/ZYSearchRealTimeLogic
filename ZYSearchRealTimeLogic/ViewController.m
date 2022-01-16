//
//  ViewController.m
//  ZYSearchViewController
//
//  Created by zy on 2022/1/16.
//

#import "ViewController.h"
#import "ZYSearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZYSearchViewController * vc = ZYSearchViewController.new;
    [self presentViewController:vc animated:true completion:nil];\
    vc.searchClickBlock = ^(id  _Nonnull model) {
        NSLog(@"%@",model);
    };
    vc.searchArray = @[@"123",@"234",@"345",@"456"];
}

@end

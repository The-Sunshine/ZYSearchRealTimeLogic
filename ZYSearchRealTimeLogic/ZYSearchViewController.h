//
//  ZYSearchViewController.h
//
//  Created by zy on 2022/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYSearchClickBlock)(id model);

@interface ZYSearchViewController : UIViewController

@property (nonatomic, copy) ZYSearchClickBlock searchClickBlock;

@property (nonatomic, strong) NSArray * searchArray;

@end

NS_ASSUME_NONNULL_END

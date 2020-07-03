//
//  ViewController.m
//  MLDebugDescription
//
//  Created by GML on 2020/7/3.
//  Copyright © 2020 GML. All rights reserved.
//

#import "ViewController.h"

@interface _VCInfo : NSObject<NSCopying>
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL isHa;
//@property (nonatomic, strong) _VCInfo *subInfo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *desc;
@end

@interface _User : NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *name;
@end

@implementation _User

@end

@implementation _VCInfo

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    _VCInfo *info = _VCInfo.new;
    info.name = @"copy";
//    info.subInfo = self.subInfo;
    info.desc = self.desc;
    return info;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _VCInfo *info = _VCInfo.new;
//    info.subInfo = info;
    _User *user = _User.new;
    user.name = @"suij";
    user.age = 20;
    info.desc = @{
        @"key" : @"info",
        @"desc" : @{
            @"number" : user,
            @"list" : @[
                    user,
                    user
            ],
        }
//        info : @"value",
    };
    NSLog(@"%@", info);
}


@end

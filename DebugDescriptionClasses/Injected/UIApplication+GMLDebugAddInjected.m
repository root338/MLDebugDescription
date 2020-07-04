//
//  UIApplication+GMLDebugAddInjected.m
//  MLDebugDescription
//
//  Created by GML on 2020/7/4.
//  Copyright © 2020 GML. All rights reserved.
//
#if DEBUG
#import "UIApplication+GMLDebugAddInjected.h"
#import <objc/runtime.h>

@interface UIApplication (__GMLDebugAddInjected)
@property (nonatomic, weak) id<UIApplicationDelegate> __gml_delegate;
@end

@implementation UIApplication (GMLDebugAddInjected)

+ (void)load {
    Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method replaceMethod = class_getInstanceMethod([self class], @selector(set__gml_delegate:));
    method_exchangeImplementations(originMethod, replaceMethod);
    
}



@end

@implementation UIApplication (__GMLDebugAddInjected)

- (void)set__gml_delegate:(id<UIApplicationDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(__gml_delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIApplicationDelegate>)__gml_delegate
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

#endif

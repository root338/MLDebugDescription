//
//  NSObject+GMLDebugDescription.m
//  MLDebugDescription
//
//  Created by GML on 2020/7/3.
//  Copyright © 2020 GML. All rights reserved.
//

#if DEBUG

#import "NSObject+GMLDebugDescription.h"
#import <objc/runtime.h>

// 集合打印走的是 descriptionWithLocale: 系统方法，不走 description

typedef NS_ENUM(NSInteger, __KGMLTestClassType) {
    __KGMLTestClassTypeCustom,
    __KGMLTestClassTypeSystem,
};

//#define ___KGMLDebugInput(a) [NSString stringWithFormat:@"<%@ %p> %@", [(a) class], (a), [(a) description]?:@"null"]
#define ___KGMLDebugInputCollection(self, items) [NSString stringWithFormat:@"<%@: %p>[%lu] (\n %@ \n )\n", [(self) class], (self), (unsigned long)items.count, [items componentsJoinedByString:@",\n "]];
#define ___KGMLDebugInputCustom(self, items) [NSString stringWithFormat:@"<%@: %p> ( %@ )", [(self) class], (self), [items componentsJoinedByString:@", "]];

@implementation NSObject (GMLDebugDescription)

+ (void)load {
    Method originMethod = class_getInstanceMethod([self class], @selector(description));
    Method replaceMethod = class_getInstanceMethod([self class], @selector(gml_description));
    method_exchangeImplementations(originMethod, replaceMethod);
}

//- (NSString *)descriptionWithLocale:(id)locale {
//
//}

- (NSString *)gml_description {
    switch ([self.class __gmlClassType]) {
        case __KGMLTestClassTypeCustom:
            return [self __gml_inputCustom];
        case __KGMLTestClassTypeSystem:
            return [self gml_description];
    }
}

- (NSString *)__gml_inputCustom {
    NSMutableDictionary *items = NSMutableDictionary.dictionary;
    Class mClass = self.class;
    while ([mClass __gmlClassType] == __KGMLTestClassTypeCustom) {
        [self enumerateObjectsUsingBlock:^(NSString *name) {
            id value = [self valueForKey:name];
            if ([value isKindOfClass:NSNull.class]) {
                value = @"<NSNull>";
            }
            [items setObject:value?:@"null" forKey:name];
        }];
        mClass = class_getSuperclass(mClass);
    }
    return [NSString stringWithFormat:@"<%@: %p>  %@ ", self.class, self, items];
}

- (void)enumerateObjectsUsingBlock:(void (^)(NSString *name))block {
    unsigned int outCount;
    objc_property_t *propertySet = class_copyPropertyList(self.class, &outCount);
    if (propertySet == nil) return;
    for (NSInteger i = 0; i < outCount; i++) {
        objc_property_t propertyT = propertySet[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyT)];
        !block?: block(propertyName);
    }
}

+ (__KGMLTestClassType)__gmlClassType {
    static NSString *appSandboxPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appSandboxPath = NSBundle.mainBundle.bundlePath;
    });
    BOOL isCustomClass = [[NSBundle bundleForClass:self.class].bundlePath hasPrefix:appSandboxPath];
    if (isCustomClass) {
        return __KGMLTestClassTypeCustom;
    }
    return __KGMLTestClassTypeSystem;
}

@end

#endif

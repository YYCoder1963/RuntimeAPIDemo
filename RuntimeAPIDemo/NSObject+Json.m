//
//  NSObject+Json.m
//  RuntimeAPIDemo
//
//  Created by lyy on 2019/2/28.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "NSObject+Json.h"
#import <objc/runtime.h>
@implementation NSObject (Json)

+ (instancetype)yy_objectWithJson:(NSDictionary *)jsonDictonary {
    id object = [[self alloc] init];
    unsigned int count;
    Ivar *ivars = class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSMutableString *name = [NSMutableString stringWithFormat:@"%s",ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        id value = jsonDictonary[name];
        if ([name isEqualToString:@"ID"]) {
            value = jsonDictonary[@"id"];
        }
        [object setValue:value forKey:name];
    }
    free(ivars);
    return object;
}

@end
;

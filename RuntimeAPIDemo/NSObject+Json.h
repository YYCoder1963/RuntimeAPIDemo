//
//  NSObject+Json.h
//  RuntimeAPIDemo
//
//  Created by lyy on 2019/2/28.
//  Copyright © 2019 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Json)

+ (instancetype)yy_objectWithJson:(NSDictionary *)jsonDictonary;

@end

NS_ASSUME_NONNULL_END

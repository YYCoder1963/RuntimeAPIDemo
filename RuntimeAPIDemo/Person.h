//
//  Person.h
//  RuntimeAPIDemo
//
//  Created by lyy on 2019/3/4.
//  Copyright © 2019 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(copy,nonatomic)NSString *sex;
@property(assign,nonatomic)int age;
@property(assign,nonatomic)int ID;

- (void)growUp;

- (void)exchangeMethod;

@end

NS_ASSUME_NONNULL_END

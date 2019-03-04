//
//  Person.m
//  RuntimeAPIDemo
//
//  Created by lyy on 2019/3/4.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)growUp {
    NSLog(@"%s",__func__);
}

- (void)exchangeMethod {
    NSLog(@"%s",__func__);
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"\n id:%d\n age:%d\n sex:%@\n",self.ID,self.age,self.sex];
    return description;
}

@end

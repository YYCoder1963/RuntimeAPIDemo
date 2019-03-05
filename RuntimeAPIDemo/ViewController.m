//
//  ViewController.m
//  RuntimeAPIDemo
//
//  Created by lyy on 2019/2/28.
//  Copyright © 2019 lyy. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NSObject+Json.h"
#import "Person.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self replaceMethod];
    
}

- (void)jsonToModel {
    NSDictionary *json = @{@"id" : @11,
                           @"age" : @22,
                           @"sex" : @"男"
                           };
    Person *person = [Person yy_objectWithJson:json];
    NSLog(@"%@",person);
}

#pragma mark --- Class Relevant API

- (Class)createNewClass{
    // 创建类
    Class newClass = objc_allocateClassPair(NSObject.class, "YYPerson", 0);
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_sex", 4, 1, @encode(NSString));
    class_addMethod(newClass, @selector(growUp), [self methodForSelector:@selector(growUp)], "v@:");
    //注册类
    objc_registerClassPair(newClass);
    //不需要时释放
    //    objc_disposeClassPair(newClass);
    return newClass;
}

- (void)exchangeInstanceIsa {
    Person *person = [Person new];
    Class class = [self createNewClass];
    object_setClass(person, class);
    [person growUp];
    /*
     object_isClass(id _Nullable obj) obj是否是类对象，若是类对象或元类对象返回yes，否则NO
     */
    NSLog(@"\n%d \n%d \n%d \n%d",object_isClass(person),
                            object_isClass(Person.class),
                            object_isClass(object_getClass(Person.class)),
                            class_isMetaClass(object_getClass(Person.class)));
    NSLog(@"%@",class_getSuperclass(Person.class));
}

- (void)growUp {
    NSLog(@"\n %s",__func__);
}


#pragma mark --- Ivar Relevant API

- (void)getIvarInformation {
    
    Ivar ivar = class_getInstanceVariable(UITextField.class, "text");
    NSLog(@"%s",ivar_getName(ivar));
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"\n getName:%s \n TypeEncoding:%s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    free(ivars);
}

/**
 设置私有属性
 */
- (void)ivarApplication {
    [self.textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark --- Property Relevant API

- (void)getProperty {
    Person *person = [Person new];
    person.age = 11;
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(person.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 例：name:age--  attri:Ti,N,V_age
        NSLog(@"\n name:%s--\n attri:%s",property_getName(property),property_getAttributes(property));
    }
    free(propertyList);
}

- (void)addProperty {
    Person *person = [Person new];
    person.age = 11;
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t atomic = {"N",""};
    objc_property_attribute_t ivar = {"V","_name"};
    objc_property_attribute_t attribute[] = {type,ownership,atomic,ivar};
    NSString *propertyName = @"name";
    if (class_addProperty(Person.class, propertyName.UTF8String, attribute, 4)) {
        NSLog(@"added Property");
    }
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(person.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 例：name:age--  attri:Ti,N,V_age
        NSLog(@"\n name:%s--\n attri:%s",property_getName(property),property_getAttributes(property));
    }

}

- (void)replaceProperty {
    Person *person = [Person new];
    person.age = 11;
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t atomic = {"N",""};
    objc_property_attribute_t ivar = {"V","_name"};
    objc_property_attribute_t attribute[] = {type,ownership,atomic,ivar};
    class_replaceProperty(Person.class, "age", attribute, 4);
  
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(person.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 例：name:age--  attri:Ti,N,V_age
        NSLog(@"\n name:%s--\n attri:%s",property_getName(property),property_getAttributes(property));
    }
    
}

#pragma mark --- Method Relevant API

- (void)getMethod {
    Method classMethod = class_getClassMethod(NSString.class, @selector(string));
    Method instanceMethod = class_getInstanceMethod(NSString.class, @selector(length));
    [self copyMethodList:NSString.class];
}

- (void)exchageMethod {
    Person *person = [Person new];
    Method growUpMethod = class_getInstanceMethod(Person.class, @selector(growUp));
    Method exchageMethod = class_getInstanceMethod(Person.class, @selector(exchageMethod));
    method_exchangeImplementations(growUpMethod, exchageMethod);
    [person growUp];
    NSLog(@"\n----------------exchange--------------");
    [person exchangeMethod];
}

- (void)addMethod {
    SEL sel = NSSelectorFromString(@"beBetter");
    Method method = class_getInstanceMethod(self.class, sel);
    IMP imp = method_getImplementation(method);
    class_addMethod(Person.class,sel, imp, "v@:");
    [self copyMethodList:Person.class];
}

- (void)replaceMethod {
    SEL sel = NSSelectorFromString(@"beBetter");
    Method method = class_getInstanceMethod(self.class, sel);
    IMP imp = method_getImplementation(method);
    class_replaceMethod(Person.class,NSSelectorFromString(@"growUp"), imp, "v@:");
    Person *person = [Person new];
    [person growUp];
}


- (void)beBetter {
    NSLog(@"%s",__func__);
}

- (void)copyMethodList:(Class)class {
    unsigned int count;
    Method *methodList = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"\n %@ \n %p ",NSStringFromSelector(method_getName(method)) ,
              method_getImplementation(method));
    }
    free(methodList);
}
@end

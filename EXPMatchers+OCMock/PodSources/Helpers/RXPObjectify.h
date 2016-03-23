//
//  EXMStubs.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import <Foundation/Foundation.h>
#import "ExpectaObject.h"
#import "ExpectaSupport.h"

#define RXPObjectify(x)  RXPWrapNil(EXPObjectify(x))
#define _RXPObjectify(type, value)  RXPWrapNil(_EXPObjectify(type, value))

BOOL RXPObjectifiedEqual(id o1, id o2);
id RXPWrapNil(id obj);

@interface EXMNil : NSObject
+ (instancetype)value;
@end

@interface EXMAny : NSObject
+ (instancetype)any;
@end

@interface EXMArgStop : NSObject
+ (instancetype)value;
@end


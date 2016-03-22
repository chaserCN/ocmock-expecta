//
//  EXMStubs.m
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import "EXMStubs.h"

@implementation EXMNil

+ (instancetype)value {
    static EXMNil *value;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        value = [self new];
    });

    return value;
}

@end


@implementation EXMAny : NSObject

+ (instancetype)any {
    static EXMAny *value;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        value = [self new];
    });
    
    return value;
}

@end

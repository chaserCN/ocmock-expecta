//
//  ECMVarArgHelpers.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import <Foundation/Foundation.h>

@interface RXPVarArgHelper : NSObject

+ (NSArray *)objectifiedArgumentsOfSelector:(SEL)aSelector firstArgument:(id)firstArgument argumentList:(va_list)argumentList;

@end

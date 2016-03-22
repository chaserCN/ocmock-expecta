//
//  ORExpectaOCMockSupport.h
//  Pods
//
//  Created by Nicolas on 3/22/16.
//
//

#import <Foundation/Foundation.h>

@interface EXMExpectifyHelper : NSObject

+ (BOOL)objectified:(id)o1 equalTo:(id)o2;

+ (id)objectifyArgOfInvocation:(NSInvocation *)inv atIndex:(NSUInteger)index;
+ (id)objectifyReturnOfInvocation:(NSInvocation *)inv;

@end


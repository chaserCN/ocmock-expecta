//
//  NSInvocation+expecta_receive.h
//  Pods
//
//  Created by Nicolas on 3/23/16.
//
//

#import <Foundation/Foundation.h>

@interface NSInvocation (expecta_receive)

- (id)rxp_objectifyReturnValue;
- (id)rxp_objectifyArgWithIndex:(NSUInteger)index;

@end

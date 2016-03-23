//
//  RXPMacros.h
//  Pods
//
//  Created by Nicolas on 3/23/16.
//
//

#ifndef RXPMacros_h
#define RXPMacros_h

#define RXP_VA_NARGS_IMPL(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, N, ...) N
#define RXP_VA_NARGS(...) RXP_VA_NARGS_IMPL(__VA_ARGS__, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define RXP_ENCODE0(x) RXPObjectify(x)
#define RXP_ENCODE1(x,...) RXPObjectify(x), RXP_ENCODE0(__VA_ARGS__)
#define RXP_ENCODE2(x,...) RXPObjectify(x), RXP_ENCODE1(__VA_ARGS__)
#define RXP_ENCODE3(x,...) RXPObjectify(x), RXP_ENCODE2(__VA_ARGS__)
#define RXP_ENCODE4(x,...) RXPObjectify(x), RXP_ENCODE3(__VA_ARGS__)
#define RXP_ENCODE5(x,...) RXPObjectify(x), RXP_ENCODE4(__VA_ARGS__)
#define RXP_ENCODE6(x,...) RXPObjectify(x), RXP_ENCODE5(__VA_ARGS__)
#define RXP_ENCODE7(x,...) RXPObjectify(x), RXP_ENCODE6(__VA_ARGS__)
#define RXP_ENCODE8(x,...) RXPObjectify(x), RXP_ENCODE7(__VA_ARGS__)
#define RXP_ENCODE9(x,...) RXPObjectify(x), RXP_ENCODE8(__VA_ARGS__)
#define RXP_ENCODE10(x,...) RXPObjectify(x), RXP_ENCODE9(__VA_ARGS__)

//Add more pairs if required. 10 is the upper limit in this case.
#define RXP_ENCODE(i,...) RXP_ENCODE##i(__VA_ARGS__) //i is the number of arguments (max 6 in this case)

#define RXP_OBJECTIFY_ARGS2(count,...) with(RXP_ENCODE(count,__VA_ARGS__))
#define RXP_OBJECTIFY_ARGS(count, ...) RXP_OBJECTIFY_ARGS2(count, __VA_ARGS__)

#endif /* RXPMacros_h */

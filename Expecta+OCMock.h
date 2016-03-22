#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "EXMStubs.h"

#define any() [EXMAny any]
#define method(x)  selector(@selector(x))
#define returning(x) returningObj(EXPObjectify(x))

@interface EXPExpect (receiveMatcher)

@property (nonatomic, readonly) EXPExpect *(^ selector) (SEL);

/// If you need to pass a scalar, you may wrap it by EXPObjectify. Or use EXPObjectify's output, like @3 for 3
@property (nonatomic, readonly) EXPExpect *(^ with) (id firstObject, ...);

@property (nonatomic, readonly) EXPExpect *(^ returningObj) (id);

@property (nonatomic, readonly) EXPExpect *(^ beCalled) (void);

@end;


#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#define any() [OCMArg any]
#define method(x)  selector(@selector(x))

@interface EXPExpect (receiveMatcher)

/// Expect an object to recieve a selector
@property (nonatomic, readonly) EXPExpect *(^ selector) (SEL);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ with) (NSArray *);

@property (nonatomic, readonly) EXPExpect *(^ with2) (id firstObject, ...);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ returning) (id);

/// Expectations around the arguments recieved
@property (nonatomic, readonly) EXPExpect *(^ beCalled) (void);

@end;

 // Concatenates A and B
#define mockify_concat(A, B) A ## B

// This is the @mockify, I used the same technique as libextobjc by using a @try{} @catch with no
// @ to absorb the initial @.

#define mockify(OBJ) \
        try {} @finally {} \
        \
        typeof(OBJ) mockify_concat(OBJ, _original_) = OBJ; \
        OBJ = [OCMockObject partialMockForObject:mockify_concat(OBJ, _original_)]; \
        \

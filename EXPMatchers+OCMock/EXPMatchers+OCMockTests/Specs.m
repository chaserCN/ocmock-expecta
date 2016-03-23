
/// Note: 3 tests are _meant_ to fail.

@interface ORObject : NSObject
@end

@implementation ORObject
- (void)method1 {};
- (NSNumber *)method2 { return @2; };
- (double)method22 {
    return 5.1;
};
- (void)method3:(NSString *)argument {};
- (NSInteger)method4 { return 23; };
- (void)method5:(NSString *)argument1 arg2:(NSNumber *)argument2 {};

- (void)method11:(NSString *)argument1 arg2:(NSInteger)argument2 {};
- (void)method12:(NSString *)argument1 arg2:(NSInteger)arg2 arg3:(NSInteger)arg3 arg4:(NSInteger)arg4 {};

@end

SpecBegin(ExpectaOCMockMatchers)

__block ORObject *sut;

before(^{
    sut = [[ORObject alloc] init];
});

it(@"checks for a method", ^{
    expect(sut).method(method1).to.beCalled();
    [sut method1];
});

it(@"checks for a async method", ^{
    dispatch_async(dispatch_get_main_queue(), ^{
        [sut method1];
    });
    
    expect(sut).method(method1).will.beCalled();
});

it(@"checks for a return object", ^{
    expect(sut).method(method22).returning(5.1).to.beCalled();
    [sut method22];
});

it(@"checks for a return value bridged to an object", ^{
    expect(sut).method(method4).returning(23).to.beCalled();
    [sut method4];
});

it(@"checks for an argument to the method", ^{
    expect(sut).method(method3:).with(@"thing").to.beCalled();
    [sut method3:@"thing"];
});

__block ORObject *a;
__block ORObject *b;

beforeEach(^{
    a = [[ORObject alloc] init];
    b = [[ORObject alloc] init];
});

it(@"supports multiple invocations of @mockify", ^{
    expect(a).method(method3:).with(@"a").to.beCalled();
    expect(b).method(method3:).with(@"b").to.beCalled();

    [a method3:@"a"];
    [b method3:@"b"];
});

it(@"supports multiple invocations of @mockify", ^{
    expect(a).method(method5:arg2:).with(@"a", @1).to.beCalled();
    expect(b).method(method5:arg2:).with(@"b", @2).to.beCalled();
    
    [a method5:@"a" arg2:@1];
    [b method5:@"b" arg2:@2];
});

it(@"supports primitives", ^{
    expect(a).method(method11:arg2:).with(@"a", 1).to.beCalled();
    [a method11:@"a" arg2:1];
});

it(@"notto", ^{
    expect(a).method(method11:arg2:).with(@"a", 1).notTo.beCalled();
    [a method11:@"a" arg2:2];
});

it(@"supports nils", ^{
    expect(a).method(method11:arg2:).with(nil, 1).to.beCalled();
    [a method11:nil arg2:1];
});

it(@"supports any()", ^{
    expect(a).method(method11:arg2:).with(any(), any()).to.beCalled();
    [a method11:nil arg2:1];
});

it(@"succeeds if arguments are not important", ^{
    expect(a).method(method11:arg2:).to.beCalled();
    [a method11:nil arg2:1];
});

it(@"succeeds if arguments are skipped", ^{
    expect(a).method(method11:arg2:).with(@"test").to.beCalled();
    [a method11:@"test" arg2:1];
});

it(@"2 expects in one block", ^{
    expect(a).method(method12:arg2:arg3:arg4:).with(@"test", 1).to.beCalled();
    expect(a).method(method1).with(1, 2).to.beCalled();
    [a method12:@"test" arg2:1 arg3:2 arg4:3];
    [a method1];
});

pending(@"It is expected that these tests will fail. That means they work properly", ^{
    it(@"fails when method is not called", ^{
        expect(sut).method(method2).to.beCalled();
        [sut method1];
    });
    
    it(@"fails when async method is not called", ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [sut method1];
        });
        
        expect(sut).method(method2).will.beCalled();
    });
    
    it(@"fails with the wrong return value", ^{
        expect(sut).method(method2).returning(@3).to.beCalled();
        [sut method2];
    });
    
    it(@"fails with the wrong argument value", ^{
        expect(sut).method(method3:).with(@"thingy").to.beCalled();
        [sut method3:@"thing"];
    });

    it(@"fails with the wrong arguments order", ^{
        expect(sut).method(method5:arg2:).with(@1, @"thingy").to.beCalled();
        [sut method5:@"thing" arg2:@1];
    });
    
    it(@"fails if receives a value instead of nil", ^{
        expect(a).method(method11:arg2:).with(nil, @1).to.beCalled();
        [a method11:@"test" arg2:1];
    });
    
    it(@"fails if receives nil instead of the value", ^{
        expect(a).method(method11:arg2:).with(@"test", @1).to.beCalled();
        [a method11:nil arg2:1];
    });

    it(@"fails if not called", ^{
        expect(a).method(method11:arg2:).with(@"test", @1).to.beCalled();
        [a method1];
    });

    it(@"fail if arguments are not important and not called", ^{
        expect(a).method(method11:arg2:).to.beCalled();
        [a method1];
    });

});

SpecEnd

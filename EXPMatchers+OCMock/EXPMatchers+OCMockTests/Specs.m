
/// Note: 3 tests are _meant_ to fail.

@interface ORObject : NSObject
@end

@implementation ORObject
- (void)method1 {};
- (NSNumber *)method2 { return @2; };
- (void)method3:(NSString *)argument {};
- (NSInteger)method4 { return 23; };
- (void)method5:(NSString *)argument1 arg2:(NSNumber *)argument2 {};

- (void)method11:(NSString *)argument1 arg2:(NSInteger)argument2 {};

@end

SpecBegin(ExpectaOCMockMatchers)

__block ORObject *sut;

before(^{
    sut = [[ORObject alloc] init];
});

pending(@"checks for a method", ^{
    @mockify(sut);

    expect(sut).method(method1).to.beCalled();
    [sut method1];
});

pending(@"checks for a async method", ^{
    @mockify(sut);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sut method1];
    });
    
    expect(sut).method(method1).will.beCalled();
});

pending(@"checks for a return object", ^{
    @mockify(sut);
    expect(sut).method(method2).returning(@2).to.beCalled();
    [sut method2];
});

pending(@"checks for a return value bridged to an object", ^{
    @mockify(sut);
    expect(sut).method(method4).returning(@23).to.beCalled();
    [sut method4];
});

pending(@"checks for an argument to the method", ^{
    @mockify(sut);
    expect(sut).method(method3:).with(@[@"thing"]).to.beCalled();
    [sut method3:@"thing"];
});

__block ORObject *a;
__block ORObject *b;

beforeEach(^{
    a = [[ORObject alloc] init];
    b = [[ORObject alloc] init];
});

pending(@"supports multiple invocations of @mockify", ^{
    @mockify(a)
    @mockify(b)

    
    expect(a).method(method3:).with(@[@"a"]).to.beCalled();
    expect(b).method(method3:).with(@[@"b"]).to.beCalled();

    [a method3:@"a"];
    [b method3:@"b"];
});

pending(@"supports multiple invocations of @mockify", ^{
    @mockify(a)
    @mockify(b)

    //expect(2).to.equal(2);
    
    expect(a).method(method5:arg2:).with2(@"a", @2).to.beCalled();
    expect(b).method(method5:arg2:).with2(@"b", @2).to.beCalled();
    
    [a method5:@"a" arg2:@1];
    [b method5:@"b" arg2:@2];
});

fit(@"supports multiple invocations of @mockify", ^{
    @mockify(a)
    @mockify(b)
    
    expect(a).method(method11:arg2:).with2(@"a", EXPObjectify(2)).to.beCalled();
    
    [a method11:@"a" arg2:1];
});

pending(@"It is expected that these tests will fail. That means they work properly", ^{
    it(@"fails when method is not called", ^{
        @mockify(sut);
        expect(sut).method(method2).to.beCalled();
        [sut method1];
    });
    
    it(@"fails when async method is not called", ^{
        @mockify(sut);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sut method1];
        });
        
        expect(sut).method(method2).will.beCalled();
    });
    
    it(@"fails with the wrong return value", ^{
        @mockify(sut);
        expect(sut).method(method2).returning(@3).to.beCalled();
        [sut method2];
    });
    
    it(@"fails with the wrong argument value", ^{
        @mockify(sut);
        expect(sut).method(method3:).with(@[@"thingy"]).to.beCalled();
        [sut method3:@"thing"];
    });
});

SpecEnd

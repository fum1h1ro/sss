//
//  GameInstancePoolTests.m
//  sss
//
//  Created by Kanaya Fumihiro on 2013/11/25.
//  Copyright (c) 2013年 alwaystesting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameCommon.h"
#import "GameUtil.h"

#define TEST_STOCK 128
@interface GameInstancePoolTests : XCTestCase {
    GameInstancePool* _pool;
}

@end

@implementation GameInstancePoolTests

- (void)setUp {
    [super setUp];
    _pool = [[GameInstancePool alloc] initWithNumOfStock:TEST_STOCK];
}

- (void)tearDown {
    [super tearDown];
    _pool = nil;
}
// 初期化できるかどうか
- (void)testInit {
    XCTAssert(_pool != nil, @"No instance");
}
// 在庫の数が正しいかどうか
- (void)testAlloc {
    XCTAssert(_pool.available == TEST_STOCK, @"まだ何も取得していないので、%d個ないとおかしい", TEST_STOCK);
    [_pool allocInstance];
    XCTAssert(_pool.available == TEST_STOCK-1, @"一つ取り出したので、%d個ないとおかしい", TEST_STOCK-1);
}
// 在庫が無くなったらnilを返す
- (void)testOutOfStock {
    u32 table[] = {
        128, 256, 512, 7, 13, 37, 43,
    };
    for (int i = 0; i < sizeof(table)/sizeof(table[0]); ++i) {
        u32 n = table[i];
        GameInstancePool* pool = [[GameInstancePool alloc] initWithNumOfStock:n];
        for (u32 j = 0; j < n; ++j) {
            id tmp = [pool allocInstance];
            XCTAssert(tmp != nil, @"在庫はまだあるはずなので、非nilでないとおかしい");
        }
        id tmp = [pool allocInstance];
        XCTAssert(tmp == nil, @"もう空になっているはずなので、nilが返ってないとおかしい");
    }
}
@end

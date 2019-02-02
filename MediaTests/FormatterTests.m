//
//  FormatterTests.m
//  FormatterTests
//
//  Created by MarkChang on 2019/1/25.
//  Copyright © 2019 MarkChang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSNumber+Formatter.h"

@interface FormatterTests : XCTestCase

@end

@implementation FormatterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDecimalText {
	XCTAssertEqualObjects([@0 decimalText], @"0");
	XCTAssertEqualObjects([@1 decimalText], @"1");
	XCTAssertEqualObjects([@100 decimalText], @"100");
	XCTAssertEqualObjects([@1000 decimalText], @"1,000");
	XCTAssertEqualObjects([@10000 decimalText], @"10,000");
	XCTAssertEqualObjects([@100000 decimalText], @"100,000");
	XCTAssertEqualObjects([@1000000 decimalText], @"1,000,000");
	
	XCTAssertEqualObjects([@-1 decimalText], @"-1");
	XCTAssertEqualObjects([@-100 decimalText], @"-100");
	XCTAssertEqualObjects([@-1000 decimalText], @"-1,000");
	XCTAssertEqualObjects([@-10000 decimalText], @"-10,000");
	XCTAssertEqualObjects([@-100000 decimalText], @"-100,000");
	XCTAssertEqualObjects([@-1000000 decimalText], @"-1,000,000");
}

@end

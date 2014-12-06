//
//  FreakTypeTests.m
//  BadHunterTDD
//
//  Created by Jorge D. Ortiz Fuentes on 6/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "FreakType+Model.h"


@interface FreakTypeTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    FreakType *sut;
    // Other objects
    FreakType *freakType1;
}

@end


@implementation FreakTypeTests

#pragma mark - Constants & Parameters

static NSString *const freakTypeMainName = @"Type1";
static NSString *const freakTypeAltName = @"Type2";

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
    [self createFixture];
    [self createSut];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    freakType1 = [FreakType freakTypeInMOC:context withName:freakTypeAltName];
}


- (void) createSut {
    sut = [FreakType freakTypeInMOC:context withName:freakTypeMainName];
}


- (void) tearDown {
    [self releaseSut];
    [self releaseFixture];
    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {
    freakType1 = nil;
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

#pragma mark - Data persistence


- (void) testConvenienceConstructorPreservesName {
    XCTAssertEqualObjects(sut.name, freakTypeMainName,
                          @"FreakType convenience constructor must preserve name.");
}


- (void) testConvenienceConstructorPreservesAnotherName {
    FreakType *altSut = [FreakType freakTypeInMOC:context withName:freakTypeAltName];
    XCTAssertEqualObjects(altSut.name, freakTypeAltName,
                          @"FreakType convenience constructor must preserve name.");
}


#pragma mark - Fetches

- (void) testFetchesFreakTypeWithGivenName {
    // Another FreakType is created in the fixture.
    XCTAssertEqual([FreakType fetchInMOC:context withName:freakTypeMainName], sut,
                   @"Fetch FreakType with name must retrieve the right object.");
}

@end

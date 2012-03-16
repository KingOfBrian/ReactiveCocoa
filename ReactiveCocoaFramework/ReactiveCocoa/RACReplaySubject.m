//
//  RACReplaySubject.m
//  ReactiveCocoa
//
//  Created by Josh Abernathy on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RACReplaySubject.h"
#import "RACSequence+Private.h"
#import "EXTNil.h"
#import "RACObserver.h"

@interface RACReplaySubject ()
@property (nonatomic, strong) NSMutableArray *valuesReceived;
@property (nonatomic, assign) NSUInteger capacity;
@end


@implementation RACReplaySubject

- (id)init {
	self = [super init];
	if(self == nil) return nil;
	
	self.valuesReceived = [NSMutableArray array];
	
	return self;
}


#pragma mark RACObservable

- (id)subscribe:(id<RACObserver>)observer {
	id result = [super subscribe:observer];
	for(id value in self.valuesReceived) {
		[observer sendNext:value];
	}
	
	return result;
}


#pragma mark RACObserver

- (void)sendNext:(id)value {
	[super sendNext:value];
	
	[self.valuesReceived addObject:value ? : [EXTNil null]];
	
	while(self.valuesReceived.count > self.capacity) {
		[self.valuesReceived removeObjectAtIndex:0];
	}
}


#pragma mark API

@synthesize valuesReceived;

+ (id)replaySubjectWithCapacity:(NSUInteger)capacity {
	RACReplaySubject *subject = [self subject];
	subject.capacity = capacity;
	return subject;
}

@end
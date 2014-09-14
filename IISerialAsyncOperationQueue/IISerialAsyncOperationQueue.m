//
//  SingleOperation.m
//  Drash2
//
//  Created by Tom Adriaenssen on 16/08/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import "IISerialAsyncOperationQueue.h"

@interface IISerialAsyncOperation : NSObject<IISerialAsyncOperation>

- (void)wait;

@end



@implementation IISerialAsyncOperationQueue {
    NSOperationQueue* _queue;
    dispatch_queue_t _dqueue;
}

- (id)init {
    if ((self = [super init])) {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
        _dqueue = dispatch_queue_create(NULL, 0);
    }
    return self;
}

- (void)addOperation:(void(^)(id<IISerialAsyncOperation> completion))action
{
    [self addOperation:action cancelAll:NO];
}

- (void)setOperation:(void(^)(id<IISerialAsyncOperation> completion))action
{
    [self addOperation:action cancelAll:YES];
}

- (void)addOperation:(void(^)(id<IISerialAsyncOperation> completion))action cancelAll:(BOOL)cancelAll
{
    if (!action)
        return;

    __block NSOperation* operation;
    operation = [NSBlockOperation blockOperationWithBlock:^{
        if ([operation isCancelled])
            return;

        IISerialAsyncOperation* completion = [IISerialAsyncOperation new];
        dispatch_async(_dqueue, ^{
            action(completion);
        });
        [completion wait];
    }];

    if (cancelAll) [_queue cancelAllOperations];
    [_queue addOperation:operation];
}

@end



@implementation IISerialAsyncOperation {
    dispatch_semaphore_t _semaphore;
}

- (void)complete {
    if (_semaphore) {
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)wait {
    [self wait:-1];
}

- (void)wait:(NSTimeInterval)timeout {
    dispatch_time_t time = DISPATCH_TIME_NOW;
    if (timeout < 0) {
        time = DISPATCH_TIME_FOREVER;
    }
    else if (timeout > 0) {
        time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    }
    
    _semaphore =  dispatch_semaphore_create(0);
    dispatch_semaphore_wait(_semaphore, time);
}

@end

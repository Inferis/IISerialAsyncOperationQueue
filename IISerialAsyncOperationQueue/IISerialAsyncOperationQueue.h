//
//  IISerialAsyncOperationQueue.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IISerialAsyncOperation <NSObject>

- (void)complete;

@end


@interface IISerialAsyncOperationQueue : NSObject

- (void)addOperation:(void(^)(id<IISerialAsyncOperation> completion))action;

- (void)setOperation:(void(^)(id<IISerialAsyncOperation> completion))action;

@end

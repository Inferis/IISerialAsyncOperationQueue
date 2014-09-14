# IISerialAsyncOperationQueue

A serial queue supporting async operations. The next operation starts only after the previous one completes.

This is the same as simple serial `NSOperationQueue`, but this one is geared towards async operations which is a bit harder to do with a plain old NSOperationQueue.

## Usage

Using this component is pretty simple. You create an instance and then add operations to it.

There's two actions possible:

* `setOperation:`: adds the operation to the queue but also removes all pending operations. The currently executing operation (if any) will continue until it is complete, after that the added operation is run. This call effectively clears all previously added operations replacing them with the new operation.
* `addOperation:`: adds the operation to the queue and leave all other pending operations be. All operations will be executed in the order they were passed. The added operation will only be run after all other queued operations are completed.

Either way, if no operations are pending, the operation will be run immediately. 

For example:

```
IISerialAsyncOperationQueue *queue = [IISerialAsyncOperationQueue new];

[queue addOperation:^(id<IISerialAsyncOperation> operation) {
	[do somethingAsync:^{
		[operation finish];
	}];	
}];
```

## License 

**IISerialOperationQueue** is published under the MIT License.

See [LICENSE](LICENSE) for the full license.
export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"

export type AnyPromise = {
	getStatus: (self: AnyPromise) -> Status,
	await: (self: AnyPromise) -> (boolean, ...any),
	awaitStatus: (self: AnyPromise) -> (Status, ...any),
	expect: (self: AnyPromise) -> ...any,
	cancel: (self: AnyPromise) -> (),
	catch: (self: AnyPromise, failureHandler: (...any) -> ...any) -> AnyPromise,
	andThen: (
		self: AnyPromise,
		successHandler: (...any) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> AnyPromise,
	andThenCall: <TArgs...>(self: AnyPromise, callback: (TArgs...) -> ...any, TArgs...) -> any,
	andThenReturn: (self: AnyPromise, ...any) -> AnyPromise,
	finally: (self: AnyPromise, finallyHandler: (status: Status) -> ...any) -> AnyPromise,
	finallyCall: <TArgs...>(self: AnyPromise, callback: (TArgs...) -> ...any, TArgs...) -> AnyPromise,
	finallyReturn: (self: AnyPromise, ...any) -> AnyPromise,
	now: (self: AnyPromise, rejectionValue: any?) -> AnyPromise,
	tap: (self: AnyPromise, tapHandler: (...any) -> ...any) -> AnyPromise,
	timeout: (self: AnyPromise, seconds: number, rejectionValue: any?) -> AnyPromise,
}

export type Promise<T...> = {
	getStatus: (self: AnyPromise) -> Status,
	await: (self: AnyPromise) -> (boolean, T...),
	awaitStatus: (self: AnyPromise) -> (Status, T...),
	expect: (self: AnyPromise) -> T...,
	cancel: (self: AnyPromise) -> (),
	catch: (self: AnyPromise, failureHandler: (...any) -> ...any) -> AnyPromise,
	andThen: (self: AnyPromise, successHandler: (T...) -> ...any, failureHandler: ((...any) -> ...any)?) -> AnyPromise,
	andThenCall: <TArgs...>(self: AnyPromise, callback: (TArgs...) -> ...any, TArgs...) -> AnyPromise,
	andThenReturn: (self: AnyPromise, ...any) -> AnyPromise,
	finally: (self: AnyPromise, finallyHandler: (status: Status) -> ...any) -> AnyPromise,
	finallyCall: <TArgs...>(self: AnyPromise, callback: (TArgs...) -> ...any, TArgs...) -> AnyPromise,
	finallyReturn: (self: AnyPromise, ...any) -> AnyPromise,
	now: (self: AnyPromise, rejectionValue: any?) -> Promise<T...>,
	tap: (self: AnyPromise, tapHandler: (T...) -> ...any) -> Promise<T...>,
	timeout: (self: AnyPromise, seconds: number, rejectionValue: any?) -> Promise<T...>,
}

type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ...any) -> SignalConnection | RBXScriptConnection,
}

type SignalConnection = {
	Disconnect: (self: SignalConnection) -> ...any,
	[any]: any,
}

type PromiseStatic = {
	Error: any,
	all: <T>(promises: { Promise<T> }) -> Promise<{ T }>,
	allSettled: <T>(promise: { Promise<T> }) -> Promise<{ Status }>,
	any: <T>(promise: { Promise<T> }) -> Promise<T>,
	defer: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> Promise<TReturn...>,
	delay: (seconds: number) -> Promise<number>,
	each: <T, TReturn>(
		list: { T | Promise<T> },
		predicate: (value: T, index: number) -> TReturn | Promise<TReturn>
	) -> Promise<{ TReturn }>,
	fold: <T, TReturn>(
		list: { T | Promise<T> },
		reducer: (accumulator: TReturn, value: T, index: number) -> TReturn | Promise<TReturn>
	) -> Promise<TReturn>,
	fromEvent: <TReturn...>(
		event: Signal<TReturn...>,
		predicate: ((TReturn...) -> boolean)?
	) -> Promise<TReturn...>,
	is: (object: any) -> boolean,
	new: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> Promise<TReturn...>,
	onUnhandledRejection: (callback: (promise: Promise<any>, ...any) -> ()) -> () -> (),
	promisify: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn...) -> (TArgs...) -> Promise<TReturn...>,
	race: <T>(promises: { Promise<T> }) -> Promise<T>,
	reject: (...any) -> Promise<...any>,
	resolve: <TReturn...>(TReturn...) -> Promise<TReturn...>,
	retry: <TArgs..., TReturn...>(
		callback: (TArgs...) -> Promise<TReturn...>,
		times: number,
		TArgs...
	) -> Promise<TReturn...>,
	retryWithDelay: <TArgs..., TReturn...>(
		callback: (TArgs...) -> Promise<TReturn...>,
		times: number,
		seconds: number,
		TArgs...
	) -> Promise<TReturn...>,
	some: <T>(promise: { Promise<T> }, count: number) -> Promise<{ T }>,
	try: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn..., TArgs...) -> Promise<TReturn...>,
}

return require(script.Parent.submodules.Promise) :: PromiseStatic

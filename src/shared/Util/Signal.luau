--!strict
-- Einfaches Event-System (wie RBXScriptSignal), für Kommunikation zwischen Modulen.

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

export type Signal<T...> = {
	Connect: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
	Once: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
	Fire: (self: Signal<T...>, T...) -> (),
	Wait: (self: Signal<T...>) -> T...,
	DisconnectAll: (self: Signal<T...>) -> (),
}

local Signal = {}

function Signal.new<T...>(): Signal<T...>
	local handlers: { [any]: (T...) -> () } = {}
	local self = {} :: any

	function self:Connect(fn: (T...) -> ()): Connection
		local key = {}
		handlers[key] = fn
		local connection = { Connected = true } :: any
		function connection:Disconnect()
			if self.Connected then
				self.Connected = false
				handlers[key] = nil
			end
		end
		return connection
	end

	function self:Once(fn: (T...) -> ()): Connection
		local connection: Connection
		connection = self:Connect(function(...: T...)
			connection:Disconnect()
			fn(...)
		end)
		return connection
	end

	function self:Fire(...: T...)
		for _, fn in handlers do
			task.spawn(fn, ...)
		end
	end

	function self:Wait(): T...
		local thread = coroutine.running()
		self:Once(function(...)
			task.spawn(thread, ...)
		end)
		return coroutine.yield()
	end

	function self:DisconnectAll()
		table.clear(handlers)
	end

	return self :: Signal<T...>
end

return Signal

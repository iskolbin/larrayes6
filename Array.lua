local Array = {
	TypeError = 'TypeError',
	RangeError = 'RangeError',
	MAX_RANGE = 2^32 - 1,
}

Array.__index = Array

function Array.new( ... )
	if select( '#', ... ) == 1 and tonumber( ... ) then
		return Array.alloc( ... )
	else
		return Array.of( ... )
	end
end

function Array.of( ... )
	local self = {...}
	self.length = #self
	return setmetatable( self, Array )
end

function Array.alloc( n, v )
	if type( n ) ~= 'number' then
		error( Array.TypeError )
	elseif n < 0 or n > Array.MAX_RANGE then
		error( Array.RangeError )
	end

	local self = Array.of()
	local t = self.t
	self.length = n
	v = v or false
	for i = 1, n do
		self[i] = v
	end
	return self
end

local function pass2( a1, a2 )
	return a1, a2
end

function Array.from( src, f )
	local self = Array.of()
	if type( src ) == 'table' then
		local mt = getmetatable( src )
		local it = mt and mt['@@iterator']
		f = f or pass2
		if it then
			local i = 0
			for e in it( src ) do
				i = i + 1
				self[i] = f( e, i - 1 )
			end
			self.length = i
		else
			local n = #src
			for i = 1, n do
				self[i] = f( src[i], i-1 )
			end
			self.length = n
		end
	end
	return self
end

function Array:slice( from, to )
	local n = self.length
	from = math.max( 0, (not from and 0) or from < 0 and from + n or from )
	to = math.min( n, (not to and n) or to < 0 and to + n or to )
	local out = Array()
	local k = 0
	for i = from, to-1 do
		k = k + 1
		out[k] = self[i+1]
	end
	out.length = math.max( 0, to-from )
	return out
end

function Array:splice( ... )
	local from, delcount = ...
	local n = self.length
	local out = Array.of()
	local m = select('#', ... ) - 2
	if m <= -2 then		
		return out
	elseif m == -1 then
		delcount = n - from
		m = 0
	end

	from = math.max( 0, (not from and 0) or from < 0 and from + n or from )
	delcount = math.max(0, math.min(delcount or 0, n - from ))
	
	out.length = delcount
	local k = 0
	for i = from+1, from+delcount+1 do
		k = k + 1
		out[k] = self[i]
	end
	
	if m > delcount then
		for i = n+1, n + m - delcount do
			self[i] = false
		end
		for i = n + m - delcount, from + m - delcount, -1 do
			self[i] = self[i-m]
		end
	elseif m < delcount then
		for i = from + m+1, n-delcount+m do
			self[i] = self[i+delcount-m]
		end
		for i = n + m - delcount + 1, n do
			self[i] = nil
		end
	end

	for i = 1, m do
		self[from+i] = select( i+2, ... )
	end
	self.length = n + m - delcount
	return out
end

function Array:copyWithin( target, from, to )
	local n = self.length
	target = math.max( 0, (not target and 0) or target < 0 and target + n or target )
	if target >= n then
		return self
	end
	from = math.max( 0, (not from and 0) or from < 0 and from + n or from )
	to = math.min( n, math.max( 0, (not to and n) or to < 0 and to + n or to ))
	local buffer = self:slice( from, to )
	for i = 1, buffer.length do
		self[i+target] = buffer[i]
	end
	return self
end

function Array.isArray( obj )
	return getmetatable( obj ) == Array
end

function Array:get( i )
	return self[i+1]
end

function Array:set( i, v )
	local n = self.length
	if i >= n then
		for j = n+1, i do
			self[j] = false
		end
		self.length = i+1
	end
	self[i+1] = v
end

function Array:fill( v, from, to )
	local n = self.length
	from = math.max( 0, (not from and 0) or from < 0 and from + n or from)
	to = math.min( n, (not to and n) or to < 0 and to + n or to )
	for i = from, to-1 do
		self[i+1] = v
	end
	return self
end

function Array:concat( arr )
	local out = self:slice()
	local k = out.length
	for i = 1, #arr do
		k = k + 1
		out[k] = arr[i]
	end
	out.length = k
	return out
end

function Array:every( p )
	for i = 1, self.length do
		if not p( self[i], i-1, self ) then
			return false
		end
	end
	return true
end

function Array:some( p )
	for i = 1, self.length do
		if p( self[i], i-1, self ) then
			return true
		end
	end
	return false
end

function Array:filter( p )
	local out = Array.of()
	local k = 0
	for i = 1, self.length do
		if p( self[i], i-1, self ) then
			k = k + 1
			out[k] = self[i]
		end
	end
	out.length = k
	return out
end

function Array:find( p )
	for i = 1, self.length do
		if p( self[i], i-1, self ) then
			return self[i]
		end
	end
end

function Array:findIndex( p )
	for i = 1, self.length do
		if p( self[i], i-1, self ) then
			return i-1
		end
	end
end

function Array:forEach( f )
	for i = 1, self.length do
		f( self[i], i-1, self )
	end
end

function Array:includes( v, from )
	return self:indexOf( v, from ) ~= -1
end

function Array:indexOf( v, from )
	from = (not from and 0) or from < 0 and from + self.length or from
	for i = from+1, self.length do
		if self[i] == v then
			return i-1
		end
	end
	return -1
end

function Array:join( sep )
	local t = {}
	for i = 1, self.length do
		t[i] = tostring( self[i] )
	end
	return table.concat( t, sep or ',' )
end

function Array:lastIndexOf( v, from )
	local n = self.length
	from = (not from and n-1) or from < 0 and from + n or from
	for i = n, from+1, -1 do
		if self[i] == v then
			return i-1
		end
	end
	return -1
end

function Array:map( f )
	local out = Array.of()
	for i = 1, self.length do
		out[i] = f( self[i], i-1, self )
	end
	out.length = self.length
	return out
end

function Array:pop()
	if self.length > 0 then
		local v = self[self.length]
		self[self.length] = nil
		self.length = self.length - 1
		return v
	end
end

function Array:push( ... )
	for i = 1, select( '#', ... ) do
		self.length = self.length + 1
		self[self.length] = select( i, ... )
	end
	return self.length
end

function Array:reduce( f, init )
	local n = self.length
	local j = 1
	if init == nil then
		if self.length <= 0 then
			error( Array.TypeError )
		else
			init = self[1]
			j = 2
		end
	end
	
	for i = j, n do
		init = f( init, self[i], i-1, self )
	end

	return init
end

function Array:reduceRight( f, init )
	local n = self.length
	local j = n
	if init == nil then
		if self.length <= 0 then
			error( Array.TypeError )
		else
			init = self[n]
			j = n-1
		end
	end
	
	for i = j, 1, -1 do
		init = f( init, self[i], i-1, self )
	end

	return init
end

function Array:reverse()
	local out = Array.of()
	local n = self.length
	for i = 1, n do
		out[n-i+1] = self[i] 
	end
	out.length = n
	return out
end

function Array:shift()
	if self.length > 0 then
		local v = table.remove( self, 1 )
		self.length = self.length - 1
		return v
	end
end

function Array:unshift( ... )
	for i = 1, select('#', ... ) do
		local v = select( i, ... )
		table.insert( self, i, v )
		self.length = self.length + 1
	end
	return self.length
end

function Array:sort( cmp )
	table.sort( self, cmp )
	return self
end

function Array:toString()
	return '[' .. self:join() .. ']'
end

function Array:keys()
	local i = 0
	return function()
		if i < self.length then
			i = i + 1
			return i-1
		end
	end
end

function Array:values()
	local i = 0
	return function()
		if i < self.length then
			i = i + 1
			return self[i]
		end
	end
end

function Array:entries()
	local i = 0
	return function()
		if i < self.length then
			i = i + 1
			return Array.of( i-1, self[i] )
		end
	end
end

function Array:ipairs()
	return function(...)
		local _, i = ...
		i = i or -1
		if i < self.length-1 then
			return i+1, self[i+2]
		end
	end
end

function Array:__ipairs()
	return self:ipairs()
end

function Array:__pairs()
	return self:ipairs()
end

function Array:__tostring()
	return self:toString()
end

function Array:__len()
	return self.length
end

Array['@@iterator'] = Array.values

return setmetatable( Array, {__call = function(_,...) 
	return Array.of( ... )
end})

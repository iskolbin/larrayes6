local Array = require('Array')

local function asserteq( a, b )
	a, b = tostring( a ), tostring( b )
	assert(a == b, a .. ' ~= ' .. b ) 
end

asserteq( Array(3), Array.of(3))
asserteq( Array.new(3), Array(false,false,false))
asserteq( Array(1, 2, 3), Array.of(1, 2, 3))
asserteq( Array(1, 2, 3), Array.new(1, 2, 3))
asserteq( Array.alloc( 3 ), Array(false, false, false))
asserteq( Array.alloc( 3, 1 ), Array(1, 1, 1))
asserteq( Array(1, 2, 3, 4, 5):slice(), Array(1, 2, 3, 4, 5))
asserteq( Array(1, 2, 3, 4, 5):slice(1), Array(2, 3, 4, 5))
asserteq( Array(1, 2, 3, 4, 5):slice(-1), Array(5))
asserteq( Array(1, 2, 3, 4, 5):slice(1,1), Array())
asserteq( Array(1, 2, 3, 4, 5):slice(1,-1), Array(2, 3, 4))
asserteq( Array(1, 2, 3, 4, 5):slice(-2,1), Array())
asserteq( Array(1, 2, 3, 4, 5):slice(-2,4), Array(4))
asserteq( #Array(1, 2, 3, 4, 5), 5 )
asserteq( Array(1, 2, 3, 4, 5).length, 5 )
asserteq( Array.isArray( Array(1,2,3,4)), true )
asserteq( Array.isArray{1,2,3,4}, false )

local x = Array(1,2,3,4,5)
x:set(0,5)
asserteq( x, Array(5,2,3,4,5))
x:set(5,1)
asserteq( x, Array(5,2,3,4,5,1))
x:set(8,22)
asserteq( x, Array(5,2,3,4,5,1,false,false,22))
asserteq( x.length, 9 )
asserteq( x:get(0), 5)
asserteq( x:get(8), 22 )

local x = Array(1,2,3,4,5)
asserteq( x:fill(2), Array(2,2,2,2,2))
asserteq( x:fill(3,-1), Array(2,2,2,2,3))
asserteq( x:fill(4,0,1), Array(4,2,2,2,3))
asserteq( x:fill(5,1,3), Array(4,5,5,2,3))

asserteq( Array(1, 2, 3):concat{4, 5}, Array(1, 2, 3, 4, 5 ))
asserteq( Array(1, 2, 3):concat( Array(4, 5)), Array(1, 2, 3, 4, 5 ))
asserteq( Array(1, 2, 3, 4, 5):every( function(v,i,arr) return v <= 5 end ), true )
asserteq( Array(1, 2, 3, 4, 5):every( function(v,i,arr) return v < 5 end ), false )
asserteq( Array(1, 2, 3, 4, 5):some( function(v,i,arr) return v <= 5 end ), true )
asserteq( Array(1, 2, 3, 4, 5):some( function(v,i,arr) return v < 5 end ), true )
asserteq( Array(1, 2, 3, 4, 5):some( function(v,i,arr) return v > 6 end ), false )
asserteq( Array(1, 2, 3, 4, 5):filter( function(v,i,arr) return v % 2 == 0 end ), Array(2, 4))
asserteq( Array(1, 2, 3, 4, 5):filter( function(v,i,arr) return i % 2 == 0 end ), Array(1, 3, 5))
asserteq( Array(1, 2, 3, 4, 5):find( function(v,i,arr) return v+i > 4 end ), 3 )
asserteq( Array(1, 2, 3, 4, 5):findIndex( function(v,i,arr) return v+i > 4 end ), 2 )

local s = 'h'
Array('e', 'l', 'l', 'o'):forEach( function(v,i) s = s .. v end )
asserteq( s, 'hello' )

asserteq( Array(1, 2, 3, 4, 5):includes( 3 ), true )
asserteq( Array(1, 2, 3, 4, 5):includes( 6 ), false )
asserteq( Array(1, 2, 3, 1, 2, 3):lastIndexOf( 3 ), 5 )
asserteq( Array(1, 2, 3, 1, 2, 3):lastIndexOf( 3, -1 ), 5 )
asserteq( Array(1, 2, 3, 1, 2, 3):lastIndexOf( 2, -1 ), -1 )
asserteq( Array(1, 2, 3, 1, 2, 3):lastIndexOf( 2, -2 ), 4 )
asserteq( Array(1, 2, 3, 4, 5):join(), '1,2,3,4,5' )
asserteq( Array(1, 2, 3, 4, 5):join(';'), '1;2;3;4;5' )
asserteq( Array(1, 2, 3, 4, 5):map( function(v,i,arr) return v + i end ), Array(1, 3, 5, 7, 9))

local x = Array(1, 2, 3, 4, 5)
asserteq( x:pop(), 5 )
asserteq( x, Array(1, 2, 3, 4))
asserteq( x:push( 10 ), 5 )
asserteq( x:push( 20 ), 6 )
asserteq( x, Array(1, 2, 3, 4, 10, 20))
asserteq( x:push( 30, 40, 50 ), 9 )
asserteq( x, Array(1, 2, 3, 4, 10, 20, 30, 40, 50))

asserteq( Array(1, 2, 3, 4, 5):reduce( function(acc,v,i,arr) return acc + v end ), 15 )
asserteq( Array(1, 2, 3, 4, 5):reduce( function(acc,v,i,arr) return acc + v end, 5 ), 20 )
asserteq( Array(1, 2, 3, 4, 5):reduce( function(acc,v,i,arr) return acc + i end ), 11 )
asserteq( Array(1, 2, 3, 4, 5):reduce( function(acc,v,i,arr) return acc + i end, 0 ), 10 )
asserteq( Array(1, 2, 3, 4, 5):reduceRight( function(acc,v,i,arr) return acc + v end ), 15 )
asserteq( Array(1, 2, 3, 4, 5):reduceRight( function(acc,v,i,arr) return acc + v end, 5 ), 20 )
asserteq( Array(1, 2, 3, 4, 5):reduceRight( function(acc,v,i,arr) return acc + i end ), 11 )
asserteq( Array(1, 2, 3, 4, 5):reduceRight( function(acc,v,i,arr) return acc + i end, 0 ), 10 )
asserteq( Array('h','e','l','l','o'):reduce( function(acc,v) return acc .. v end ), 'hello' )
asserteq( Array('h','e','l','l','o'):reduceRight( function(acc,v) return v.. acc end ), 'hello' )

local x = Array(1, 2, 3, 4, 5)
asserteq( x:shift(), 1 )
asserteq( x:shift(), 2 )
asserteq( x, Array(3, 4, 5))
asserteq( x:unshift(2), 4 )
asserteq( x:unshift(1), 5 )
asserteq( x, Array(1, 2, 3, 4, 5))
asserteq( x:unshift(), 5 )
asserteq( x, Array(1, 2, 3 ,4 ,5))
asserteq( x:unshift(-3, -2, -1, 0), 9 )
asserteq( x, Array(-3, -2, -1, 0, 1, 2, 3, 4, 5))

local x = Array(1, 3, 2, 5, 4)
asserteq( x:sort(), Array(1, 2, 3, 4, 5))
asserteq( x, Array(1, 2, 3, 4, 5))
local x = Array(1, 3, 2, 5, 4)
asserteq( x:sort(function(a,b) return a > b end), Array(5, 4, 3, 2, 1))
asserteq( x, Array(5, 4, 3, 2, 1))

asserteq( Array(1, 2, 3, 4, 5):reverse(), Array(5, 4, 3, 2, 1))
asserteq( Array(1, 2, 3, 4, 5):toString(), '[1,2,3,4,5]' )
asserteq( Array(1, 2, 3, 4, Array(1, 2, 3, Array(2, 4))), '[1,2,3,4,[1,2,3,[2,4]]]' )

local it = Array(5, 8, 7, 9):keys()
asserteq( it(), 0 )
asserteq( it(), 1 )
asserteq( it(), 2 )
asserteq( it(), 3 )
asserteq( it(), nil )

local it = Array(5, 8, 7, 9):values()
asserteq( it(), 5 )
asserteq( it(), 8 )
asserteq( it(), 7 )
asserteq( it(), 9 )
asserteq( it(), nil )

local it = Array(5, 8, 7, 9):entries()
asserteq( it(), Array(0,5) )
asserteq( it(), Array(1,8) )
asserteq( it(), Array(2,7) )
asserteq( it(), Array(3,9) )
asserteq( it(), nil )

local t = {5, 8, 7, 9}
for i, v in ipairs( Array(5, 8, 7, 9)) do
	asserteq( t[i+1], v )
end
for i, v in pairs( Array(5, 8, 7, 9)) do
	asserteq( t[i+1], v )
end
for i, v in Array(5, 8, 7, 9):ipairs() do
	asserteq( t[i+1], v )
end

local x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(), Array())
asserteq( x, Array(1, 2, 3, 4, 5 ))
asserteq( x:splice(0,0), Array())
asserteq( x, Array(1, 2, 3, 4, 5 ))
asserteq( x:splice(0), Array(1,2,3,4,5))
asserteq( x, Array())
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(nil, 1), Array(1))
asserteq( x, Array(2,3,4,5))
asserteq( x:splice(nil, 2), Array(2,3))
asserteq( x, Array(4,5))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(0,1), Array(1))
asserteq( x, Array(2,3,4,5))
asserteq( x:splice(-1,1), Array(5))
asserteq( x, Array(2,3,4))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(-2,10), Array(4,5))
asserteq( x, Array(1, 2, 3))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(2), Array(3,4,5))
asserteq( x, Array(1,2))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(2,2), Array(3,4))
asserteq( x, Array(1,2,5))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(1,3), Array(2,3,4))
asserteq( x, Array(1,5))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(10), Array())
asserteq( x, Array(1,2,3,4,5))
asserteq( x:splice(1,-10), Array())
asserteq( x, Array(1,2,3,4,5))
asserteq( x:splice(-10,50), Array(1,2,3,4,5))
asserteq( x, Array())
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(-10,1), Array(1))
asserteq( x, Array(2,3,4,5))
asserteq( x:splice(100,1), Array())
asserteq( x, Array(2,3,4,5))
x = Array(1, 2, 3, 4, 5)
asserteq( x:splice(nil,nil,0), Array())
asserteq( x, Array(0,1,2,3,4,5))
asserteq( x:splice(-1,nil,6), Array())
asserteq( x, Array(0,1,2,3,4,6,5))
asserteq( x:splice(-2,10,5,6), Array(6,5))
asserteq( x, Array(0,1,2,3,4,5,6))
asserteq( x:splice(2,3, -2,-3,-4), Array(2,3,4))
asserteq( x, Array(0,1,-2,-3,-4,5,6))
asserteq( x:splice(2,4,2,3), Array(-2,-3,-4,5))
asserteq( x, Array(0,1,2,3,6))
asserteq( x:splice(4,0, 4, 5), Array())
asserteq( x, Array(0,1,2,3,4,5,6))
asserteq( x:splice(-4,3, -3), Array(3,4,5))
asserteq( x, Array(0,1,2,-3,6))

asserteq( Array(1, 2, 3, 4, 5):copyWithin( -2 ), Array(1, 2, 3, 1, 2))
asserteq( Array(1, 2, 3, 4, 5):copyWithin( 0, 3), Array(4, 5, 3, 4, 5))
asserteq( Array(1, 2, 3, 4, 5):copyWithin( 0, 3, 4), Array(4, 2, 3, 4, 5))
asserteq( Array(1, 2, 3, 4, 5):copyWithin( -2, -3, -1), Array(1, 2, 3, 3, 4))
local x = Array(1, 2, 3, 4, 5)
asserteq( x:copyWithin( 0, 3), Array(4, 5, 3, 4, 5))
asserteq( x, Array(4,5,3,4,5))

asserteq( Array.from{1, 2, 3, 4, 5}, Array(1, 2 ,3, 4, 5))
asserteq( Array.from(5), Array())
asserteq( Array.from{}, Array())
asserteq( Array.from({1, 2, 3, 4, 5}, function(x) return x*2 end), Array(2,4,6,8,10))
asserteq( Array.from({1, 2, 3, 4, 5}, function(x,i) return i*x end), Array(0,2,6,12,20))
asserteq( Array.from(Array(1, 2, 3, 4, 5)), Array(1, 2, 3, 4, 5))

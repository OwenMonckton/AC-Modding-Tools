# Library ac_splashscreen

Documentation for ac_splashscreen. Please note: documentation generator is in development and needs more work, so some information might be missing and other bits might not be fully accurate.

# Module csp.lua

## Class ac.HashSpaceItem

- `ac.HashSpaceItem:id()`

  Returns ID associated with an item.

  Returns:

    - `integer`

- `ac.HashSpaceItem:update(pos)`

  Moves an item to a position.

  Parameters:

    1. `pos`: `vec3`

- `ac.HashSpaceItem:dispose()`

  Removes item from its space.
function HashSpaceItem:dispose() end
## Function ac.HashSpace(cellSize)
Simple structure meant to speed up collision detection by arranging items in a grid using hashmap. Cells are arranged horizontally.

  Parameters:

  1. `cellSize`: `number` Should be about twice as large as your largest entity.

  Returns:

  - `ac.HashSpace`
## Class ac.HashSpace
Simple structure meant to speed up collision detection by arranging items in a grid using hashmap. Cells are arranged horizontally.

- `ac.HashSpace:iterate(pos, callback, callbackData)`

  Iterates items around given position.

  Parameters:

    1. `pos`: `vec3`

    2. `callback`: `fun(id: integer, callbackData: T)`

    3. `callbackData`: `T?`

- `ac.HashSpace:anyAround(pos)`

  Checks if there are any items around given position.

  Parameters:

    1. `pos`: `vec3`

  Returns:

    - `boolean`

- `ac.HashSpace:count(pos)`

  Count amount of items around given position.

  Parameters:

    1. `pos`: `vec3`

  Returns:

    - `integer`

- `ac.HashSpace:rawPointers(pos)`

  Returns raw pointers for given position for manual iteration. Be careful!

  Parameters:

    1. `pos`: `vec3`

  Returns:

    - `any`

- `ac.HashSpace:add()`

  Adds a new dynamic item to the grid. Each item gets a new ID.

  Returns:

    - `ac.HashSpaceItem`

- `ac.HashSpace:addFixed(id, pos)`

  Adds a fixed item to the grid, with predetermined ID. Avoid mixing dynamic and fixed items in the same grid.

  Parameters:

    1. `id`: `integer`

    2. `pos`: `vec3`

# Module lib_numlut.lua

## Class ac.Lut
Meant to quickly interpolate between tables of values, some of them could be colors set in HSV. Example:
```lua
local lut = ac.Lut([[
 -100 |  0.00,   350,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04
  -90 |  1.00,    10,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04
  -20 |  1.00,    10,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04
]], { 2 })
assert(lut:calculate(-95)[1] == 0.5)
```

- `ac.Lut:calculate(input)`

  Interpolate for a given input, return a newly created table. Note: consider using `:calculateTo()` instead to avoid re-creating tables, it would work much more efficiently.

  Parameters:

    1. `input`: `number`

  Returns:

    - `number`

- `ac.Lut:calculateTo(output, input)`

  Interpolate for a given input, write result to a given table.

  Parameters:

    1. `output`: `number[]`

    2. `input`: `number`

  Returns:

    - `number`

# Module lib_numlut_jit.lua

## Class ac.LutJit
Meant to quickly interpolate between tables of values, some of them could be colors set in HSV. Example:
```lua
local lutJit = ac.LutJit:new{ data = {
  { input = -100, output = {  0.00,   350,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04 } },
  { input =  -90, output = {  1.00,    10,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04 } },
  { input =  -20, output = {  1.00,    10,  0.37,  1.00,  3.00,  1.00,  1.00,  3.60,500.00,  0.04 } },
  }, hsvRows = { 2 }}
assert(lutJit:calculate(-95)[1] == 1)
```
Obsolete. Use `ac.Lut` instead, with faster C++ implementation.

- `ac.LutJit:new(o, data, hsvRows)`

  Creates new ac.LuaJit instance. Deprecated, use `ac.Lut` instead.

  Parameters:

    1. `data`: `any`

    2. `hsvRows`: `integer[]`  1-based indices of columns (not rows) storing HSV values in them.

  Returns:

    - `table`

- `ac.LutJit:calculate(input)`

  Computes a new value. Deprecated, use `ac.Lut` instead.

  Parameters:

    1. `input`: `number`

  Returns:

    - `number`

- `ac.LutJit:calculateTo(output, input)`

  Computes a new value to a preexisting HSV value. Deprecated, use `ac.Lut` instead.

  Parameters:

    1. `output`: `number[]`

    2. `input`: `number`

  Returns:

    - `number`
## Function ac.LutJit:new(o, data, hsvRows)
Creates new ac.LuaJit instance. Deprecated, use `ac.Lut` instead.

  Parameters:

  1. `data`: `any`

  2. `hsvRows`: `integer[]`  1-based indices of columns (not rows) storing HSV values in them.

  Returns:

  - `table`
## Function ac.LutJit:calculate(input)
Computes a new value. Deprecated, use `ac.Lut` instead.

  Parameters:

  1. `input`: `number`

  Returns:

  - `number`
## Function ac.LutJit:calculateTo(output, input)
Computes a new value to a preexisting HSV value. Deprecated, use `ac.Lut` instead.

  Parameters:

  1. `output`: `number[]`

  2. `input`: `number`

  Returns:

  - `number`
## Function web.loadRemoteModel(u, callback)
Loads a ZIP file from a given URL, unpacks first KN5 from it to a cache folder and returns
its filename through a callback. If file is already in cache storage, doesn’t do anything and
simply returns filename to it. After callback is called, that filename could be used to load
KN5 in the scene.

If there is a VAO patch in a ZIP file, it will be extracted next to KN5.

Note: only valid KN5 files and VAO patches are supported. Heavy caching is applied: if model was
downloaded once, it would not be re-downloaded (unlike with remote textures where proper HTTP caching
rules apply). If model was not accessed for a couple of weeks, it’ll be removed.

If you need to download several entities and do something afterwards, it might help to use some
promise Lua library.

Use `web.loadRemoteAssets()` instead.

  Parameters:

  1. `u`: `string` URL to download.

  2. `callback`: `fun(err: string, filename: string)`
## Function web.loadRemoteAnimation(u, callback)
Loads a ZIP file from a given URL, unpacks first KsAnim from it to a cache folder and returns
its filename through a callback. If file is already in cache storage, doesn’t do anything and
simply returns filename to it. After callback is called, that filename could be used to animate
objects in the scene. If animation was not accessed for a couple of weeks, it’ll be removed.

If you need to download several entities and do something afterwards, it might help to use some
promise Lua library.

Use `web.loadRemoteAssets()` instead.

  Parameters:

  1. `u`: `string` URL to download.

  2. `callback`: `fun(err: string, filename: string)`
## Function web.loadRemoteAssets(u, callback)
Loads a ZIP file from a given URL, unpacks assets from it to a cache folder and returns
path to the folder in a callback. If files are already in cache storage, doesn’t do anything and
simply returns the path. After callback is called, you can use path to the folder to get full paths to those assets.
If assets are not accessed for a couple of weeks, they’ll be removed.

  Parameters:

  1. `u`: `string` URL to download.

  2. `callback`: `fun(err: string, folder: string)`
## Function web.resolveDNS(url, callback)
Resolve hostname, return IPv4 via a callback.

  Parameters:

  1. `url`: `string`

  2. `callback`: `fun(err: string?, response: string?)`
## Function web.encryptKey(key)

  Parameters:

  1. `key`: `string`

  Returns:

  - `string`

# Module common/common.lua

## Class ac.GenericList
FFI-accelerated list, acts like a regular list (consequent items, size and capacity, automatically growing, etc.)
Doesn’t store nil values to act more like a Lua table.

Few notes:
• Use `:get()` and `:set()` to access elements instead of square brakets;
• Indices are 1-based;
• For fastest access to individual elements use `.raw` field: it’s a raw pointer, so use 0-based indices there and
make sure not to access things outside of list size.

For slightly better performance it might be benefitial to preallocate memory with `list:reserve(expectedSizeOrABitMore)`.

- `ac.GenericList:get(index)`

  Return an element at given index.

  Parameters:

    1. `index`: `integer` 1-based index.

  Returns:

    - `any`

- `ac.GenericList:set(index, value)`

  Sets an element at given index.

  Parameters:

    1. `index`: `integer` 1-based index.

    2. `value`: `any`

- `ac.GenericList:size()`

  Number of items in the list.

  Returns:

    - `integer`

- `ac.GenericList:sizeBytes()`

  Size of list in bytes (not capacity, for that use `list:capacityBytes()`).

  Returns:

    - `integer`

- `ac.GenericList:isEmpty()`

  Checks if list is empty.

  Returns:

    - `boolean`

- `ac.GenericList:capacity()`

  Capacity of the list.

  Returns:

    - `integer`

- `ac.GenericList:capacityBytes()`

  Size of list in bytes (capacity).

  Returns:

    - `integer`

- `ac.GenericList:reserve(newSize)`

  Makes sure list can fit `newSize` of elements without reallocating memory.

  Parameters:

    1. `newSize`: `integer`

  Returns:

    - `integer`

- `ac.GenericList:shrinkToFit()`

  If capacity is greater than current size, reallocates a smaller bit of memory and moves data there.
function _ac_genericList:shrinkToFit() end

- `ac.GenericList:clear()`

  Removes all elements.
function _ac_genericList:clear() end

- `ac.GenericList:clone()`

  Creates a new list with the same contents as the existing one.

  Returns:

    - `ac.GenericList`
## Class ffilibex
Custom FFI namespace. Be very careful around here.

- `ffilibex.cdef(def, params, ...)`

- `ffilibex.istype(ct, obj)`

  Parameters:

    1. `obj`: `any`

  Returns:

    - `boolean`

- `ffilibex.string(ptr, len)`

  Returns:

    - `string`

- `ffilibex.typeof(ct, params, ...)`

  Returns:

    - `ffi.ctype`

- `ffilibex.cast(ct, init)`

  Parameters:

    1. `init`: `any`

  Returns:

    - `ffi.cdata`

- `ffilibex.metatype(ct, metatable)`

  Parameters:

    1. `metatable`: `table`

  Returns:

    - `ffi.ctype`

- `ffilibex.gc(cdata, finalizer)`

  Returns:

    - `ffi.cdata`

- `ffilibex.copy(destination, data, size)`

  Parameters:

    1. `destination`: `any`

    2. `data`: `any|string`

    3. `size`: `integer?`
## Function worker.sleep(time)
Available only in background worker scripts. Sleep function pauses execution for a certain time. 
Before unpaused, any callbacks (such as `setTimeout()`, `setInterval()` and
other custom enqueued callbacks) will be called. This is the only way for those callbacks to fire in a background worker. Note:
if parent thread is closed, `worker.sleep()` won’t return back and instead script will be unloaded, this way worker can be reloaded
as well.

If your worker does a lot of async operations, consider using `worker.wait()` instead, setting resulting value with `worker.result`.
Or maybe not even use anything at all: for basic (non-repeating) callbacks, timers and intervals script will continue running until
all the postponed actions are complete (updating once every 100 ms).

  Parameters:

  1. `time`: `number` Time in seconds to pause worker by.
## Function worker.wait(time)
Wait for `worker.result` value to be set. Stops the worker once `worker.result` value has been provided (or any `error()` has been raised).
Works the best if your worker uses a lot of async operations.

  Parameters:

  1. `time`: `number?` Time in seconds for timeout. Default value: 60. Feel free to pass something like `math.huge` if you don’t need timeout for some reason.
## Function ac.store(key, value)
Stores value in session shared Lua/Python storage. This is not a long-term storage, more of a way for
different scripts to exchange data. Note: if you need to exchange a lot of data between Lua scripts,
consider using ac.connect instead.

Data string can contain zeroes.

  Parameters:

  1. `key`: `string`

  2. `value`: `string|number`
## Function ac.load(key)
Reads value from session shared Lua/Python storage. This is not a long-term storage, more of a way for
different scripts to exchange data. Note: if you need to exchange data between Lua scripts,
use `ac.connect()` instead. And if despite that you need to exchange data between car scripts, make sure to add
car index to the key.

  Parameters:

  1. `key`: `string`

  Returns:

  - `nil|string|number`
## Function ac.onRelease(callback, item)
Adds a callback which might be called when script is unloading. Use it for some state reversion, but
don’t rely on it too much. For example, if Assetto Corsa would crash or just close rapidly, it would not
be called. It should be called when scripts reload though.

  Parameters:

  1. `callback`: `fun(item: T)`

  2. `item`: `T?` Optional parameter. If provided, will be passed to callback on release, but stored with a weak reference, so it could still be GCed before that (in that case, callback won’t be called at all).

  Returns:

  - `fun`
## Function package.add(dir)
For easy import of scripts from subdirectories. Provide it a name of a directory relative
to main script folder and it would add that directory to paths it searches for.

  Parameters:

  1. `dir`: `string`
## Function ac.onOnlineWelcome(callback)
Sets a callback which will be called when server welcome message and extended config arrive.

  Parameters:

  1. `callback`: `fun(message: string, config: ac.INIConfig)` Callback function.

  Returns:

  - `ac.Disposable`

# Module common/class.lua

## Function ClassBase.isInstanceOf(obj)
Checks if object is an instance of a class created by `class()` function.

  Parameters:

  1. `obj`: `any|nil` Any table, vector, nil, anything.

  Returns:

  - `boolean` True if type of `obj` is `ClassBase` or any class inheriting from it.
## Function ClassBase:isSubclassOf(classDefinition)
Checks if ClassBase is a subsclass of a class created by `class()` function. It wouldn’t be, function is here just for
keeping things even.

  Parameters:

  1. `classDefinition`: `ClassDefinition` Class created by `class()` function.

  Returns:

  - `boolean` Always false.
## Function ClassBase:subclass(...)
Creates a new class. Pretty much the same as calling `class()` (all classes are inheriting from `ClassBase` anyway).

  Returns:

  - `ClassDefinition` New class definition
## Function ClassBase:include(mixin)
Adds a mixin to all subsequently created classes. Use it early in case you want to add a method or some data to all of your objects.
If `mixin` has a property `included`, it would be called each time new class is created with a reference to the newly created class.

  Parameters:

  1. `mixin`: `ClassMixin`
## Function ClassBase:subclassed(classDefinition)
Define this function and it would be called each time a new class without a parent (or `ClassBase` for parent) is created.

  Parameters:

  1. `classDefinition`: `ClassDefinition`
## Function ClassPool.isInstanceOf(obj)
Checks if object is an instance of a class with pooling active.

  Parameters:

  1. `obj`: `any|nil` Any table, vector, nil, anything.

  Returns:

  - `boolean` True if type of `obj` is `ClassPool` or any class inheriting from it.
## Function ClassPool:isSubclassOf(classDefinition)
Checks if ClassPool is a subsclass of a class created by `class()` function. It wouldn’t be unless you’re passing `ClassBase`, function is here just for
keeping things even.

  Parameters:

  1. `classDefinition`: `ClassBase` Class created by `class()` function.

  Returns:

  - `boolean` True if you’ve passed ClassBase here.
## Function ClassPool:subclass(...)
Creates a new class with pooling. Pretty much the same as calling `class(class.Pool, ...)` (all classes with `class.Pool` are 
inheriting from `ClassPool` anyway).

  Returns:

  - `ClassDefinition` New class definition
## Function ClassPool:include(mixin)
Adds a mixin to subsequently created classes with pooling. Use it early in case you want to add a method or some data to all of your objects that use pooling.
If `mixin` has a property `included`, it would be called each time new class with pooling is created with a reference to the newly created class.

  Parameters:

  1. `mixin`: `ClassMixin`
## Function ClassPool:subclassed(classDefinition)
Define this function and it would be called each time a new pooling class without a parent (or `ClassPool` for parent) is created.

  Parameters:

  1. `classDefinition`: `ClassDefinition`
## Class ClassBase
A base class. Note: all classes are inheriting from this one even if they’re not using
`ClassBase` as a parent class explicitly. You might still want to put it in EmmyDoc comment to get hints for functions like `YourClass.isInstanceOf()`.

- `ClassBase:isInstanceOf(classDefinition)`

  Checks if object is an instance of this class. Can be used either as `obj:isInstanceOf(YourClass)` or, as a safer alternative,
`YourClass.isInstanceOf(obj)` — this one would work even if `obj` is nil, a number, a vector, anything like that. And in all of those
cases, of course, it would return `false`.

  Parameters:

    1. `classDefinition`: `ClassDefinition` Used with `obj:isInstanceOf(YourClass)` variant.

  Returns:

    - `boolean` True if argument is an instance of this class.

- `ClassBase:isSubclassOf(classDefinition)`

  Class method. Checks if class itself is a child class of a different class (or a child of a child, etc). 
Can be used as `YourClass:isInstanceOf(YourOtherClass)`.

  Parameters:

    1. `classDefinition`: `ClassDefinition` Class created by `class()` function.

  Returns:

    - `boolean` True if this class is a child of another class (or a child of a child, etc).

- `ClassBase:include(mixin)`

  Class method. Includes mixin, adding new methods to a preexising class. If mixin has a property `included`, it will be called
with an argument referencing a class mixin is being added to. Can be used as `YourClass:include({ newMethod = function(self, arg) end })`.

  Parameters:

    1. `mixin`: `ClassMixin` Any mixin.

- `ClassBase:subclass(...)`

  Class method. Creates a new child class.

  Returns:

    - `ClassDefinition` New class definition

- `ClassBase:subclassed(classDefinition)`

  Class method. Called when a new child class is created using this class as a parent one. Redefine this function for
your class if you need some advanced processing, like adding new methods to a child class.

  Parameters:

    1. `classDefinition`: `ClassDefinition` New class definition
## Class ClassPool
A base class for objects with pooling. Doesn’t add anything, but you can add it as a parent class
so that `recycled()` would be documented.

- `ClassPool:recycled()`

  Called when object is about to get recycled.

  Returns:

    - `boolean` Return false if this object should not be recycled and instead destroyed as usual.
## Function class(name, parentClass, flags)
Create a new class. Example:

```lua
local MyClass = class('MyClass')        -- class declaration

function MyClass:initialize(arg1, arg2) -- constructor
  self.myField = arg1 + arg2            -- field
end

function MyClass:doMyThing()            -- method
  print(self.myField)
end

local instance = MyClass(1, 2)          -- creating instance of a class
instance:doMyThing()                    -- calling a method
```

Whole thing is very similar to [middleclass](https://github.com/kikito/middleclass), but it’s a different
implementation that should be somewhat faster. Main differences:

1. Class name is stored in `YourClass.__name` instead of `YourClass.name`.

2. There is no `.static` subtable, all static fields and methods are instead stored in main class
   table and thus are available as instance fields and methods as well (that’s why `YourClass.name` was
   renamed to `YourClass.__name`, to avoid possible confusion with a common field name). It’s a bit
   messier, especially with class methods such as `:subclass()`, but it has some advantages as well:
   objects creation is faster, and it’s more EmmyLua-friendly (both of which is what it’s all about).

3. Overloaded `__tostring`, `__len` and `__call` are inherited, but not other operators.

4. Method `YourClass.allocate()` works differently here and is used to create a simple table which will be
   passed to `setmetatable()`. This can help with performance if objects are created often.

Everything else should work the same, including inheritance and mixins. As for performance, some simple
tests show up to 30% faster objects creation and 40% less memory used for objects with two fields when
using `YourClass.allocate()` method instead of `YourClass:initialize()` (that alone gives about 15% increase in speed
when creating an object with two fields):

```lua
function YourClass.allocate(arg1, arg2)  -- notice . instead of :
  return { myField = arg1 + arg2 }     -- also notice, methods are not available at this stage
end
```

Other differences (new features rather than something breaking compatibility) and important notes:

1. Function `class()` takes string for class name, another class to act like a parent,
   allocate and initialize functions and flags. Everything is optional and can go in any order (with one caveat:
   allocate function should go before initialize function unless you’re using `class.Pool`). Generally there is no
   benefit in passing allocate and initialize functions here though.

2. With flag `class.NoInitialize` constructor would not look for `YourClass:initialize()` method to call at all,
   instead using only `YourClass.allocate()`. Might speed things up a bit further.

3. If you’re creating new instances really often, there is a `class.Pool` flag. It would disable the use of
   `YourClass.allocate()`, but instead allow to reuse unused objects by using `class.recycle(object)`. Recycled objects
   would end up in a pool of objects to be reused next time an instance would need to be created. Of course, it
   introduces a whole new type of errors (imagine storing a reference to a recycled item somewhere not knowing it was
   recycled and now represents something else entirely), so please be careful.

   Note 1: Method `class.recycle()` can be used with nils or non-recycle, no need to have extra checks before calling it.
 
   Note 2: Instances of child classes won’t end up in parent class pool. For such arrangements, consider adding pooling
           flag to all of child classes where appropriate.

4. Before recycling, method `YourClass:recycled()` will be called. Good time to recycle any inner elements. Also,
   return `false` from it and object would not be recycled at all.

5. To check type, `YourClass.isInstanceOf(item)` can also be used. Notice that it’s a static method, no “:” here.

All classes are considered children classes of `ClassBase`, that one is mostly for EmmyLua to pick up methods like 
`YourClass.isInstanceOf(object)`. If you’re creating your own class and want to use such methods, just add `: ClassBase`
to its EmmyLua annotation. And objects with pooling are children of `ClassPool` which is a child of `ClassBase`. Note: 
to speed things up, those classes aren’t fully real, but you can access them and their methods and even call things like
`ClassBase:include()`. Please read documentation for those functions before using them though, just to check.

  Parameters:

  1. `name`: `string` Class name.

  2. `parentClass`: `ClassBase` Parent class.

  3. `flags`: `nil|integer|`class.NoInitialize`|`class.Pool`|`class.Minimal`` Flags.

  Returns:

  - `ClassDefinition` New class definition
## Function class.recycle(item)
Recycle an item to its pool, to speed up creation and reduce work for GC. Requires class to be created with
`class.Pool` flag.

This method has protection from double recycling, recycling nils or non-recycleable items, so don’t worry about it.

  Parameters:

  1. `item`: `ClassPool|nil`
## Function class.emmy(classFn, constructorFn) return constructorFn
A trick to get `class()` to work with EmmyLua annotations nicely. Call `class.emmy(YourClass, YourClass.initialize)`
or `class.emmy(YourClass, YourClass.allocate)` (whatever you’re using) and it would give you a constructor function.
Then, use it for local reference or as a return value from module. For best results add annotations to function you’re
passing here, such as return value or argument types.

In reality is simply returns the class back and ignores second argument, but because of this definition EmmyLua thinks
it got the constructor.

  Parameters:

  1. `classFn`: `T1`

  2. `constructorFn`: `T2`

  Returns:

  - `T1|T2`
## Function ac.getPatchVersion()

  Returns:

  - `string`
## Function ac.getPatchVersionCode()
Increments with every CSP build.

  Returns:

  - `integer`
## Function ac.loadINIppFile(iniFilename, includeDirs)
Load and parse INIpp configuration file (supports includes and such), return it as JSON. Deprecated, use `ac.INIConfig.load()` instead.

  Parameters:

  1. `iniFilename`: `string`

  2. `includeDirs`: `string|nil` Newline separated path to folders to search for included files in. Default value: `nil`.

  Returns:

  - `string`
## Function ac.getMGUKDeliveryName(carIndex, programIndex)
Returns name of MGUK delivery program. If there is no such car or program, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `programIndex`: `integer?` 0-based program index (if negative, name of currently selected program will be returned. Default value: -1.

  Returns:

  - `string`
## Function ac.getTyresName(carIndex, compoundIndex)
Get short name of a tyre set, either currently selected or with certain index. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `compoundIndex`: `integer?` 0-based tyre set index, if set to -1, short name of currently selected tyre set will be returned. Default value: -1.

  Returns:

  - `string`
## Function ac.getTyresIndex(carIndex, tyresShortName)
Get 0-based index of a tyres set with a given short name, or -1 if there is no such tyres set (or such car).

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `tyresShortName`: `string` Short tyres set name (usually a couple of symbols long).

  Returns:

  - `integer`
## Function ac.getTyresLongName(carIndex, compoundIndex, includePostfix)
Returns long name of a tyre set with certain index. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `compoundIndex`: `integer?` 0-based tyre set index, if set to -1, short name of currently selected tyre set will be returned. Default value: -1.

  3. `includePostfix`: `boolean?` Set to `false` to skip short name postfix. Default value: `true`.

  Returns:

  - `string`
## Function ac.getCarID(carIndex)
Get car ID (name of its folder) of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getCarName(carIndex, includeYearPostfix)
Get car name (from its JSON file) of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `includeYearPostfix`: `boolean?` Set to `true` to add a year postfix. Default value: `false`.

  Returns:

  - `string`
## Function ac.getCarSkinID(carIndex)
Get selected skin ID of (name of skin’s folder) of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getCarBrand(carIndex)
Get name of a manufacturer of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getCarCountry(carIndex)
Get name of manufactoring country of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.hasTrackSpline()
Refers to AI spline.

  Returns:

  - `boolean`
## Function ac.worldCoordinateToTrackProgress(v)
Finds nearest point on track AI spline (fast_lane) and returns its normalized position. If there is no track spline, returns -1.

  Parameters:

  1. `v`: `vec3`

  Returns:

  - `number`
## Function ac.getTrackAISplineSides(v)
Returns distance from AI spline to left and right track boundaries.

  Parameters:

  1. `v`: `number` Lap progress from 0 to 1.

  Returns:

  - `vec2` X for left side, Y for right side.
## Function ac.trackProgressToWorldCoordinate(v, linear)

  Parameters:

  1. `v`: `number`

  2. `linear`: `boolean?` Use linear interpolation. Default value: `false`.

  Returns:

  - `vec3`
## Function ac.trackProgressToWorldCoordinateTo(v, r, linear)

  Parameters:

  1. `v`: `number`

  2. `r`: `vec3`

  3. `linear`: `boolean?` Use linear interpolation. Default value: `false`.
## Function ac.worldCoordinateToTrack(v)
Converts world coordinates into track coordinates. Track coordinates:
 - X for normalized position (0 — right in the middle, -1 — left side of the track, 1 — right size);
 - Y for height above track in meters;
 - Z for track progress.

  Parameters:

  1. `v`: `vec3`

  Returns:

  - `vec3`
## Function ac.trackCoordinateToWorld(v)
Converts track coordinates into world coordinates. Track coordinates:
 - X for normalized position (0 — right in the middle, -1 — left side of the track, 1 — right size);
 - Y for height above track in meters;
 - Z for track progress.

  Parameters:

  1. `v`: `vec3`

  Returns:

  - `vec3`
## Function ac.getTrackCoordinatesDeg(worldPos)
Returns track world coordinates in degrees.

  Parameters:

  1. `worldPos`: `vec3|nil` Added in 0.2.8. If set, function returns coordinates of this point instead. Default value: `nil`.

  Returns:

  - `vec2` X for latitude, Y for longitude.
## Function ac.getTrackTimezoneBaseDst(time)
Returns timezone offset for the track in seconds.

  Parameters:

  1. `time`: `number?` If set, returns timezone for given timestamp (DST might differ). Default value: `nil`.

  Returns:

  - `vec2` X for base offset, Y for summer time offset.
## Function ac.getTrackSectorName(trackProgress)
Name of a sector.

  Parameters:

  1. `trackProgress`: `number` Track position from 0 to 1.

  Returns:

  - `string`
## Function ac.dirname()
Returns directory of the script.

  Returns:

  - `string`
## Function ac.findFile(fileName)
If `fileName` is not an absolute path, looks for a file in script directory, then relative to CSP folder,
then relative to AC root folder. If anything is found, returns an absolute path to found file, otherwise
returns input parameter. If such a filename is not allowed, or `fileName` is `nil`, returns an empty string.

  Parameters:

  1. `fileName`: `string` File name relative to script folder, or CSP folder, or AC root folder.

  Returns:

  - `path`
## Function ac.getFolder(folderID)
Returns full path to one of known folders. Some folders might not exist, make sure to create them before writing.

  Parameters:

  1. `folderID`: `ac.FolderID|string` Could also be a system GUID in “{XX…}” form.

  Returns:

  - `string` Returns empty string if there is no match.
## Function ac.lapTimeToString(time, allowHours)
Turns time in milliseconds into common lap time presentation, like 00:00.123. If minutes exceed 60,
hours will also be added, but only if `allow_hours` is `true` (default is `false`).

  Parameters:

  1. `time`: `number` Time in milliseconds.

  2. `allowHours`: `boolean?` Set to `true` to add hours as well. If `false` (default value), instead it would produce 99:99.999. If `true`, milliseconds will use two digits instead of three. Default value: `false`.

  Returns:

  - `string`
## Function ac.getCountryName(nationCode)
Returns country name based on nation code (three symbols for country ID).

  Parameters:

  1. `nationCode`: `ac.NationCode`

  Returns:

  - `string`
## Function ac.readDataFile(filename)
Can be used to access files in “data.acd” and, for example, read car specs.

  Parameters:

  1. `filename`: `string`

  Returns:

  - `string`
## Function ac.parseINIppFile(iniData)
Parse INIpp configuration file, return it as JSON. Deprecated, use `ac.INIConfig.parse()` instead.

  Parameters:

  1. `iniData`: `string`

  Returns:

  - `string`
## Function ac.getTrackId()
Use `ac.getTrackID()` instead.

  Returns:

  - `string`
## Function ac.getTrackID()
Returns track ID (name of its folder).

  Returns:

  - `string`
## Function ac.getTrackLayout()
Returns track layout ID (name of layout folder, without name of track folder), or empty string if there is no layout.

  Returns:

  - `string`
## Function ac.getTrackFullID(separator)
Returns full track ID (name of track folder and layout folder joined by some string, or just name of track folder if there is no layout).

  Parameters:

  1. `separator`: `string?` Default value: '-'.

  Returns:

  - `string`
## Function ac.getTrackName()
Returns track name (as set in its JSON file).

  Returns:

  - `string`
## Function ac.getTrackDataFilename(fileName)
Given name, returns a path like …/assettocorsa/content/tracks/[track ID]/data/[name], taking into account layout as well.

  Parameters:

  1. `fileName`: `string`

  Returns:

  - `string`
## Function ac.getCarTags(carIndex)
Get car tags. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.uniqueMachineKey()
A key unique for each individual PC (uses serial numbers of processor and motherboard).
Use `ac.uniqueMachineKeyAsync()` instead.

  Returns:

  - `string`
## Function ac.uniqueMachineKeyAsync(callback)
A key unique for each individual PC (uses serial numbers of processor and motherboard). Asynchronous version. Returned value is in binary,
use something like `ac.encodeBase64()` to encode data in readable format.

  Parameters:

  1. `callback`: `fun(err: string?, response: string?)`
## Function ac.distanceToRenderSquared(pos)
Returns squared distance to main camera. In splitscreen mode, returns smallest distance between to cameras. In the future, might be altered by
more entities, such as additional OBS cameras. Useful if you have a detail level changing with distance.

  Parameters:

  1. `pos`: `vec3`

  Returns:

  - `number`
## Function ac.distanceToRender(pos)
Returns distance to main camera. In splitscreen mode, returns smallest distance between to cameras. In the future, might be altered by
more entities, such as additional OBS cameras. Useful if you have a detail level changing with distance.

  Parameters:

  1. `pos`: `vec3`

  Returns:

  - `number`
## Function ac.closerToRenderThan(pos, distance)
Returns `true` if position is closer to main camera than the threshold. In splitscreen mode, considers secondary camera. In the future, might be altered by
more entities, such as additional OBS cameras. Useful if you have a detail level changing with distance.

  Parameters:

  1. `pos`: `vec3`

  2. `distance`: `number`

  Returns:

  - `boolean`
## Function ac.encodeHalf(v)
Encodes float into FP16 format and returns it as uint16.

  Parameters:

  1. `v`: `number`

  Returns:

  - `integer`
## Function ac.encodeHalf2(v)
Encodes two floats from a vector into FP16 format and returns it as uint32.

  Parameters:

  1. `v`: `number|vec2`

  Returns:

  - `integer`
## Function ac.decodeHalf(v)
Decodes float from FP16 format (represented as uint16) and returns a regular number.

  Parameters:

  1. `v`: `integer`

  Returns:

  - `number`
## Function ac.decodeHalf2(v)
Decodes two floats from FP16 format (represented as uint32) and returns a vector.

  Parameters:

  1. `v`: `integer`

  Returns:

  - `vec2`
## Function ac.checksumSHA256(data)
Computes SHA-256 checksum for given binary data. Very secure, but might be slow with large amounts of data. Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `string`
## Function ac.checksumXXH(data)
Computes 64-bit xxHash checksum for given binary data. Very fast, not that great for encryption purposes.
Use `bit.tohex()` to turn result into a hex representation. Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `integer`
## Function ac.compress(data, type, level)
Compresses data. First byte of resulting data is compression type, next four are uncompressed data size, rest is compressed data
itself. If data is failed to compress, returns `nil`. Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  2. `type`: `ac.CompressionType`

  3. `level`: `integer?` Higher level means better, but slower compression. Maximum value: 12. Default value: 9.

  Returns:

  - `string`
## Function ac.decompress(data)
Decompresses data. First byte of input data is compression type, next four are uncompressed data size. If data is damaged, returns `nil`.
Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `string`
## Function ac.encodeBase64(data, trimResult)
Encodes data in base64 format. Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  2. `trimResult`: `boolean?` If `true`, ending “=” will be trimmed. Default value: `false`.

  Returns:

  - `string`
## Function ac.decodeBase64(data)
Decodes data from base64 format (ending “=” are not needed).

  Parameters:

  1. `data`: `string`

  Returns:

  - `string`
## Function ac.utf8To16(data)
Converts string from UTF-8 to UTF-16 format (two symbols per character). All strings Lua operates with regularly are consired UTF-8. UTF-16 strings
can’t be used in any CSP API unless documentation states that function can take strings containing zeroes.

  Parameters:

  1. `data`: `string`

  Returns:

  - `string`
## Function ac.utf16To8(data)
Converts string from UTF-16 (two symbols per character) to common Lua UTF-8. All strings Lua operates with regularly are consired UTF-8. UTF-16 strings
can’t be used in any CSP API unless documentation states that function can take strings containing zeroes. Data string can contain zero bytes.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `string`
## Function ac.structBytes(data)
Given an FFI struct, returns bytes with its content. Resulting string may contain zeroes.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `string`
## Function ac.perfBegin(value)
Simple helper to measure time and analyze performance. Call `ac.perfBegin('someKey')` to start counting time and
 `ac.perfEnd('someKey')` to stop. Measured time will be shown in Lua App Debug app in CSP (moving average across all
 perfBegin/perfEnd calls). Note: keys on perfBegin() and perfEnd() should match.

  Parameters:

  1. `value`: `string`
## Function ac.perfEnd(value)
Simple helper to measure time and analyze performance. Call `ac.perfBegin('someKey')` to start counting time and
 `ac.perfEnd('someKey')` to stop. Measured time will be shown in Lua App Debug app in CSP (moving average across all
 perfBegin/perfEnd calls). Note: keys on perfBegin() and perfEnd() should match.

  Parameters:

  1. `value`: `string`
## Function ac.perfFrameBegin(value)
Unlike `ac.perfBegin('someKey')/ac.perfEnd('someKey')`, `ac.perfFrameBegin(0)/ac.perfFrameEnd(0)` will accumulate time
 between calls as frame progresses and then use the whole sum for moving average. This makes it suitable for measuring
 how much time in a frame repeatedly ran bit of code takes. To keep performance as high as possible (considering that
 it could be ran in a loop), it uses integer keys instead of strings.

  Parameters:

  1. `value`: `integer`
## Function ac.perfFrameEnd(value)
Unlike `ac.perfBegin('someKey')/ac.perfEnd('someKey')`, `ac.perfFrameBegin(0)/ac.perfFrameEnd(0)` will accumulate time
 between calls as frame progresses and then use the whole sum for moving average. This makes it suitable for measuring
 how much time in a frame repeatedly ran bit of code takes. To keep performance as high as possible (considering that
 it could be ran in a loop), it uses integer keys instead of strings.

  Parameters:

  1. `value`: `integer`
## Function ac.getCameraPosition()

  Returns:

  - `vec3`
## Function ac.getCameraUp()

  Returns:

  - `vec3`
## Function ac.getCameraSide()

  Returns:

  - `vec3`
## Function ac.getCameraForward()

  Returns:

  - `vec3`
## Function ac.getCameraDirection()
This vector is pointing backwards! Only kept for compatibility. For proper one, use `ac.getCameraForward()`.

  Returns:

  - `vec3`
## Function ac.getCameraFOV()
Value in degrees.

  Returns:

  - `number`
## Function ac.getCameraPositionTo(r)

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.getCameraUpTo(r)

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.getCameraSideTo(r)

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.getCameraForwardTo(r)

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.getCameraDirectionTo(r)

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.getCameraPositionRelativeToCar()
Returns camera position in car coordinates system.

  Returns:

  - `vec3`
## Function ac.getCompassAngle(dir)
Returns compass angle for given directory.

  Parameters:

  1. `dir`: `vec3`

  Returns:

  - `number` Angle from 0 to 360 (0/360 for north, 90 for east, etc.)
## Function ac.getSunAngle()
Value in degrees.

  Returns:

  - `number`
## Function ac.getSunPitchAngle()
Value in degrees.

  Returns:

  - `number`
## Function ac.getSunHeadingAngle()
Value in degrees.

  Returns:

  - `number`
## Function ac.isInteriorView()
Returns true if camera is focused on interior (interior audio is playing).

  Returns:

  - `boolean`
## Function ac.isInReplayMode()

  Returns:

  - `boolean`
## Function ac.compressTexture(filename, outputFilename)

  Parameters:

  1. `filename`: `string`

  2. `outputFilename`: `string`
## Function ac.getSoundSpeedMs()
Returns precalculated sound speed in m/s taking into account humidity, altitude, pressure, etc.

  Returns:

  - `number`
## Function ac.getAirPressure(p)
Returns air pressure in kPa.

  Parameters:

  1. `p`: `vec3`

  Returns:

  - `number`
## Function ac.getAirHumidity(p)
Returns air humidity in 0…1 range. Currently doesn’t use position parameter, but it might change later.

  Parameters:

  1. `p`: `vec3`

  Returns:

  - `number`
## Function ac.getLastError()
Returns string with last error thrown by this script, or `nil` if there wasn’t an error. Use it in case you would want to set some nicer error reporting.

  Returns:

  - `string`
## Function ac.getAudioVolume(audioChannelKey, carIndex, fallbackValue)
Returns audio volume for given channel, value from 0 to 1. If channel is not recognized, returns `fallbackValue` if specified, unless (since 0.2.4) you specify key in a
`'your.namespace/Readable name'` format: this will register a new volume level and show it in Audio Volume app for sessions where value was
accessed or set.

  Parameters:

  1. `audioChannelKey`: `ac.AudioChannel`

  2. `carIndex`: `integer?` If set and a Kunos car-related channel (`'dirt'`, `'engine'`, `'opponents'`, `'surfaces'`, `'transmission'`, `'tyres'`, `'wind'`) is used, returns a car-specific multiplier (1 by default). Default value: -1.

  3. `fallbackValue`: `number?` Default value: -1.

  Returns:

  - `number` Value from 0 to 1, or -1 if there is no such channel.
## Function ac.getAudioOutputDevice()
Returns name of output audio device.

  Returns:

  - `string`
## Function ac.getCarSpeedKmh(carIndex)
Consider using `ac.getCar(carIndex).speedKmh` instead.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `number`
## Function ac.getCarGearLabel(carIndex)
Returns 'R', 'N', number of engaged gear or value set by `ac.setGearLabel()` if used (for implementing automatic gearboxes).
If your code is displaying current gear, this might be a preferable choice.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getGroundYApproximation()
Returns approximate Y coordinate of ground, calculated by using depth from reflection cubemap. Does not have a performance impact (that value
 will be calculated anyway for CSP to run.

  Returns:

  - `number`
## Function ac.getDeltaT()
Returns current delta time associated with UI (so values are non-zero if sim or replay are paused).

  Returns:

  - `number` Seconds.
## Function ac.getGameDeltaT()
Returns current delta time associated with simulation (so values are zero if sim or replay are paused).

  Returns:

  - `number` Seconds.
## Function ac.getScriptDeltaT()
Returns delta time for current script. If script only runs every N frames (like car display scripts by default),
this value will be greater than regular `dt` from simulation state.

  Returns:

  - `number`
## Function ac.getConditionsTimeScale()
Returns current time multiplier.

  Returns:

  - `number`
## Function ac.getPpFilter()
Returns name of current PP filter with “.ini”.

  Returns:

  - `string`
## Function ac.getWindVelocity()
Value is in m/s.

  Returns:

  - `vec3`
## Function ac.getWindVelocityTo(r)
Value is in m/s.

  Parameters:

  1. `r`: `vec3` Destination.
## Function ac.isWeatherFxActive()

  Returns:

  - `boolean`
## Function ac.getTrackUpcomingTurn(carIndex)
Distance and turn angle (in degrees) for the upcoming turn. If failed to compute, both would be -1. If car is facing wrong way, turn angle is either
180° or -180° depending on where steering wheel of a car is.

  Parameters:

  1. `carIndex`: `integer?` Default value: 0.

  Returns:

  - `vec2`
## Function ac.getDriverName(carIndex)
Get full driver name of a driver of a certain car. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getDriverNationCode(carIndex)
Get three character nation code of a driver of a certain car. Nation code is a three-letter uppercase country identifier. If nationality is not set, a value from JSON
is returned. If it’s missing there, a fallback “ITA” is returned. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getDriverNationality(carIndex)
Get full nationality of a driver of a certain car. Usually, it’s a full country name. If nationality is not set, a value from JSON
is returned. If it’s missing there, a fallback “Italy” is returned. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getDriverTeam(carIndex)
Get name of a team of a driver of a certain car. Team names can be configured in entry list online. If nationality is not set, a value from JSON
is returned. If it’s missing there, an empty string is returned. If there is no such car, returns `nil`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getDriverNumber(carIndex)
Get number of a driver of a certain car. If number is set in skin JSON, it will be returned, otherwise it’s a unique 1-based number.
If there is no car with such index, 0 is returned.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `integer`
## Function ac.isCustomIconSet(carIndex)
Returns `true` if a certain driver is using custom icon. Use `'carN::special::driver'` as image filename to draw it (when not custom,
will give you a livery icon or a fallback dark image).

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `boolean`
## Function ac.getSessionName(sessionIndex)
Get session name for a session with given index. Use `ac.getSim()` to check number of sessions and more information about them.
If there is no such session, returns `nil`.

  Parameters:

  1. `sessionIndex`: `integer`

  Returns:

  - `string`
## Function ac.isKeyDown(keyIndex)
Is keyboard button being held.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  Returns:

  - `boolean`
## Function ac.isKeyPressed(keyIndex)
Is keyboard button just moved from not held to held in the last graphics frame (or, for physics scripts since 0.2.7, physics frame).
Still, if you’re working on car physics script, consider using `ac.ControlButton()` instead for better customization. If your script is skipping frames
(such as car display scripts), this might not work as expected, as the frame the button has changed the state in could be skipped.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  Returns:

  - `boolean`
## Function ac.isKeyReleased(keyIndex)
Is keyboard button just moved from held to not held in the last graphics frame (or, for physics scripts since 0.2.7, physics frame).
If you’re working on car physics script, consider using `ac.ControlButton()` instead for better customization. If your script is skipping frames
(such as car display scripts), this might not work as expected, as the frame the button has changed the state in could be skipped.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  Returns:

  - `boolean`
## Function ac.isVisibleInMainCamera(pos, radius, gSpace, includeFarPlane)
Can be called from anywhere. Checks if given point is within main camera frustum (or several, in triple screen mode) or not. For checking if something
is within current camera instead, try `render.isVisible()`.

  Parameters:

  1. `pos`: `vec3`

  2. `radius`: `number`

  3. `gSpace`: `boolean?` Pass `false` if your coordinates are in world-space rather than with origin shift applied (in most cases, you need to use `false`, this argument is added for backwards compatibility. Default value: `true`.

  4. `includeFarPlane`: `boolean?` Pass `false` to ignore far plane. Default value: `true`.

  Returns:

  - `boolean` Checks visibility with frustum culling.
## Function ac.getControllerSteerValue()
Returns steering input from -1 to 1.

  Returns:

  - `number`
## Function ac.isControllerGasPressed()
Is gas input pressed (pedal, gamepad axis, keyboard button but not mouse button).

  Returns:

  - `boolean`
## Function ac.isControllerGearUpPressed()
Is gear up input pressed (pedal, gamepad button, keyboard button).

  Returns:

  - `boolean`
## Function ac.isControllerGearDownPressed()
Is gear down input pressed (pedal, gamepad button, keyboard button).

  Returns:

  - `boolean`
## Function ac.getSessionSpawnSet(sessionIndex)
Get session spawn set (`'START'`, `'PIT'`, `'HOTLAP_START'`, `'TIME_ATTACK'`, etc.) for a session with given index. Use `ac.getSim()`
to check number of sessions and more information about them. If there is no such session, returns `nil`.

  Parameters:

  1. `sessionIndex`: `integer`

  Returns:

  - `string`
## Function ac.forceVisibleHeadNodes(carIndex, force)
Forces driver head to be visible even with cockpit camera.

  Parameters:

  1. `carIndex`: `integer`

  2. `force`: `boolean?` Default value: `true`.
## Function ac.isGamepadButtonPressed(gamepadIndex, gamepadButtonID)
Checks if a certain gamepad button is pressed.

  Parameters:

  1. `gamepadIndex`: `integer` 0-based index, from 0 to 7 (first four are regular gamepads, second four are Dual Shock controllers).

  2. `gamepadButtonID`: `ac.GamepadButton`

  Returns:

  - `boolean`
## Function ac.getGamepadAxisValue(gamepadIndex, gamepadAxisID)
Returns value of a certain gamepad axis.

  Parameters:

  1. `gamepadIndex`: `integer` 0-based index, from 0 to 7 (first four are regular gamepads, second four are Dual Shock controllers).

  2. `gamepadAxisID`: `ac.GamepadAxis`

  Returns:

  - `number`
## Function ac.getJoystickCount()
Returns number of DirectInput devices (ignore misleading name).

  Returns:

  - `integer`
## Function ac.getJoystickName(joystick)
Returns name of a DirectInput device (ignore misleading name). If there is no such device, returns `nil`.

  Parameters:

  1. `joystick`: `integer` 0-based index.

  Returns:

  - `string`
## Function ac.getJoystickInstanceGUID(joystick)
Returns instance GUID of a DirectInput device (ignore misleading name). If there is no such device, returns `nil`.

  Parameters:

  1. `joystick`: `integer` 0-based index.

  Returns:

  - `string`
## Function ac.getJoystickProductGUID(joystick)
Returns product GUID of a DirectInput device (ignore misleading name). If there is no such device, returns `nil`.

  Parameters:

  1. `joystick`: `integer` 0-based index.

  Returns:

  - `string`
## Function ac.getJoystickIndexByInstanceGUID(guid)
Returns index of a DirectInput device by its instance GUID, or `nil` if there is no such device (ignore misleading name).

  Parameters:

  1. `guid`: `string`

  Returns:

  - `integer`
## Function ac.getJoystickAxisCount(joystick)
While this function returns accurate number of device axis, consider using 8 instead if you need to iterate over them.
Actual axis can be somewhere within those 8. For example, if device has a single axis, it could be that you need to access
axis at index seven to get its value (rest will be zeroes).

  Parameters:

  1. `joystick`: `integer`

  Returns:

  - `integer`
## Function ac.getJoystickButtonsCount(joystick)
Returns number of buttons of a DirectInput device (ignore misleading name).

  Parameters:

  1. `joystick`: `integer`

  Returns:

  - `integer`
## Function ac.getJoystickDpadsCount(joystick)
Returns number of D-pads (aka POVs) of a DirectInput device (ignore misleading name).

  Parameters:

  1. `joystick`: `integer`

  Returns:

  - `integer`
## Function ac.isJoystickButtonPressed(joystick, button)
Checks if a button of a DirectInput device is currently held down (ignore misleading name).

  Parameters:

  1. `joystick`: `integer`

  2. `button`: `integer`

  Returns:

  - `boolean`
## Function ac.getJoystickAxisValue(joystick, axis)
Returns axis value of a DirectInput device (ignore misleading name).

  Parameters:

  1. `joystick`: `integer`

  2. `axis`: `integer`

  Returns:

  - `number`
## Function ac.isJoystickAxisValue(joystick, axis)
Use `ac.getJoystickAxisValue()` instead.

  Parameters:

  1. `joystick`: `integer`

  2. `axis`: `integer`

  Returns:

  - `number`
## Function ac.getJoystickDpadValue(joystick, dpad)
Returns D-pad (aka POV) value of a DirectInput device (ignore misleading name).

  Parameters:

  1. `joystick`: `integer`

  2. `dpad`: `integer`

  Returns:

  - `integer` If D-pad is not moved, -1, or a value from 0 to 36000 storing the angle (0: up, 9000: right).
## Function ac.isJoystickDpadValue(joystick, dpad)
Use `ac.getJoystickDpadValue()` instead.

  Parameters:

  1. `joystick`: `integer`

  2. `dpad`: `integer`

  Returns:

  - `integer`
## Function ac.getPenPressure()
Checks current stylus/pen/mouse using RealTimeStylus API (compatible with Windows Ink). Should support things like Wacom tables (if drivers are installed
and Windows Ink compatibility in options is not disabled).

Note: the moment its called, CSP initializes RealTimeStylus API to monitor pen state until game closes. With that, CSP will also use that data
for mouse (or pen) pointer interaction with UI in general, especially for IMGUI apps.
[There is a weird issue in Windows 10](https://answers.microsoft.com/en-us/windows/forum/all/windows-pen-tablet-click-and-drag-lag/9e4cac7d-69a0-4651-87e8-7689ce0d1027)
where it doesn’t register short click-and-drag events properly expecting a touchscreen gesture. Using RealTimeStylus API for UI in general solves that.

  Returns:

  - `number` Pen pressure from 0 to 1 (if mouse is used, pressure is 1).
## Function ac.getServerName()
Returns name of the current online server, or `nil` if it’s not available.

  Returns:

  - `string`
## Function ac.getServerIP()
Returns IP address of the current online server, or `nil` if it’s not available.

  Returns:

  - `string`
## Function ac.getServerPortHTTP()
Returns HTTP post of the current online server, or -1 if it’s not available.

  Returns:

  - `integer`
## Function ac.getServerPortTCP()
Returns TCP post of the current online server, or -1 if it’s not available.

  Returns:

  - `integer`
## Function ac.getServerPortUDP()
Returns UDP post of the current online server, or -1 if it’s not available.

  Returns:

  - `integer`
## Function ac.getCarByDriverName(driverName)
Returns index of a car with a driver with a certain name, or -1 if there is no such car.

  Parameters:

  1. `driverName`: `string`

  Returns:

  - `integer`
## Function ac.getCarLeaderboardPosition(carIndex)
Returns leaderboard car position, same as Python function with the same name. Does not work online. For an alternative solution,
get position calculated by CSP via `ac.getCar(N).racePosition`

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `integer` Returns -1 if couldn’t calculate the value.
## Function ac.getCarRealTimeLeaderboardPosition(carIndex)
Returns real time car position, same as Python function with the same name. Does not work online. For an alternative solution,
get position calculated by CSP via `ac.getCar(N).racePosition`.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  Returns:

  - `integer` Returns -1 if couldn’t calculate the value.
## Function ac.getMoonFraction()
How much of moon area is currently lit up.

  Returns:

  - `number`
## Function ac.getAltitude()

  Returns:

  - `number`
## Function ac.getSkyFeatureDirection(skyFeature, distance, time)
Get direction to a sky feature in world-space (corrected for track heading). If feature is not available, returns a zero vector.

  Parameters:

  1. `skyFeature`: `ac.SkyFeature`

  2. `distance`: `number|refnumber|nil` Default value: `nil`.

  3. `time`: `number?` If set, it’ll compute direction for the given time instead of the current time. Default value: `nil`.

  Returns:

  - `vec3`
## Function ac.getSkyStarDirection(declRad, rightAscRad)
Get direction to a star in the sky in world-space (corrected for track heading). If feature is not available, returns a zero vector.

  Parameters:

  1. `declRad`: `number`

  2. `rightAscRad`: `number`

  Returns:

  - `vec3`
## Function ac.refreshCarShape(carIndex)
Call this function if your script caused car shape to change and CSP would refresh interior masking, car heightmap and more.

  Parameters:

  1. `carIndex`: `integer?` Default value: 0.
## Function ac.refreshCarColor(carIndex)
Call this function if your script caused car color to change and CSP would refresh color map for bounced light and more.

  Parameters:

  1. `carIndex`: `integer?` Default value: 0.
## Function ac.updateDriverModel(carIndex, forceVisible)
Updates state of high-res driver model. Use it before moving driver nodes manually for extra animations: if called,
 next model update possibly overwriting your custom positioning will be skipped. Also, model update will be enforced
 so you can blend your custom state.

 Since 0.1.80-preview397, does not apply if HR driver model is currently hidden unless second argument is `true` (in which
 case it’ll activate driver model for a few frames).

  Parameters:

  1. `carIndex`: `integer?` For car scripts, always applied to associated car instead. Default value: -1.

  2. `forceVisible`: `boolean?` Set to `true` to forcefully switch to HR model for a few frames. Default value: `false`.
## Function ac.getDriverHeadTransformTo(ret, carIndex)

  Parameters:

  1. `ret`: `mat4x4`

  2. `carIndex`: `integer`

  Returns:

  - `boolean`
## Function ac.blockSystemMessages(regex)
Block system messages based on a given regular expression.

  Parameters:

  1. `regex`: `string` Any message with title or description containing this regex will be discarded.

  Returns:

  - `ac.Disposable`
## Function ac.onTrackPointCrossed(carIndex, progress, callback)
Sets a callback which will be called when car crosses a certain point on a track. Won’t be triggered if car is in pitlane or recently jumped.
Time is relative to the same point as `ac.SimState.time`. Tracking happens on physics thread and is interpolated based on car position, so it
should be precise more than within 3 ms steps.

  Parameters:

  1. `carIndex`: `integer` 0-based car index, or -1 for an event to be called for all cars.

  2. `progress`: `number` Track progress from 0 to 1.

  3. `callback`: `fun(carIndex: integer, timeMs: number)`

  Returns:

  - `ac.Disposable`
## Function ac.onSessionStart(callback)
Sets a callback which will be called when a new session starts (or restarts). Doesn’t get triggered at the start of the race (Lua scripts load when
the first session is already up and running to ensure the overall state of the sim is complete)!

  Parameters:

  1. `callback`: `fun(sessionIndex: integer, restarted: boolean)`

  Returns:

  - `ac.Disposable`
## Function ac.onResolutionChange(callback)
Sets a callback which will be called when AC resolution changes. Happens when window size changes, or when making a screenshot.
Note: some scripts, such as WeatherFX style or post-processing script, reload completely when resolution changes, but if they’d call
this function at any point, they would no longer reload. Instead CSP assumes they can handle resolution changes on their side.

  Parameters:

  1. `callback`: `fun(newSize: vec2, makingScreenshot: boolean)`

  Returns:

  - `ac.Disposable`
## Function ac.onTyresSetChange(carIndex, callback)
Sets a callback which will be called when selected tyres change for some car. For car scripts to track changes in their own car, use `car.index` as first argument.
 Note: for physics scripts this even might come a few frames late, but it shouldn’t be a major issue since tyres changes only happen when car is stationary anyway.

  Parameters:

  1. `carIndex`: `integer` 0-based car index, or -1 for an event to be called for all cars.

  2. `callback`: `fun(carIndex: integer, setIndex: integer, shortName: string, longName: string)`

  Returns:

  - `ac.Disposable`
## Function ac.onClientConnected(callback)
Sets a callback which will be called when new user connects the server and their car appears (doesn’t do anything outside of online race).

  Parameters:

  1. `callback`: `fun(connectedCarIndex: integer, connectedSessionID: integer)`

  Returns:

  - `ac.Disposable`
## Function ac.onClientDisconnected(callback)
Sets a callback which will be called when a user disconnects (doesn’t do anything outside of online race).

  Parameters:

  1. `callback`: `fun(connectedCarIndex: integer, connectedSessionID: integer)`

  Returns:

  - `ac.Disposable`
## Function ac.onControlSettingsChanged(callback)
Sets a callback which will be called when control settings change live.

  Parameters:

  1. `callback`: `fun()`

  Returns:

  - `ac.Disposable`
## Function ac.onTripleConfigurationChanged(callback)
Sets a callback which will be called when triple screen configuration changes.

  Parameters:

  1. `callback`: `fun()`

  Returns:

  - `ac.Disposable`
## Function ac.isLuaAppRunning(appID)
Returns `true` if a Lua app with given ID is loaded and currently active (not countring background services).

  Parameters:

  1. `appID`: `string`

  Returns:

  - `boolean`
## Function ac.getCarOptimalBrakingAmount(carIndex)
Returns an estimate of optimal braking amount based on current grip level, or -1 if it can’t be computed for a given car.

  Parameters:

  1. `carIndex`: `integer`

  Returns:

  - `number`
## Function ac.getCarMaxSpeedWithGear(carIndex, gearIndex)
Returns an estimate of maximum speed for a given gear in km/h, -1 if it can’t be computed for a given car, or 0 if there is no such gear. Returns negative
speed for the reverse gear.

  Parameters:

  1. `carIndex`: `integer`

  2. `gearIndex`: `integer` Gear index, 1 for first gear (same as `ac.getCar().gear`).

  Returns:

  - `number` Returns speed in km/h.
## Function ac.storageSetPath(relativePath, prefix)
Changes location of script storage. Scripts without I/O access will have “shared-” appended to their relative path and can’t use “.” or slashes in it
to ensure configs are contained within the directory. Note: before 0.2.4 calls to this function by scripts without I/O access would have no effect.

  Parameters:

  1. `relativePath`: `string` Path relative to directory with Lua configs. If empty, call won’t have an effect.*/.

  2. `prefix`: `string|nil` Optional prefix. Default value: `nil`.
## Function ac.broadcastSharedEvent(key, data)
Broadcasts a shared event. With shared events, different Lua scripts can exchange messages and data. Make sure to come up with
a unique name for your events to avoid collisions with other scripts and Lua apps.

Callbacks will be called next time the script is updating.

Note: if your scripts need to exchange data frequently, consider using `ac.connect()` instead, as it allows to establish a typed connection
with much less overhead.

  Parameters:

  1. `key`: `string`

  2. `data`: `serializable`

  Returns:

  - `integer` Returns number of listeners to the event with given key.
## Function ac.onSharedEvent(key, callback, processPostponed)
Subscribes to a shared event. With shared events, different Lua scripts can exchange messages and data. Make sure to come up with
a unique name for your events to avoid collisions with other scripts and Lua apps.

Callback will be called next time this script is updating.

  Parameters:

  1. `key`: `string`

  2. `callback`: `fun(data: string|number|boolean|nil, senderName: string, senderType: string, senderID: integer)`

  3. `processPostponed`: `boolean?` Set to `true` to process previously broadcasted and yet non-processed events (up to 40). Default value: `false`.

  Returns:

  - `ac.Disposable`
## Function ac.onLuaScriptDisposal(callback)

  Parameters:

  1. `callback`: `fun(senderName: string, senderType: string, senderID: integer)`

  Returns:

  - `ac.Disposable`
## Function ac.setVRHandBusy(hand, busy)

  Parameters:

  1. `hand`: `integer` 0 for left, 1 for right.

  2. `busy`: `boolean|`true`|`false`` Busy hand doesn’t have visual marks and doesn’t interact with UI and car elements.
## Function ac.setVRHandVibration(hand, frequency, amplitude, duration)

  Parameters:

  1. `hand`: `integer` 0 for left, 1 for right.

  2. `frequency`: `number`

  3. `amplitude`: `number`

  4. `duration`: `number?` Duration in seconds. Default value: 0.01.
## Function ac.isModuleActive(cspModuleID)

  Parameters:

  1. `cspModuleID`: `ac.CSPModuleID`

  Returns:

  - `boolean`
## Function ac.getPerformanceCPUAndGPUTime()

  Returns:

  - `number`
## Function ac.getCarIndexInFront(carMainIndex, distance)
Returns index of a car in front of other car (within 100 m), or -1 if there is no such car. Broken, not sure why is it even here, kept for compatibility.

  Parameters:

  1. `carMainIndex`: `integer`

  2. `distance`: `number|refnumber|nil` Default value: `nil`.

  Returns:

  - `integer`
## Function ac.getGapBetweenCars(carMainIndex, carComparingToIndex)
Calculates time gap between two cars in seconds. In race sessions uses total driven distance and main car speed, in other sessions simply
compares best lap times. If main car is ahead of comparing-to car (in front of, or has better lap time for non-race sessions), value will
be negative.

In the future implementation might change for something more precise.

  Parameters:

  1. `carMainIndex`: `integer` 0-based index.

  2. `carComparingToIndex`: `integer` 0-based index.

  Returns:

  - `number`
## Function ac.mediaCurrentPeak(output)
Returns audio peak level for the system, for left and right channels. Careful: AC audio is also included, but
it still might be used to fake some audio visualization.

  Parameters:

  1. `output`: `boolean?` Set to `false` to monitor peak from a microphone. Note: it would only work if there are other processes actually listening to audio. Default value: `true`.

  Returns:

  - `vec2`
## Function ac.setTextureKey(key)
Set texture key to load encoded textures.

  Parameters:

  1. `key`: `string?` Key to decode subsequently loading textures.
## Function ac.encodeTexture(filename, outputFilename, key, applyLz4Compression)
Encode texture. To load texture later, first call `ac.setTextureKey()`.

  Parameters:

  1. `filename`: `string` Input filename.

  2. `outputFilename`: `string` Should be inside of AC folder.

  3. `key`: `string?`

  4. `applyLz4Compression`: `boolean?`

  Returns:

  - `boolean` Returns `false` if file operations failed.
## Function ac.onAlbumCoverUpdate(callback)
Sets a callback which will be called when album cover changes.

  Parameters:

  1. `callback`: `fun(hasCover: boolean)`

  Returns:

  - `ac.Disposable`
## Function ac.mediaNextTrack()
Switches to the next track in currently active music player (by simulating media key press).
function ac.mediaNextTrack() end
## Function ac.mediaPreviousTrack()
Switches to the previous track in currently active music player (by simulating media key press).
function ac.mediaPreviousTrack() end
## Function ac.mediaPlayPause()
Pauses or unpauses current track in currently active music player (by simulating media key press).
function ac.mediaPlayPause() end
## Function ac.getCarSetupState()
Returns player’s car setup state.
## Function ac.console(message, withoutPrefix)
Prints message to AC console.

  Parameters:

  1. `message`: `string?`

  2. `withoutPrefix`: `boolean?` Default value: `false`.
## Function ac.areTyresLegal(name)
Returns `false` if tyres with this short name are illegal in this race. Note: if all of car tyres are illegal, all of them will be legal.

  Parameters:

  1. `name`: `string`

  Returns:

  - `boolean`
## Function ac.setMessage(title, description, type, time)
Show message using AC system messages UI. Pass empty `title` and `description` to hide currently shown message, if any.

 Types:
 - Default: regular message shown on top in white text.
 - 'illegal': message about an illegal violation. Can be used to warn driver about a crucial mistake, such as lap time
being invalidated, or wear plank wear exceeding allowed limit. Doesn’t apply any penalties on its own.

  Parameters:

  1. `title`: `string`

  2. `description`: `string`

  3. `type`: `nil|'illegal'` Optional message type.

  4. `time`: `number?` Time to show message for in seconds. Default value: 5.
## Function ac.onMessage(callback)
Listen to messages, including the ones shown by `ac.setMessage()` and `ac.setIllegalMessage()`.

  Parameters:

  1. `callback`: `fun(title: string, description: string, type: nil|'illegal', time: number)`

  Returns:

  - `ac.Disposable`
## Function ac.setSystemMessage(title, description)
Use `ac.setMessage()` instead.

  Parameters:

  1. `title`: `string`

  2. `description`: `string`
## Function ac.setClipboardText(text)
Sets given text to the clipboard.

  Parameters:

  1. `text`: `string`

  Returns:

  - `boolean` Returns `false` if failed.
## Function ac.onCarJumped(carIndex, callback)
Sets a callback which will be called when car teleports somewhere or its state gets reset.

  Parameters:

  1. `carIndex`: `integer` 0-based car index, or -1 for an event to be called for all cars.

  2. `callback`: `fun(carIndex: integer)`

  Returns:

  - `ac.Disposable`
## Function ac.onCarCollision(carIndex, callback)
Sets a callback which will be called when car collides with a wall or another car. Note: collisions in AC are usually lasting a few frames,
but this callback will only be called once when collision starts (or when index of a car this car collided with has changed). Use
`ac.getCar().collisionDepth` and similar to analyze the collision in detail.

  Parameters:

  1. `carIndex`: `integer` 0-based car index, or -1 for an event to be called for all cars.

  2. `callback`: `fun(carIndex: integer)`

  Returns:

  - `ac.Disposable`
## Function ac.onFileChanged(filename, callback)
Sets a callback which will be called when a file changes.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path` Full path to a file to monitor.

  2. `callback`: `fun()` Callback function.

  Returns:

  - `ac.Disposable`
## Function ac.onFolderChanged(folder, filter, recursive, callback)
Sets a callback which will be called when folder contents change.
Not available to scripts without I/O access.

  Parameters:

  1. `folder`: `path` Full path to a directory to monitor.

  2. `filter`: `string?` CSP filter (? for any number of any symbols, regex if “`” quotes are used, or a complex query) applied to full file path, or `nil`.

  3. `recursive`: `boolean?` If `true`, changes in subfolders are also detected. Default value: `false`.

  4. `callback`: `fun(files: string[])`

  Returns:

  - `ac.Disposable`
## Function ac.onCSPConfigChanged(cspModuleID, callback)
Sets a callback which will be called when config for certain CSP module has changed.

  Parameters:

  1. `cspModuleID`: `ac.CSPModuleID` ID of a module to monitor.

  2. `callback`: `fun()` Callback function.

  Returns:

  - `ac.Disposable`
## Function ac.onScreenshot(callback)
Sets a callback which will be called when a new screenshot is made.

  Parameters:

  1. `callback`: `fun()`

  Returns:

  - `ac.Disposable`
## Function ac.onOpenMainMenu(callback)
Sets a callback which will be called when a command opening a certain section in main menu has been called. More types of pages might be added later.

  Parameters:

  1. `callback`: `fun(section: 'info'|'setup')`

  Returns:

  - `ac.Disposable`
## Function ac.onSetupsListRefresh(callback)
Sets a callback which will be called when list of setups changes.

  Parameters:

  1. `callback`: `fun()`

  Returns:

  - `ac.Disposable`
## Function ac.onSetupFile(callback)
Sets a callback which will be called when setup is loaded or saved. Use `ac.INIConfig.currentSetup()` to load the setup.

  Parameters:

  1. `callback`: `fun(operation: 'load'|'save', filename: string)` Callback function.

  Returns:

  - `ac.Disposable`
## Function ac.setLogSilent(value)
Stops functions like `ac.log()` from logging things into CSP log file, in case you need to log a lot. With it, you
 can use Lua Debug app to see latest log entries.

  Parameters:

  1. `value`: `boolean?` Default value: `true`.
## Function ac.clearDebug(filter)
Removes `ac.debug()` entries matching filter.

  Parameters:

  1. `filter`: `string?` Default value: `?`.
## Function io.scanDrives()
Returns list of logical drives, each drive in “A:“ format.
Not available to scripts without I/O access.

  Returns:

  - `string`
## Function io.getAttributes(filename)
Gets file attributes.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `io.FileAttributes`
## Function io.getMainExecutable()
Gets full filename of the main AC executable (“…/acs.exe” for most cases).
Not available to scripts without I/O access.

  Returns:

  - `path`
## Function io.load(filename, fallbackData)
Reads file content into a string, if such file exists, otherwise returns fallback data or `nil`.

  Parameters:

  1. `filename`: `path`

  2. `fallbackData`: `string|nil` Data to return if file could not be read.

  Returns:

  - `string|nil` Returns `nil` if file couldn’t be read and there is no fallback data.
## Function io.loadAsync(filename, callback)
Reads file content into a string, if such file exists, otherwise returns fallback data or `nil`. Asynchronous version.

  Parameters:

  1. `filename`: `path`

  2. `callback`: `fun(err: string?, response: string?)`
## Function io.save(filename, data, ensure)
Writes data into a file, returns `true` if operation was successful. Data string can contain zero bytes.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  2. `data`: `binary?`

  3. `ensure`: `boolean?` If set to `true`, file will be saved with a temporary postfix and then moved to target destination, thus ensuring content is stored as-is, without ending up damaged in case there is a sudden power loss or something like that. Default value: `false`.

  Returns:

  - `boolean` Returns `false` if failed to write a file.
## Function io.saveAsync(filename, data, callback, ensure)
Writes data into a file from a different thread, returns `true` via callback if operation was successful. Data string can contain zero bytes.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  2. `data`: `binary?`

  3. `callback`: `fun(err: string?)`

  4. `ensure`: `boolean?` If set to `true`, file will be saved with a temporary postfix and then moved to target destination, thus ensuring content is stored as-is, without ending up damaged in case there is a sudden power loss or something like that. Default value: `false`.
## Function io.exists(filename)
Checks if file or directory exists. If you need to know specifically if a file or directory exists, use `io.dirExists(filename)` or `io.fileExists(filename)`.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.dirExists(filename)
Checks if directory exists. If there is a file in its place, it would return `false`.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.fileExists(filename)
Checks if file exists. If there is a directory in its place, it would return `false`.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.fileSize(filename)
Calculates file size in bytes. Returns -1 if there was an error.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `integer`
## Function io.creationTime(filename)
Returns creation time as number of seconds since 1970, or -1 if there was an error.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `integer`
## Function io.lastAccessTime(filename)
Returns last access time as number of seconds since 1970, or -1 if there was an error.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `integer`
## Function io.lastWriteTime(filename)
Returns last write time as number of seconds since 1970, or -1 if there was an error.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `integer`
## Function io.createDir(filename)
Creates new directory, returns `true` if directory was created. If parent directories are missing, they’ll be created as well.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.createFileDir(filename)
Creates new directory for given filename (as in, take parent path and create directory with it). Returns `true` if directory was created.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.getParentPath(filename, level)
Returns parent path for given filename.

  Parameters:

  1. `filename`: `string`

  2. `level`: `integer?` Default value: 1.

  Returns:

  - `string`
## Function io.getFileName(filename, noExtension)
Returns file name path for given filename.

  Parameters:

  1. `filename`: `string`

  2. `noExtension`: `boolean?` Default value: `false`.

  Returns:

  - `string`
## Function io.isFileNameAcceptable(fileName)
Checks if file name is acceptable, returns `true` if there are no prohibited symbols in it (unlike `io.isFileNameAcceptable()`, does not allow slashes).

  Parameters:

  1. `fileName`: `string`

  Returns:

  - `boolean`
## Function io.isFilePathAcceptable(filename)
Checks if full file name is acceptable, returns `true` if there are no prohibited symbols in it (unlike `io.isFileNameAcceptable()`, does allow slashes).

  Parameters:

  1. `filename`: `string`

  Returns:

  - `boolean`
## Function io.move(existingFilename, newFilename, replaceExisting)
Moves a file or a directory with all of its contents to a new place, returns `true` if moved successfully. Can be used for moving or renaming things.
Not available to scripts without I/O access.

  Parameters:

  1. `existingFilename`: `path`

  2. `newFilename`: `path`

  3. `replaceExisting`: `boolean?` Default value: `false`.

  Returns:

  - `boolean`
## Function io.copyFile(existingFilename, newFilename, failIfExists)
Copies a file to a new place, returns `true` if moved successfully.
Not available to scripts without I/O access.

  Parameters:

  1. `existingFilename`: `path`

  2. `newFilename`: `path`

  3. `failIfExists`: `boolean?` Set to `false` to silently overwrite existing files. Default value: `true`.

  Returns:

  - `boolean`
## Function io.deleteFile(filename)
Deletes a file, returns `true` if file was deleted successfully. To delete empty directory, use `io.deleteDir()`. If you’re operating around important
files, consider using `io.recycle()` instead.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.deleteDir(filename)
Deletes an empty directory, returns `true` if directory was deleted successfully. To delete a file, use `io.deleteFile()`.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.recycle(filename)
Moves file to Windows Recycle Bin, returns `true` if file was moved successfully. Note: this operation is much slower than removing a file with `io.deleteFile()`
or removing an empty directory with `io.deleteDir()`.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `boolean`
## Function io.saveToZip(zipFilename, entryFilename, data)
Adds a new entry to a ZIP file. If there is no such ZIP file, new one will be created. If the ZIP file already has an entry with
the same name, does nothing and returns `false`. Note: for adding multiple or large files use `io.createZipAsync()` instead.
Not available to scripts without I/O access.

  Parameters:

  1. `zipFilename`: `path`

  2. `entryFilename`: `string`

  3. `data`: `binary?`

  Returns:

  - `boolean`
## Function io.loadFromZip(zipFilename, entryFilename)
Loads file from an archive as a string. Archive would remain open for some time to speed up consequent reads. If failed, returns `nil`. Alternatively,
you can pass ZIP data instead.

  Parameters:

  1. `zipFilename`: `path`

  2. `entryFilename`: `string`

  Returns:

  - `string`
## Function io.extractFromZipAsync(zipFilename, destination, filter, callback)
Extract files from a ZIP file into a given directory. Creates directory if it’s missing.
Not available to scripts without I/O access.

  Parameters:

  1. `zipFilename`: `binary?`

  2. `destination`: `path` Full path to target directory.

  3. `filter`: `string?` Optional filter for full entry paths.

  4. `callback`: `fun(err: string?)`
## Function io.checksumSHA256(filename, callback)
Computes SHA-256 checksum of a given file, returns result in a callback.

  Parameters:

  1. `filename`: `path`

  2. `callback`: `fun(err: string, checksum: string)`
## Function io.scanZip(zipFilename)
Returns list of entry names from a ZIP-file.

  Parameters:

  1. `zipFilename`: `binary?`

  Returns:

  - `string`
## Function io.createZipAsync(filename, entries, callback)
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path?` Pass `nil` to instead get the binary data in the callback.

  2. `entries`: `table<string, io.ZipEntry>` Keys store entry names (use “/” as separator for creating sub-folders), and values store either binary data or tables in `io.ZipEntry` format.

  3. `callback`: `fun(err: string?, response: binary??)` Callback will contain reference to binary data if `filename` is `nil`.
## Function io.arrtest1()
Not available to scripts without I/O access.

  Returns:

  - `string`
## Function io.arrtest2()
Not available to scripts without I/O access.

  Returns:

  - `string`
## Function os.preciseClock()
Returns time in seconds from script start (with high precision).

  Returns:

  - `number` Seconds.
## Function os.onURL(mask, callback, priority)
Sets a callback which will be called when CSP itself or a CSP Lua script tries to open an URL. Return `true` if you’re handling URL, so the event would be stopped.

  Parameters:

  1. `mask`: `string` Regular expression to check URLs against of.

  2. `callback`: `fun(url: string): boolean`

  3. `priority`: `integer?` Smaller values mean script would be the last to get URL (if other scripts wouldn’t intercept it). Default value: 0.

  Returns:

  - `ac.Disposable`
## Function os.execute(cmd, timeoutMs, windowless)
Altered version of regular `os.execute()`: allows to specify timeout and doesn’t show a new window.
 Note: please consider using `os.runConsoleProcess()` instead: it’s a lot more robust, asynchronous and tweak-able.
Not available to scripts without I/O access.

  Parameters:

  1. `cmd`: `string`

  2. `timeoutMs`: `integer?` Default value: -1.

  3. `windowless`: `boolean?` Default value: `true`.

  Returns:

  - `integer`
## Function os.setCurrentFolder(filename)
Changes current directory. Any argument `path`, when parsed and found not to be absolute, will be resolved against current directory.
By default, uses AC root folder. Any change only applies to the current script only. Current path resets when script is reloaded.

Changes behavior of images and assets lookup as well (by default it scans script folder, CSP folder and then root folder looking for a file,
which might cause some issues and negatively affect performance).

 For scripts without I/O access, only folders script can read from can be used here.

 Note: as of 0.2.6, some API functions might still use AC root folder. This will be fixed in the future, please do not rely on this behavior!

  Parameters:

  1. `filename`: `path`

  Returns:

  - `string`
## Function os.dateGlobal(format, timestamp)
Returns formatted date. Same as `os.date()`, but returned value does not include system timezome.

  Parameters:

  1. `format`: `string`

  2. `timestamp`: `integer`

  Returns:

  - `string`
## Function os.addDLLDirectory(filename)
Adds new directory to look for DLL files in. Warning: do not use this thing unless you really need to, and try to avoid adding LuaJIT extensions:
LuaJIT build might change in the future breaking ABI compatibility.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `string` If not absolute, considered to be relative to script root folder.
## Function os.showMessage(msg, type)
Show a popup message using good old MessageBox. Please do not use it for debugging, instead consider using `ac.log()` and `ac.debug('key', 'value')`
with in-game Lua Debug App.
Note: do not rely on this function, most likely it might be removed in the future as obstructing.

  Parameters:

  1. `msg`: `string`

  2. `type`: `integer?` Type of MessageBox according to WinAPI. Default value: 0.

  Returns:

  - `integer`
## Function os.showInExplorer(filename)
Shows file in Windows Explorer (opens folder with it and selects the file).
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`
## Function os.openInExplorer(directory)
Opens file or directory in Windows Explorer. If it’s a file, associated program will be launched instead.
Not available to scripts without I/O access.

  Parameters:

  1. `directory`: `path`
## Function os.findAssociatedExecutable(filename)
Tries to find a program associated with a filename. Returns path to it, or `nil` if nothing was found.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  Returns:

  - `path`
## Function os.openTextFile(filename, line)
Opens text file at given line in a default text editor. Supports VS Code, Notepad++, Sublime Text and Atom (they all use different
arguments for line number.
Not available to scripts without I/O access.

  Parameters:

  1. `filename`: `path`

  2. `line`: `integer`
## Function os.openURL(url, invokeListeners)
Opens URL in default system browser.

  Parameters:

  1. `url`: `string`

  2. `invokeListeners`: `boolean?` Default value: `true`.
## Function ui.beginToolWindow(windowID, pos, size, noPadding, inputs)
It’s safer to use `ui.toolWindow()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `windowID`: `string`

  2. `pos`: `number|vec2`

  3. `size`: `number|vec2`

  4. `noPadding`: `boolean?` Default value: `false`.

  5. `inputs`: `boolean?` Default value: `false`.
## Function ui.beginTransparentWindow(windowID, pos, size, noPadding, inputs)
It’s safer to use `ui.transparentWindow()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `windowID`: `string`

  2. `pos`: `number|vec2`

  3. `size`: `number|vec2`

  4. `noPadding`: `boolean?` Default value: `false`.

  5. `inputs`: `boolean?` Default value: `false`.
## Function ui.itemHyperlink(hyperlinkColor)
Adds hyperlink effect to the previous item, returns `true` if it’s clicked.

  Parameters:

  1. `hyperlinkColor`: `rgbm?` Default value: `rgbm(0, 0.5, 1, 1)`.

  Returns:

  - `boolean`
## Function ui.itemUnderline(underlineColor, dashSize, gapSize)
Adds a regular underline line to previously drawn text, optionally dashed (if any of dash params are below 1, line is solid).

  Parameters:

  1. `underlineColor`: `rgbm|nil` By default uses previous text color. Default value: `nil`.

  2. `dashSize`: `number?` Default value: 0.

  3. `gapSize`: `number?` Default value: 0.
## Function ui.text(text)

  Parameters:

  1. `text`: `string`
## Function ui.textHyperlink(text, hyperlinkColor)

  Parameters:

  1. `text`: `string`

  2. `hyperlinkColor`: `rgbm?` Default value: `rgbm(0, 0.5, 1, 1)`.

  Returns:

  - `boolean`
## Function ui.textAligned(text, alignment, size, ellipsis)

  Parameters:

  1. `text`: `string`

  2. `alignment`: `number|vec2`

  3. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  4. `ellipsis`: `boolean?` Default value: `false`.
## Function ui.textWrapped(text, wrapPos)

  Parameters:

  1. `text`: `string`

  2. `wrapPos`: `number?` Default value: 0.
## Function ui.textColored(text, color)

  Parameters:

  1. `text`: `string`

  2. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.labelText(label, text)
Display text and label aligned the same way as value and label widgets.

  Parameters:

  1. `label`: `string`

  2. `text`: `string`
## Function ui.textDisabled(text)
Shortcut for pushing disabled text color, drawing text and popping it back;.

  Parameters:

  1. `text`: `string`
## Function ui.isKnownIcon24(iconID)
Returns `true` if 24×24 icon with such ID is known.

  Parameters:

  1. `iconID`: `ui.Icons`

  Returns:

  - `boolean`
## Function ui.icon(iconID, size, tintCol, iconSize)
Draws an icon, universal function (great for creating customizable components). Icon can be:
- An 24×24 icon ID set as is;
- A country code for a small flag with padding to fit a square;
- An 32×32 icon ID with “32:” prefix;
- An 64×64 icon ID with “64:” prefix;
- An 256×256 icon ID with “XL:” prefix;
- A large rectangular flag with no padding with “XS:” prefix;
- An emoticon with “em:” prefix;
- An icon from an atlas: use “at:FILENAME\nX1,Y1,X2,Y2” format, where X… and Y… are UV coordinates (`ui.atlasIconID()` can help with generating those IDs);
- A regular image: just pass a path as a string (also works with extra canvases, media elements and such).

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2`

  3. `tintCol`: `rgbm?` Default value: `rgbm.colors.white`.

  4. `iconSize`: `number|vec2|nil` If set, icon will be this size, but item will be larger (use it if you need to fill an area without stretching an icon). Default value: `nil`.
## Function ui.addIcon(iconID, size, alignment, colorOpt, padding)
Adds an icon to the previously drawn element.

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2` Size of an icon.

  3. `alignment`: `number|vec2` Alignment of an icon relative to the element.

  4. `colorOpt`: `rgbm|nil` If not set, uses text color by default. Default value: `nil`.

  5. `padding`: `number|vec2|nil` If not set, uses frame padding by default. Default value: `nil`.
## Function ui.icon24(iconID, size, tintCol)
Draws a 24×24 icon. Use universal `ui.icon()` instead.

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2`

  3. `tintCol`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.icon32(iconID, size, tintCol)
Draws a 32×32 icon. Use universal `ui.icon()` instead.

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2`

  3. `tintCol`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.icon64(iconID, size, tintCol)
Draws a 64×64 icon. Use universal `ui.icon()` instead.

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2`

  3. `tintCol`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.flag(iconID, size, tintCol)
Draws a flag. Use universal `ui.icon()` instead.

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `size`: `number|vec2`

  3. `tintCol`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.getCursor()

  Returns:

  - `vec2`
## Function ui.setCursor(v)

  Parameters:

  1. `v`: `number|vec2`
## Function ui.offsetCursor(v)

  Parameters:

  1. `v`: `number|vec2`
## Function ui.getCursorX()

  Returns:

  - `number`
## Function ui.setCursorX(v)

  Parameters:

  1. `v`: `number`
## Function ui.getCursorY()

  Returns:

  - `number`
## Function ui.setCursorY(v)

  Parameters:

  1. `v`: `number`
## Function ui.offsetCursorX(v)

  Parameters:

  1. `v`: `number`
## Function ui.offsetCursorY(v)

  Parameters:

  1. `v`: `number`
## Function ui.sameLine(offsetFromStart, spacing)

  Parameters:

  1. `offsetFromStart`: `number?` Default value: 0.

  2. `spacing`: `number?` Default value: -1.
## Function ui.getMaxCursorX()

  Returns:

  - `number`
## Function ui.getMaxCursorY()

  Returns:

  - `number`
## Function ui.setMaxCursorX(v)
Set maximum cursor value used for estimating amount of content. Use very carefully.

  Parameters:

  1. `v`: `number`
## Function ui.setMaxCursorY(v)
Set maximum cursor value used for estimating amount of content. Use very carefully.

  Parameters:

  1. `v`: `number`
## Function ui.newLine(spacing)

  Parameters:

  1. `spacing`: `number?` If non-negative, value is used for space between lines instead of regular item spacing from current style. Default value: -1.
## Function ui.beginGroup(width)
Lock horizontal starting position and capture group bounding box into one “item” (so you can use `ui.itemHovered()` or layout primitives such as `ui.sameLine()` on whole group, etc.)

  Parameters:

  1. `width`: `number?` Default value: 0.
## Function ui.endGroup()
Unlock horizontal starting position and capture the whole group bounding box into one “item” (so you can use `ui.itemHovered()` or layout primitives such as `ui.sameLine()` on whole group, etc.)
function ui.endGroup() end
## Function ui.availableSpaceX()

  Returns:

  - `number`
## Function ui.availableSpaceY()

  Returns:

  - `number`
## Function ui.availableSpace()

  Returns:

  - `vec2`
## Function ui.imageSize(imageSource)
Returns image size, or zeroes if image is missing or not yet ready.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  Returns:

  - `vec2`
## Function ui.decodeImage(data)
Imports image from its binary data. Any formats supported by system are supported. Also, new DDS formats are supported as well. Result is cached,
so subsequent calls don’t take a lot of time. Data string can contain zero bytes.

To clear cached image and free memory, pass returned value to `ui.unloadImage()`.

  Parameters:

  1. `data`: `binary`

  Returns:

  - `string`
## Function ui.drawImage(imageSource, p1, p2, color, uv1, uv2, mode)
Simply draws an image on canvas without adding a new item or progressing cursor. Current cursor position is not taken
into consideration either. To add an image as an element, use `ui.image()`.

When drawing multiple images, consider combining all of them in a single atlas texture, it would improve performance.

Note: if you’re using asyncronous loading (see `ui.setAsynchronousImagesLoading()`) and want to make sure image is
ready before drawing, use `ui.isImageReady()`. If image is not yet ready, transparent texture will be used instead.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  2. `p1`: `number|vec2` Position of upper left corner relative to current working area (scriptable texture or IMGUI window).

  3. `p2`: `number|vec2` Position of bottom right corner relative to current working area (scriptable texture or IMGUI window).

  4. `color`: `rgbm?` Tint of the image, with white it would be drawn as it is. Default value: `rgbm.colors.white`.

  5. `uv1`: `number|vec2?` Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.

  6. `uv2`: `number|vec2?` Texture coordinates for bottom right corner. Default value: `vec2( 1, 1 )`.

  7. `mode`: `ui.ImageFit?` Stretch mode. Default value: `ui.ImageFit.Stretch`.
## Function ui.drawIcon(iconID, p1, p2, color)
Draws an icon without moving cursor, universal function (great for creating customizable components). Icon can be:
- An 24×24 icon ID set as is;
- A country code for a small flag with padding to fit a square;
- An 32×32 icon ID with “32:” prefix;
- An 64×64 icon ID with “64:” prefix;
- An 256×256 icon ID with “XL:” prefix;
- A large rectangular flag with no padding with “XS:” prefix;
- An emoticon with “em:” prefix;
- An icon from an atlas: use “at:FILENAME\nX1,Y1,X2,Y2” format, where X… and Y… are UV coordinates (`ui.atlasIconID()` can help with generating those IDs);
- A regular image: just pass a path as a string (also works with extra canvases, media elements and such).

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `p1`: `number|vec2` Position of upper left corner relative to current working area (scriptable texture or IMGUI window).

  3. `p2`: `number|vec2` Position of bottom right corner relative to current working area (scriptable texture or IMGUI window).

  4. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.drawLoadingSpinner(p1, p2, color)
Draw loading animation spinner. Actual shape might change in the future versions.

  Parameters:

  1. `p1`: `number|vec2` Position of upper left corner relative to current working area (scriptable texture or IMGUI window).

  2. `p2`: `number|vec2` Position of bottom right corner relative to current working area (scriptable texture or IMGUI window).

  3. `color`: `rgbm?` Tint of the animation. Default value: `rgbm.colors.white`.
## Function ui.drawImageRounded(imageSource, p1, p2, color, uv1, uv2, rounding, corners)
Draws an image with rounded corners on canvas without adding a new item or progressing cursor. Current cursor position is not taken
into consideration either. To add an image as an element, use `ui.image()`.

When drawing multiple images, consider combining all of them in a single atlas texture, it would improve performance.

Note: if you’re using asyncronous loading (see `ui.setAsynchronousImagesLoading()`) and want to make sure image is
ready before drawing, use `ui.isImageReady()`. If image is not yet ready, transparent texture will be used instead.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  2. `p1`: `number|vec2` Position of upper left corner relative to current working area (scriptable texture or IMGUI window).

  3. `p2`: `number|vec2` Position of bottom right corner relative to current working area (scriptable texture or IMGUI window).

  4. `color`: `rgbm?` Tint of the image, with white it would be drawn as it is. Default value: `rgbm.colors.white`.

  5. `uv1`: `number|vec2?` Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.

  6. `uv2`: `number|vec2?` Texture coordinates for bottom right corner. Default value: `vec2( 1, 1 )`.

  7. `rounding`: `number?` Rounding radius in pixels. Default value: 1.

  8. `corners`: `ui.CornerFlags?` Corners to round. Default value: `ui.CornerFlags.All`.
## Function ui.drawImageQuad(imageSource, p1, p2, p3, p4, color, uv1, uv2, uv3, uv4)
Draws a custom quad with a texture.

Note: if you’re using asyncronous loading (see `ui.setAsynchronousImagesLoading()`) and want to make sure image is
ready before drawing, use `ui.isImageReady()`. If image is not yet ready, transparent texture will be used instead.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  2. `p1`: `number|vec2` Position of first corner relative to current working area (scriptable texture or IMGUI window).

  3. `p2`: `number|vec2` Position of second corner relative to current working area (scriptable texture or IMGUI window).

  4. `p3`: `number|vec2` Position of third corner relative to current working area (scriptable texture or IMGUI window).

  5. `p4`: `number|vec2` Position of fourth corner relative to current working area (scriptable texture or IMGUI window).

  6. `color`: `rgbm?` Tint of the image, with white it would be drawn as it is. Default value: `rgbm.colors.white`.

  7. `uv1`: `number|vec2?` Texture coordinates for first corner. Default value: `vec2(0, 0)`.

  8. `uv2`: `number|vec2?` Texture coordinates for second corner. Default value: `vec2( 1, 0 )`.

  9. `uv3`: `number|vec2?` Texture coordinates for third corner. Default value: `vec2( 1, 1 )`.

  10. `uv4`: `number|vec2?` Texture coordinates for fourth corner. Default value: `vec2( 0, 1 )`.
## Function ui.drawQuadFilled(p1, p2, p3, p4, color)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `p4`: `number|vec2`

  5. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.drawQuad(p1, p2, p3, p4, color)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `p4`: `number|vec2`

  5. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.beginTextureShade(imageSource)
Marks start of texture shading. All geometry drawn between this call and `ui.endTextureShade()` will have texture applied to it.

Note: this feature only works with geometrical shapes, like quads, triangles, circles or things drawn with `ui.path…` functions.
It can’t be applied to text, for example: text already uses its own texture.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.
## Function ui.endTextureShade(p1, p2, uv1, uv2, clamp)
Finishes texture shading. All geometry drawn between `ui.beginTextureShade()` and this call will have texture applied to it.
 Note: this feature only works with geometrical shapes, like quads, triangles, circles or things drawn with `ui.path…` functions.
 It can’t be applied to text, for example: text already uses its own texture.
 @overload fun(p1: vec2, p2: vec2, clamp: boolean)

  Parameters:

  1. `p1`: `number|vec2` Position within current working area that will get `uv1` texture coordinate.

  2. `p2`: `number|vec2` Position within current working area that will get `uv2` texture coordinate.

  3. `uv1`: `number|vec2?` Texture coordinate for `p1` position (texture will be interpolated between linearly). Default value: `vec2(0, 0)`.

  4. `uv2`: `number|vec2?` Texture coordinate for `p2` position (texture will be interpolated between linearly). Default value: `vec2( 1, 1 )`.

  5. `clamp`: `boolean?` If set to `true`, texture will be clamped to boundaries (if there are vertices outside). Otherwise, texture will be repeated. Default value: `true`.
## Function ui.endGradientShade(p1, p2, col1, col2, useAlpha)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `col1`: `rgbm?` Default value: `rgbm.colors.white`.

  4. `col2`: `rgbm?` Default value: `rgbm.colors.white`.

  5. `useAlpha`: `boolean?` Set to `true` to use alpha of gradient colors as a multiplier to existing alpha. Default value: `false`.
## Function ui.pushClipRect(p1, p2, intersectWithExisting)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `intersectWithExisting`: `boolean?` Default value: `true`.
## Function ui.pushClipRectFullScreen()
Pretty much fully disables clipping until next `ui.popClipRect()` call.
function ui.pushClipRectFullScreen() end
## Function ui.popClipRect()

  Returns:

  - `boolean`
## Function ui.drawRect(p1, p2, color, rounding, roundingFlags, thickness)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `color`: `rgbm`

  4. `rounding`: `number?` Default value: 0.

  5. `roundingFlags`: `ui.CornerFlags?` Default value: `ui.CornerFlags.All`.

  6. `thickness`: `number?` Default value: 1.
## Function ui.drawRectFilled(p1, p2, color, rounding, roundingFlags)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `color`: `rgbm`

  4. `rounding`: `number?` Default value: 0.

  5. `roundingFlags`: `ui.CornerFlags?` Default value: `ui.CornerFlags.All`.
## Function ui.drawRectFilledMultiColor(p1, p2, colorTopLeft, colorTopRight, colorBottomRight, colorBottomLeft)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `colorTopLeft`: `rgbm`

  4. `colorTopRight`: `rgbm`

  5. `colorBottomRight`: `rgbm`

  6. `colorBottomLeft`: `rgbm`
## Function ui.drawLine(p1, p2, color, thickness)
To quickly draw series of lines and arcs, add points with `ui.PathLineTo()` and `ui.pathArcTo()`, and then finish with `ui.pathStroke()`.
To quickly draw horizontal or vertical lines, consider using  `ui.drawSimpleLine()` instead.

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `color`: `rgbm`

  4. `thickness`: `number?` Default value: 1.
## Function ui.drawSimpleLine(p1, p2, color, thickness)
Draws line without any antialiasing the fastest way, good for horizontal or vertical lines.

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `color`: `rgbm`

  4. `thickness`: `number?` Default value: 1.
## Function ui.drawBezierCurve(p1, p2, p3, p4, color, thickness)
To quickly draw series of lines and arcs, add points with `ui.PathLineTo()` and `ui.pathArcTo()`, and then finish with `ui.pathStroke()`.

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `p4`: `number|vec2`

  5. `color`: `rgbm`

  6. `thickness`: `number?` Default value: 1.
## Function ui.drawCircle(p1, radius, color, numSegments, thickness)

  Parameters:

  1. `p1`: `number|vec2`

  2. `radius`: `number`

  3. `color`: `rgbm`

  4. `numSegments`: `integer?` Default value: 12.

  5. `thickness`: `number?` Default value: 1.
## Function ui.drawCircleFilled(p1, radius, color, numSegments)

  Parameters:

  1. `p1`: `number|vec2`

  2. `radius`: `number`

  3. `color`: `rgbm`

  4. `numSegments`: `integer?` Default value: 12.
## Function ui.drawEllipseFilled(p1, radius, color, numSegments)

  Parameters:

  1. `p1`: `number|vec2`

  2. `radius`: `number|vec2`

  3. `color`: `rgbm`

  4. `numSegments`: `integer?` Default value: 12.
## Function ui.drawTriangle(p1, p2, p3, color, thickness)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `color`: `rgbm`

  5. `thickness`: `number?` Default value: 1.
## Function ui.drawTriangleFilled(p1, p2, p3, color)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.drawText(text, pos, color)
Draws text in given position without advancing cursor or anything like that. Faster option. Returns updated X position.

  Parameters:

  1. `text`: `string`

  2. `pos`: `number|vec2`

  3. `color`: `rgbm?` Default value: `rgbm.colors.white`.

  Returns:

  - `number`
## Function ui.dwriteDrawText(text, fontSize, pos, color)
Draws TTF text in given position without advancing cursor or anything like that. Faster option.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number`

  3. `pos`: `number|vec2`

  4. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.drawTextClipped(text, posMin, posMax, color, alignment, ellipsis)
Draws text in a given rect with clipping and optional alignment without advancing cursor or anything like that. Faster option.

  Parameters:

  1. `text`: `string`

  2. `posMin`: `number|vec2`

  3. `posMax`: `number|vec2`

  4. `color`: `rgbm?` Default value: `rgbm.colors.white`.

  5. `alignment`: `number|vec2?` Default value: `vec2(0, 0)`.

  6. `ellipsis`: `boolean?` Default value: `false`.

  Returns:

  - `number`
## Function ui.dwriteDrawTextClipped(text, fontSize, posMin, posMax, horizontalAligment, verticalAlignment, allowWordWrapping, color)
Draws TTF text in a given rect with clipping and optional alignment without advancing cursor or anything like that. Faster option.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number`

  3. `posMin`: `number|vec2`

  4. `posMax`: `number|vec2`

  5. `horizontalAligment`: `ui.Alignment?` `ui.Alignment.Start` for left, `ui.Alignment.Center` for middle, `ui.Alignment.End` for right. Default value: `ui.Alignment.Center`.

  6. `verticalAlignment`: `ui.Alignment?` `ui.Alignment.Start` for top, `ui.Alignment.Center` for middle, `ui.Alignment.End` for bottom. Default value: `ui.Alignment.Center`.

  7. `allowWordWrapping`: `boolean?` Default value: `false`.

  8. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.pathClear()
Clears current path. Not really needed in common scenarios: to start a new path, simply use any of
path-adding functions such as `ui.pathLineTo()` or `ui.pathArcTo()`, to finish path and draw a shape use
either `ui.pathFillConvex()` or `ui.pathStroke()` and it would clear path for the next shape automatically.
function ui.pathClear() end
## Function ui.pathLineTo(pos)
Adds a line segment to current path.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `pos`: `number|vec2`
## Function ui.pathLineToMergeDuplicate(pos)
Adds a line segment to current path, but only if position is different from current path point position.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `pos`: `number|vec2`
## Function ui.pathFillConvex(color)

  Parameters:

  1. `color`: `rgbm`
## Function ui.pathStroke(color, closed, thickness)

  Parameters:

  1. `color`: `rgbm`

  2. `closed`: `boolean?` Default value: `false`.

  3. `thickness`: `number?` Default value: 1.
## Function ui.pathSimpleStroke(color, closed, thickness)
Finishes path and draws it without antialiasing. Faster and with pixelated lines.

  Parameters:

  1. `color`: `rgbm`

  2. `closed`: `boolean?` Default value: `false`.

  3. `thickness`: `number?` Default value: 1.
## Function ui.pathSmoothStroke(color, closed, thickness)
Finishes path with an alternative antialiasing approach, good for 1 pixel wide lines often changing direction (like a graph).

  Parameters:

  1. `color`: `rgbm`

  2. `closed`: `boolean?` Default value: `false`.

  3. `thickness`: `number?` Default value: 1.
## Function ui.pathArcTo(center, radius, angleFrom, angleTo, numSegments)
Adds an arc defined by its center, radius and starting and finishing angle to current path.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `center`: `number|vec2`

  2. `radius`: `number`

  3. `angleFrom`: `number`

  4. `angleTo`: `number`

  5. `numSegments`: `integer?` Default value: 10.
## Function ui.pathUnevenArcTo(center, radius, angleFrom, angleTo, numSegments)
Adds “squished” arc to current path, like an arc of axis-aligned ellipse rather than an arc of a circle.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `center`: `number|vec2`

  2. `radius`: `number|vec2`

  3. `angleFrom`: `number`

  4. `angleTo`: `number`

  5. `numSegments`: `integer?` Default value: 10.
## Function ui.pathVariableArcTo(center, radiusFrom, radiusTo, angleFrom, angleTo, numSegments)
Adds arc with radius at the end different from radius at the beginning.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `center`: `number|vec2`

  2. `radiusFrom`: `number`

  3. `radiusTo`: `number`

  4. `angleFrom`: `number`

  5. `angleTo`: `number`

  6. `numSegments`: `integer?` Default value: 10.
## Function ui.pathArcToFast(center, radius, angleMinOf_12, angleMaxOf_12)
Uses precomputed angles for a 12 steps circle.

  Parameters:

  1. `center`: `number|vec2`

  2. `radius`: `number`

  3. `angleMinOf_12`: `integer`

  4. `angleMaxOf_12`: `integer`
## Function ui.pathBezierCurveTo(p1, p2, p3, numSegments)
Adds a bezier curve to current path.
Don’t forget to finish shape with either `ui.pathFillConvex()` or `ui.pathStroke()`.

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `p3`: `number|vec2`

  4. `numSegments`: `integer?` Default value: 0.
## Function ui.pathRect(rectMin, rectMax, rounding, roundingCorners)

  Parameters:

  1. `rectMin`: `number|vec2`

  2. `rectMax`: `number|vec2`

  3. `rounding`: `number?` Default value: 0.

  4. `roundingCorners`: `ui.CornerFlags?` Default value: `ui.CornerFlags.All`.
## Function ui.glowRectFilled(p1, p2, color, noClip)
Adds a rect to a glowing layer used for styling. All shapes in there are going to be blurred, so just drop something around active element to highlight it.

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `color`: `rgbm`

  4. `noClip`: `boolean?` Default value: `false`.
## Function ui.glowCircleFilled(p1, radius, color, noClip)
Adds a circle to a glowing layer used for styling. All shapes in there are going to be blurred, so just drop something around active element to highlight it.

  Parameters:

  1. `p1`: `number|vec2`

  2. `radius`: `number`

  3. `color`: `rgbm`

  4. `noClip`: `boolean?` Default value: `false`.
## Function ui.glowEllipseFilled(p1, radius, color, noClip)
Adds an ellipse to a glowing layer used for styling. All shapes in there are going to be blurred, so just drop something around active element to highlight it.

  Parameters:

  1. `p1`: `number|vec2`

  2. `radius`: `number|vec2`

  3. `color`: `rgbm`

  4. `noClip`: `boolean?` Default value: `false`.
## Function ui.getDrawCommandsCount()
Returns number of draw command in current IMGUI drawing context. Each command is its own draw call.

  Returns:

  - `integer`
## Function ui.endTextureSaturationAdjustment(value)

  Parameters:

  1. `value`: `number`
## Function ui.endOutline(color, scale)

  Parameters:

  1. `color`: `rgbm`

  2. `scale`: `number?` Default value: 1.
## Function ui.endSharpening(sharpening)

  Parameters:

  1. `sharpening`: `number?` Default value: 1.
## Function ui.endMIPBias(bias, useBicubic)

  Parameters:

  1. `bias`: `number?` Default value: 0.

  2. `useBicubic`: `boolean?` Default value: `false`.
## Function ui.endBlurring(blurring)

  Parameters:

  1. `blurring`: `number|vec2`
## Function ui.endTonemapping(gamma, whitePoint, lcsAware)

  Parameters:

  1. `gamma`: `number`

  2. `whitePoint`: `number`

  3. `lcsAware`: `boolean?` Set to `true` to automatically convert colors from AC HDR to LDR (set `whitePoint` to 0 to disable tonemapping step too). Default value: `false`.
## Function ui.beginRotation()
Begins rotation. Call this function before drawing elements you need to rotate, it would track current position in resulting
vertex buffer and then, upon calling `ui.endRotation()`, would turn all new vertices by specified angle.
function ui.beginRotation() end
## Function ui.endRotation(deg, offset)
Does actual rotation counterclockwise (or clockwise with negative values; also see note). Call this function after calling
`ui.beginRotation()` and drawing elements you need to rotate. This version would automatically calculate pivot as middle point
of drawn elements.

Note: angle of rotation is offset by 90, kept this way for compatibility. Just subtract 90 from `deg` for it to act normal.

  Parameters:

  1. `deg`: `number` Angle in degrees.

  2. `offset`: `number|vec2?` Optional offset. Default value: `vec2(0, 0)`.
## Function ui.endPivotRotation(deg, pivot, offset)
Does actual rotation counterclockwise (or clockwise with negative values; also see note). Call this function after calling
`ui.beginRotation()` and drawing elements you need to rotate. This version uses provided pivot to rotate things around.

Note: angle of rotation is offset by 90, kept this way for compatibility. Just subtract 90 from `deg` for it to act normal.

  Parameters:

  1. `deg`: `number` Angle in degrees.

  2. `pivot`: `number|vec2` Point around which things would rotate, in window space.

  3. `offset`: `number|vec2?` Optional offset. Default value: `vec2(0, 0)`.
## Function ui.applyTransformationToWindows(active)
Call this function first to apply any further transformations to subsequently drawn windows.

Be careful with it! While it allows to transform windows around, it doesn’t work all that well when clipping
gets involved, and it gets involved all the time.

  Parameters:

  1. `active`: `boolean?` Default value: `true`.
## Function ui.beginScale()
Begins scaling. Call this function before drawing elements you need to scale, it would track current position in resulting
vertex buffer and then, upon calling `ui.endScale()`, would scale all new vertices by specified value.
function ui.beginScale() end
## Function ui.endScale(scale)
Does actual scaling. Call this function after calling `ui.beginScale()` and drawing elements you need to scale. This
version would automatically calculate pivot as middle point of drawn elements.

  Parameters:

  1. `scale`: `number|vec2` Scale, could be a 2-dimensional vector or a single number.
## Function ui.endPivotScale(scale, pivot)
Does actual scaling. Call this function after calling `ui.beginScale()` and drawing elements you need to scale. This
version uses provided pivot to scale things around.

  Parameters:

  1. `scale`: `number|vec2` Scale, could be a 2-dimensional vector or a single number.

  2. `pivot`: `number|vec2` Point around which things would scale, in window space.
## Function ui.beginTransformMatrix()
Begins transformation. Call this function before drawing elements you need to scale, it would track current position in resulting
vertex buffer and then, upon calling `ui.endTransformMatrix()`, would transform all new vertices by specified matrix.
function ui.beginTransformMatrix() end
## Function ui.endTransformMatrix(mat)
Does actual transformation. Call this function after calling `ui.beginTransformMatrix()` and drawing elements you need to scale.

  Parameters:

  1. `mat`: `mat3x3` Transformation matrix.
## Function ui.popStyleVar(count)

  Parameters:

  1. `count`: `integer?` Default value: 1.

  Returns:

  - `boolean`
## Function ui.styleColor(varID, styleSet)

  Parameters:

  1. `varID`: `ui.StyleColor`

  2. `styleSet`: `integer?` Leave at -1 to get the current color, or set to 0 to get the main style color. Default value: -1.

  Returns:

  - `rgbm`
## Function ui.pushStyleColor(varID, value)

  Parameters:

  1. `varID`: `ui.StyleColor`

  2. `value`: `rgbm`
## Function ui.popStyleColor(count)

  Parameters:

  1. `count`: `integer?` Default value: 1.

  Returns:

  - `boolean`
## Function ui.pushFont(fontType)

  Parameters:

  1. `fontType`: `ui.Font`
## Function ui.popFont()

  Returns:

  - `boolean`
## Function ui.pushItemWidth(itemWidth)

  Parameters:

  1. `itemWidth`: `number`
## Function ui.popItemWidth()

  Returns:

  - `boolean`
## Function ui.pushTextWrapPosition(wrapPos)

  Parameters:

  1. `wrapPos`: `number`
## Function ui.popTextWrapPosition()

  Returns:

  - `boolean`
## Function ui.areaVisible(size)
Checks if area is visible (not clipped). Works great if you need to make a list with many elements and don’t want to render elements
outside of scroll (just make sure to offset cursor instead of drawing them using, of example, `ui.offsetCursorY(itemHeight)`).

  Parameters:

  1. `size`: `number|vec2`

  Returns:

  - `boolean`
## Function ui.areaVisibleY(height)
Checks if area is visible (not clipped). Works great if you need to make a list with many elements and don’t want to render elements
outside of scroll (just make sure to offset cursor instead of drawing them using, of example, `ui.offsetCursorY(itemHeight)`).

  Parameters:

  1. `height`: `number`

  Returns:

  - `boolean`
## Function ui.rectVisible(p1, p2)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  Returns:

  - `boolean`
## Function ui.rectHovered(p1, p2, clip)

  Parameters:

  1. `p1`: `number|vec2`

  2. `p2`: `number|vec2`

  3. `clip`: `boolean?` Default value: `true`.

  Returns:

  - `boolean`
## Function ui.setItemDefaultFocus()
Make last item the default focused item of a window.
function ui.setItemDefaultFocus() end
## Function ui.setKeyboardFocusHere(offset)
Focus keyboard on the next widget. Use positive `offset` to access sub components of a multiple component widget. Use `-1` to access previous widget.

  Parameters:

  1. `offset`: `integer?` Default value: 0.
## Function ui.getScrollX()

  Returns:

  - `number`
## Function ui.getScrollY()

  Returns:

  - `number`
## Function ui.getScrollMaxX()

  Returns:

  - `number`
## Function ui.getScrollMaxY()

  Returns:

  - `number`
## Function ui.setScrollX(scrollX, relative, smooth)

  Parameters:

  1. `scrollX`: `number`

  2. `relative`: `boolean?` Default value: `false`.

  3. `smooth`: `boolean?` Default value: `true`.
## Function ui.setScrollY(scrollY, relative, smooth)

  Parameters:

  1. `scrollY`: `number`

  2. `relative`: `boolean?` Default value: `false`.

  3. `smooth`: `boolean?` Default value: `true`.
## Function ui.setScrollHereX(centerXRatio)
Adjust scrolling amount to make last item visible. When using to make a default/current item visible, consider using `ui.setItemDefaultFocus()` instead.

  Parameters:

  1. `centerXRatio`: `number?` 0 for top of last item, 0.5 for vertical center of last item, 1 for bottom of last item. Default value: 0.5.
## Function ui.setScrollHereY(centerYRatio)
Adjust scrolling amount to make last item visible. When using to make a default/current item visible, consider using `ui.setItemDefaultFocus()` instead.

  Parameters:

  1. `centerYRatio`: `number?` 0 for top of last item, 0.5 for vertical center of last item, 1 for bottom of last item. Default value: 0.5.
## Function ui.windowHovered(flags)
Is current window hovered (and typically not blocked by a popup/modal).

  Parameters:

  1. `flags`: `ui.HoveredFlags?` Default value: `ui.HoveredFlags.None`.

  Returns:

  - `boolean`
## Function ui.windowFocused(flags)
Is current window focused (or its root/child, depending on flags).

  Parameters:

  1. `flags`: `ui.FocusedFlags?` Default value: `ui.FocusedFlags.None`.

  Returns:

  - `boolean`
## Function ui.windowResizing()
Is current (root) window being resized by its border.

  Returns:

  - `boolean`
## Function ui.windowScrolling()
Is current window being scrolled by one of its scroll bars (also applies to thin scrollbars).

  Returns:

  - `boolean`
## Function ui.windowPinned()
Is current window pinned.

  Returns:

  - `boolean`
## Function ui.mouseBusy()
Returns `true` if mouse currently is either used by one of IMGUI controls (like dragging something) or if it hovers any of windows. If that’s the case and
your script reacts to clicks on the scene, for example, it’s better to skip that frame.

  Returns:

  - `boolean`
## Function ui.mouseClicked(mouseButton)
Did mouse button clicked (went from not down to down).

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  Returns:

  - `boolean`
## Function ui.mouseDoubleClicked(mouseButton)
Did mouse button double-clicked. A double-click returns `false` in `ui.mouseClicked()`.

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  Returns:

  - `boolean`
## Function ui.mouseReleased(mouseButton)
Did mouse button released (went from down to not down).

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  Returns:

  - `boolean`
## Function ui.mouseDown(mouseButton)
Is mouse button held.

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  Returns:

  - `boolean`
## Function ui.mousePos()
Returns mouse cursor position on a screen. To get mouse position within current window, use `ui.mouseLocalPos()`.

  Returns:

  - `vec2` Mouse cursor position in pixels, or (-1, -1) if mouse is not available.
## Function ui.mouseLocalPos()
Returns mouse cursor position relative to current app/window. To get mouse position within screen window, use `ui.mousePos()`.

  Returns:

  - `vec2` Mouse cursor position in pixels, or (-1, -1) if mouse is not available.
## Function ui.itemRectMin()
Get upper-left bounding rectangle of the last item (window space).

  Returns:

  - `vec2`
## Function ui.itemRectMax()
Get lower-right bounding rectangle of the last item (window space).

  Returns:

  - `vec2`
## Function ui.deltaTime()
Time since last frame of current UI context.

  Returns:

  - `number`
## Function ui.itemRectSize()
Get size of last item.

  Returns:

  - `vec2`
## Function ui.mouseDelta()
Returns mouse cursor position delta comparing to previous frame.

  Returns:

  - `vec2`
## Function ui.mouseWheel()
Returns mouse wheel movement (1 unit scrolls 5 text lines).

  Returns:

  - `number`
## Function ui.windowPos()
Returns position of current window in screen-space/texture-space (`ui.beginChild()` returns a new window).

  Returns:

  - `vec2`
## Function ui.windowSize()
Returns size of current window.

  Returns:

  - `vec2`
## Function ui.windowContentSize()
Size of contents/scrollable client area (calculated from the extents reach of the cursor) from previous frame. Does not include window decoration or window padding.

  Returns:

  - `vec2`
## Function ui.windowContentExplicitSize()
Size of contents/scrollable client area explicitly request by the user via `ui.setNextWindowContentSize()`.

  Returns:

  - `vec2`
## Function ui.setNextWindowPosition(pos, pivot)
Set next window position.

  Parameters:

  1. `pos`: `number|vec2`

  2. `pivot`: `number|vec2|nil` Default value: `nil`.
## Function ui.setNextWindowSize(size)
Set next window position.

  Parameters:

  1. `size`: `number|vec2`
## Function ui.setNextWindowSizeConstraints(sizeMin, sizeMax)
Set next window position.

  Parameters:

  1. `sizeMin`: `number|vec2|nil` Default value: `nil`.

  2. `sizeMax`: `number|vec2|nil` Default value: `nil`.
## Function ui.setNextWindowContentSize(size)
Set next window content size (scrollable client area, which enforce the range of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor WindowPadding. Set an axis to 0 to leave it automatic. Call before `ui.beginChild()`.

  Parameters:

  1. `size`: `number|vec2`
## Function ui.keyboardButtonDown(keyIndex)
Is key being held.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  Returns:

  - `boolean`
## Function ui.keyboardButtonPressed(keyIndex, withRepeat)
Was key pressed (went from `not down` to `down`). If `with_repeat` is true, uses configured repeat delay and rate.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  2. `withRepeat`: `boolean?` Default value: `true`.

  Returns:

  - `boolean`
## Function ui.keyboardButtonReleased(keyIndex)
Was key released (went from `down` to `not down`).

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  Returns:

  - `boolean`
## Function ui.setKeyboardButtonDown(keyIndex, down)
Simulate key being pressed (affects current IMGUI context only).

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  2. `down`: `boolean?` Default value: `true`.
## Function ui.addInputCharacter(keyIndex)
Add input character for currently active text input.

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`
## Function ui.clearInputCharacters()
Clear input character for currently active text input.
function ui.clearInputCharacters() end
## Function ui.keyPressed(keyCode)
Provides access to few buttons with certain UI roles.

  Parameters:

  1. `keyCode`: `ui.Key`

  Returns:

  - `boolean`
## Function ui.getKeyIndex(keyCode)
Map a button with certain UI role to regular key index.

  Parameters:

  1. `keyCode`: `ui.Key`

  Returns:

  - `ui.KeyIndex`
## Function ui.hotkeyCtrl()
Returns true if Ctrl is pressed, but Shift, Alt and Super/Win are depressed.

  Returns:

  - `boolean`
## Function ui.hotkeyAlt()
Returns true if Alt is pressed, but Ctrl, Shift and Super/Win are depressed.

  Returns:

  - `boolean`
## Function ui.hotkeyShift()
Returns true if Shift is pressed, but Ctrl, Alt and Super/Win are depressed.

  Returns:

  - `boolean`
## Function ui.setShadingOffset(brightness, offset, alphaMult, alphaOffset)
Adds modifiers to how IMGUI renders textures (including icons, any UI element, all texts, so use carefully and don’t forget
to reset values to default with `ui.resetShadingOffset()` or by passing default arguments or no arguments here). Modifiers
act like simple multiply-and-add adjustment, first value in pair acts like multiplier, second acts like addition (or subtraction)
value. First pair affects RGB channels, second is for alpha. There are also special combinations:
- `brightness` = 0, `offset` = 0, `alphaMult` = 0, `alphaOffset` = 0: use texture RGB for color (multiplied by shape color) and green texture channel for alpha;
- `brightness` = 0, `offset` = 0, `alphaMult` = 0, `alphaOffset` = 1: use shape color for color and red texture channel for alpha;
- `brightness` = 0, `offset` = 0, `alphaMult` = 0, `alphaOffset` = -1: use shape color for color and inverse of red texture channel for alpha.

  Parameters:

  1. `brightness`: `number?` Default value: 1.

  2. `offset`: `number?` Default value: 0.

  3. `alphaMult`: `number?` Default value: 1.

  4. `alphaOffset`: `number?` Default value: 0.
## Function ui.resetShadingOffset()
Resets texture sampling modifiers.
function ui.resetShadingOffset() end
## Function ui.acText(text, letter, marginOffset, color, lineSpace, monospace)
Draw text using AC font (which should previously set with `ui.pushACFont()`.

  Parameters:

  1. `text`: `string`

  2. `letter`: `number|vec2`

  3. `marginOffset`: `number?` Default value: 0.

  4. `color`: `rgbm?` Default value: `rgbm.colors.white`.

  5. `lineSpace`: `number?` Default value: 0.

  6. `monospace`: `boolean?` Default value: `true`.
## Function ui.calculateACTextSize(text, letter, marginOffset, lineSpace, monospace)
Calculate size of text using AC font (which should previously set with `ui.pushACFont()`.

  Parameters:

  1. `text`: `string`

  2. `letter`: `number|vec2`

  3. `marginOffset`: `number?` Default value: 0.

  4. `lineSpace`: `number?` Default value: 0.

  5. `monospace`: `boolean?` Default value: `true`.

  Returns:

  - `vec2`
## Function ui.pushACFont(name)
Pushes new AC font on stack. After you finished using it, don’t forget to use `ui.popACFont()`. Fonts will be search for
in “content/fonts”, as well as in script’s folder.

  Parameters:

  1. `name`: `string`
## Function ui.popACFont()
Pops previously pushed font from stack. Note: font will not be unloaded or anything like that, feel free to use it as much as you need.
function ui.popACFont() end
## Function ui.pushDWriteFont(name)
Adds new TTF font to the stack to be used for drawing DWrite text later. Fonts are taken from “content/fonts” and “extension/fonts”, but scripts
can also use their own TTF files. To do so, use `'Font Name:path/to/file.ttf'` or `'Font Name:path/to/directory'`, path can be absolute, relative
to script folder or AC root folder. Font name can also use styling attributes, such as `Weight=Thin`, `Style=Italic` or `Stretch=Condensed`, listed
at the end after a “;” like so:
```lua
ui.pushDWriteFont('My Font:myfont.ttf;Weight=Bold;Style=Oblique;Stretch=Expanded')
```
To make things simpler, you can also use `ui.DWriteFont` helper, it provides nice methods to set attributes.

If you need to use a standard system font, set “@System” as font path: it would use faster working system fonts collection.

Update: since CSP 0.1.80 it is now possible to use a relative path to a TTF file directly. In this case, first font will be used. Note however that
if you want to use extended options and such, you’ll still need to use “<font name>:<file name>;<options>” format.

  Parameters:

  1. `name`: `string|ui.DWriteFont?` Default value: 'Segoe UI'.
## Function ui.popDWriteFont()
Removes latest TTF font from the stack.
function ui.popDWriteFont() end
## Function ui.measureText(text, wrapWidth)
Calculate size of text using current IMGUI font.

  Parameters:

  1. `text`: `string`

  2. `wrapWidth`: `number?` Set to positive value of pixels to enable text wrapping. Default value: -1.

  Returns:

  - `vec2`
## Function ui.measureDWriteText(text, fontSize, wrapWidth)
Calculate size of text using TTF font. Make sure to set a font first using `ui.pushDWriteFont()`.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number?` Default value: 14.

  3. `wrapWidth`: `number?` Set to positive value of pixels to enable text wrapping. Default value: -1.

  Returns:

  - `vec2`
## Function ui.dwriteText(text, fontSize, color)
Draws some text using TTF font with DirectWrite library. Make sure to set a font first using `ui.pushDWriteFont()`.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number?` Default value: 14.

  3. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.dwriteTextHyperlink(text, fontSize, hyperlinkColor)
Draws some hyperlink using TTF font with DirectWrite library. Make sure to set a font first using `ui.pushDWriteFont()`.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number?` Default value: 14.

  3. `hyperlinkColor`: `rgbm?` Default value: `rgbm(0, 0.5, 1, 1)`.

  Returns:

  - `boolean`
## Function ui.dwriteTextWrapped(text, fontSize, color)
Draws wrapped text using TTF font with DirectWrite library. Make sure to set a font first using `ui.pushDWriteFont()`.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number?` Default value: 14.

  3. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.dwriteTextAligned(text, fontSize, horizontalAligment, verticalAlignment, size, allowWordWrapping, color)
Draws some aligned text using TTF font with DirectWrite library. Make sure to set a font first using `ui.pushDWriteFont()`.

  Parameters:

  1. `text`: `string`

  2. `fontSize`: `number?` Default value: 14.

  3. `horizontalAligment`: `ui.Alignment?` `ui.Alignment.Start` for left, `ui.Alignment.Center` for middle, `ui.Alignment.End` for right. Default value: `ui.Alignment.Center`.

  4. `verticalAlignment`: `ui.Alignment?` `ui.Alignment.Start` for top, `ui.Alignment.Center` for middle, `ui.Alignment.End` for bottom. Default value: `ui.Alignment.Center`.

  5. `size`: `number|vec2?` Set to 0 to use remaining space, set to negative value to use it as margin (positive) from remaining space. Default value: `vec2(0, 0)`.

  6. `allowWordWrapping`: `boolean?` Default value: `false`.

  7. `color`: `rgbm?` Default value: `rgbm.colors.white`.
## Function ui.popID()

  Returns:

  - `boolean`
## Function ui.getLastID()

  Returns:

  - `integer`
## Function ui.getActiveID()

  Returns:

  - `integer`
## Function ui.getFocusID()

  Returns:

  - `integer`
## Function ui.getHoveredID()

  Returns:

  - `integer`
## Function ui.activateItem(id)

  Parameters:

  1. `id`: `integer`
## Function ui.loadStoredNumber(id, defaultValue)
Returns a number associated with current context (taking into account `ui.pushID()` calls). Use it to store rarely updating
UI data, such as, for example, opened tab.

  Parameters:

  1. `id`: `integer?` Default value: 0.

  2. `defaultValue`: `number?` Default value: 0.

  Returns:

  - `number`
## Function ui.loadStoredBool(id, defaultValue)
Returns a boolean value associated with current context (taking into account `ui.pushID()` calls). Use it to store rarely updating
UI data, such as, for example, opened tab.

  Parameters:

  1. `id`: `integer?` Default value: 0.

  2. `defaultValue`: `boolean?` Default value: `false`.

  Returns:

  - `boolean`
## Function ui.storeNumber(id, value)
Stores a number in current context (taking into account `ui.pushID()` calls). Use it to store rarely updating
UI data, such as, for example, opened tab.

  Parameters:

  1. `id`: `integer?` Default value: 0.

  2. `value`: `number?` Default value: 0.
## Function ui.storeBool(id, value)
Stores a boolean value in current context (taking into account `ui.pushID()` calls). Use it to store rarely updating
UI data, such as, for example, opened tab.

  Parameters:

  1. `id`: `integer?` Default value: 0.

  2. `value`: `boolean?` Default value: `false`.
## Function ui.columns(columns, border, id)

  Parameters:

  1. `columns`: `integer?` Default value: 1.

  2. `border`: `boolean?` Default value: `true`.

  3. `id`: `string|nil` Default value: `nil`.
## Function ui.setColumnWidth(columnIndex, width)

  Parameters:

  1. `columnIndex`: `integer`

  2. `width`: `number`
## Function ui.getColumnWidth(columnIndex)

  Parameters:

  1. `columnIndex`: `integer`

  Returns:

  - `number`
## Function ui.pushColumnsBackground()
Can be used to draw something spanning entire table.
function ui.pushColumnsBackground() end
## Function ui.popColumnsBackground()

  Returns:

  - `boolean`
## Function ui.columnSortingHeader(title, orderDirection, alignRight)
Draws a column label with optional ordering arrow and advances to the next column.

  Parameters:

  1. `title`: `string`

  2. `orderDirection`: `integer` 1 for arrow pointing down, -1 for arrow pointing up, 0 for no arrow.

  3. `alignRight`: `boolean?` Default value: `false`.

  Returns:

  - `boolean` Returns `true` if header was clicked.
## Function ui.copyable(label)
Copyable text.

  Parameters:

  1. `label`: `string`
## Function ui.popDisabled()

  Returns:

  - `boolean`
## Function ui.button(label, size, flags)
Simple button.
 @overload fun(label: string, flags: ui.ButtonFlags)

  Parameters:

  1. `label`: `string`

  2. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  3. `flags`: `ui.ButtonFlags?` Default value: `ui.ButtonFlags.None`.

  Returns:

  - `boolean`
## Function ui.modernButton(label, size, flags, icon, iconSize, iconBg)
Button with Modern UI style to use in modal dialogs.

  Parameters:

  1. `label`: `string`

  2. `size`: `number|vec2`

  3. `flags`: `ui.ButtonFlags?` Default value: `ui.ButtonFlags.None`.

  4. `icon`: `string|nil` Default value: `nil`.

  5. `iconSize`: `number?` Default value: 16.

  6. `iconBg`: `string|nil` Default value: `nil`.

  Returns:

  - `boolean`
## Function ui.configureStyle(accentColor, brightTheme, roundedCorners, bgAlpha)
Very experimental. Better to avoid using, or at least to call first.

  Parameters:

  1. `accentColor`: `rgbm`

  2. `brightTheme`: `boolean?` Default value: `false`.

  3. `roundedCorners`: `boolean?` Default value: `false`.

  4. `bgAlpha`: `number?` Default value: 0.72.
## Function ui.smallButton(label)
Button without frame padding to easily embed within text.

  Parameters:

  1. `label`: `string`

  Returns:

  - `boolean`
## Function ui.invisibleButton(label, size, flags)
Button behavior without the visuals, frequently useful to build custom behaviors using the public API (along with `ui.itemActive()`, `ui.itemHovered()`, etc.)

  Parameters:

  1. `label`: `string`

  2. `size`: `number|vec2`

  3. `flags`: `ui.ButtonFlags?` Default value: `ui.ButtonFlags.None`.

  Returns:

  - `boolean`
## Function ui.dummy(size)
Add a dummy item of given size. unlike `ui.invisibleButton()`, dummy won’t take the mouse click or be navigable into.

  Parameters:

  1. `size`: `number|vec2`
## Function ui.thinScrollbarBegin(appearOnHover)
Returns `true` during scrolling.

  Parameters:

  1. `appearOnHover`: `boolean?` Default value: `false`.

  Returns:

  - `boolean`
## Function ui.arrowButton(strID, dir, size, flags)
Square button with an arrow shape.

  Parameters:

  1. `strID`: `string`

  2. `dir`: `ui.Direction`

  3. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  4. `flags`: `ui.ButtonFlags?` Default value: `ui.ButtonFlags.None`.

  Returns:

  - `boolean`
## Function ui.bullet()
Draw a small circle and keep the cursor on the same line.
function ui.bullet() end
## Function ui.separator()
Separator, generally horizontal. Inside a menu bar or in horizontal layout mode, this becomes a vertical separator.
function ui.separator() end
## Function ui.checkbox(label, checked)
Checkbox. Pass `refbool` for current value, or just pass a regular `boolean` and switch state yourself if
function would return `true`.
```lua
if ui.checkbox('My checkbox', myFlag) then
  myFlag = not myFlag
end
```

  Parameters:

  1. `label`: `string`

  2. `checked`: `boolean|refbool|nil`

  Returns:

  - `boolean` Returns `true` if checkbox was clicked.
## Function ui.radioButton(label, checked)

  Parameters:

  1. `label`: `string`

  2. `checked`: `boolean|refbool|nil`

  Returns:

  - `boolean`
## Function ui.progressBar(fraction, size, overlay)

  Parameters:

  1. `fraction`: `number`

  2. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  3. `overlay`: `string|nil` Default value: `nil`.
## Function ui.setExtraContentMark(active)
Mark window resize handle to show some content is hidden due to window size.

  Parameters:

  1. `active`: `boolean?` Default value: `true`.
## Function ui.setTitleBarContentHint(marginLeft, marginRight)
Let IMGUI know about some extra content you’re drawing in the title bar to avoid potential conflicts. Pass `math.nan` (or `math.huge`) as first parameter to disable.

  Parameters:

  1. `marginLeft`: `number?` Default value: 80.

  2. `marginRight`: `number?` Default value: 44.
## Function ui.notificationCounter(counter, pos, noclip)
Add notification counter (small red circle with a bit of a glow and an optional digit in it).

  Parameters:

  1. `counter`: `integer?` By default doesn’t show any number. If above 9, “…” will be shown. Default value: -1.

  2. `pos`: `number|vec2|nil` If not set, notification counter will be added to the previous element. Default value: `nil`.

  3. `noclip`: `boolean?` Set to `true` if your counter ends up clipped. Default value: `false`.
## Function ui.setNextItemWidth(width)

  Parameters:

  1. `width`: `number`
## Function ui.setNextItemIcon(iconID, color, relativePadding)

  Parameters:

  1. `iconID`: `ui.Icons`

  2. `color`: `rgbm|nil` If not set, text color will be used. Default value: `nil`.

  3. `relativePadding`: `number?` Relative padding from 0 to 1. Default value: 0.
## Function ui.beginCombo(label, previewValue, flags)
It’s safer to use `ui.combo()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `label`: `string`

  2. `previewValue`: `string`

  3. `flags`: `ui.ComboFlags?` Default value: `ui.ComboFlags.None`.

  Returns:

  - `boolean`
## Function ui.selectable(label, selected, flags, size)

  Parameters:

  1. `label`: `string`

  2. `selected`: `boolean|refbool|nil`

  3. `flags`: `ui.SelectableFlags?` Default value: `ui.SelectableFlags.None`.

  4. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  Returns:

  - `boolean`
## Function ui.beginChild(id, size, border, flags)
It’s safer to use `ui.childWindow()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.
 Note: you have to call `ui.endChild()` even if `ui.beginChild()` returns `false` (don’t waste time drawing content in that case though).

  Parameters:

  1. `id`: `string`

  2. `size`: `number|vec2?` Default value: `vec2(0, 0)`.

  3. `border`: `boolean?` Default value: `false`.

  4. `flags`: `ui.WindowFlags?` Default value: `ui.WindowFlags.NoBackground`.

  Returns:

  - `boolean`
## Function ui.modernMenuItem(label, iconID, selected, flags, childItem)
For use in `ui.onDriverContextMenu()`.

  Parameters:

  1. `label`: `string`

  2. `iconID`: `ui.Icons|nil` Default value: `nil`.

  3. `selected`: `boolean?` Default value: `false`.

  4. `flags`: `ui.SelectableFlags?` Default value: `ui.SelectableFlags.None`.

  5. `childItem`: `boolean?` Increases padding. Default value: `false`.

  Returns:

  - `boolean`
## Function ui.beginTabBar(id, flags)
It’s safer to use `ui.tabBar()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `id`: `string`

  2. `flags`: `ui.TabBarFlags?` Default value: `ui.TabBarFlags.None`.

  Returns:

  - `boolean`
## Function ui.beginTabItem(label, flags, opened)
It’s safer to use `ui.tabBarItem()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `label`: `string`

  2. `flags`: `ui.TabItemFlags?` Default value: `ui.TabItemFlags.None`.

  3. `opened`: `boolean|refbool|nil|nil` Default value: `nil`.

  Returns:

  - `boolean`
## Function ui.beginTreeNode(label, flags)
It’s safer to use `ui.treeNode()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `label`: `string`

  2. `flags`: `ui.TreeNodeFlags?` Default value: `ui.TreeNodeFlags.Framed`.

  Returns:

  - `boolean`
## Function ui.beginPopupContextItem(id, mouseButton)
It’s safer to use `ui.itemPopup()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason.

  Parameters:

  1. `id`: `string`

  2. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Right`.

  Returns:

  - `boolean`
## Function ui.menuItem(label, selected, flags, shortcut)

  Parameters:

  1. `label`: `string`

  2. `selected`: `boolean?` Default value: `false`.

  3. `flags`: `ui.SelectableFlags?` Default value: `ui.SelectableFlags.None`.

  4. `shortcut`: `string|nil` Default value: `nil`.

  Returns:

  - `boolean`
## Function ui.beginMenu(id, selected, enabled, shortcut)

  Parameters:

  1. `id`: `string`

  2. `selected`: `boolean?` Default value: `false`.

  3. `enabled`: `boolean?` Default value: `true`.

  4. `shortcut`: `string|nil` Default value: `nil`.

  Returns:

  - `boolean`
## Function ui.openPopup(id)
Base IMGUI popup model for something more custom.

  Parameters:

  1. `id`: `string`
## Function ui.closePopup()
Close currently drawn popup.
function ui.closePopup() end
## Function ui.beginPopup(id, flags, padding, opened)

  Parameters:

  1. `id`: `string`

  2. `flags`: `ui.WindowFlags?` Default value: `ui.WindowFlags.None`.

  3. `padding`: `number|vec2|nil` Default value: `nil`.

  4. `opened`: `boolean|refbool|nil|nil` Default value: `nil`.

  Returns:

  - `boolean`
## Function ui.beginTooltip(padding)
It’s safer to use `ui.tooltip()`: a wrapper that would ensure UI wouldn’t break even if Lua script would crash midway for any reason. If you
just need to render some text in a tooltip, use `ui.setTooltip()` instead.

  Parameters:

  1. `padding`: `number|vec2?` Default value: `vec2(20, 8)`.
## Function ui.header(text)

  Parameters:

  1. `text`: `string`
## Function ui.bulletText(text)

  Parameters:

  1. `text`: `string`
## Function ui.setTooltip(tooltip)

  Parameters:

  1. `tooltip`: `string`
## Function ui.itemHovered(flags)
Is the last item hovered and usable, aka not blocked by a popup, etc.

  Parameters:

  1. `flags`: `ui.HoveredFlags?` Default value: `ui.HoveredFlags.None`.

  Returns:

  - `boolean`
## Function ui.itemClicked(mouseButton, buttonBehaviour)
Is the last item clicked (e.g. button/node just clicked on), same as `ui.mouseClicked(mouseButton) and ui.itemHovered()`

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  2. `buttonBehaviour`: `boolean?` If `true`, triggers on release, but only if click position was also within item. Default value: `false`.

  Returns:

  - `boolean`
## Function ui.itemActive()
Is the last item active (e.g. button being held, text field being edited). This will continuously return true while holding mouse button on an item. Items that don’t interact will always return false)

  Returns:

  - `boolean`
## Function ui.itemFocused()
Is the last item focused for keyboard/gamepad navigation.

  Returns:

  - `boolean`
## Function ui.itemVisible()
Is the last item visible (items may be out of sight because of clipping/scrolling).

  Returns:

  - `boolean`
## Function ui.itemEdited()
Did the last item modify its underlying value this frame, or was pressed. This is generally the same as the return value of many widgets.

  Returns:

  - `boolean`
## Function ui.itemActivated()
Was the last item just made active (item was previously inactive).

  Returns:

  - `boolean`
## Function ui.itemDeactivated()
Was the last item just made inactive (item was previously active). Useful for Undo/Redo patterns with widgets that requires continuous editing.

  Returns:

  - `boolean`
## Function ui.itemDeactivatedAfterEdit()
Was the last item just made inactive and made a value change when it was active (e.g. slider moved). Useful for Undo/Redo patterns with widgets that requires continuous editing. Note: you may get false positives (some widgets such as combo/selectable will return true even when clicking an already selected item).

  Returns:

  - `boolean`
## Function ui.anyItemHovered()
Is any item hovered.

  Returns:

  - `boolean`
## Function ui.anyItemActive()
Is any item active.

  Returns:

  - `boolean`
## Function ui.anyItemFocused()
Is any item focused.

  Returns:

  - `boolean`
## Function ui.getItemRectMin()
Get upper-left bounding rectangle of the last item (screen space).

  Returns:

  - `vec2`
## Function ui.getItemRectMax()
Get lower-right bounding rectangle of the last item (screen space).

  Returns:

  - `vec2`
## Function ui.getItemRectSize()
Get size of last item.

  Returns:

  - `vec2`
## Function ui.setItemAllowOverlap()
Allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
function ui.setItemAllowOverlap() end
## Function ui.itemToggledSelection()
Was the last item selection (`ui.selectable()`, `ui.treeNode()`, etc.) toggled

  Returns:

  - `boolean`
## Function ui.image(imageSource, size, color, borderColor, uv1, uv2, mode)
Unlike `ui.drawImage()`, this one adds an image as an item to current cursor position and moves the cursor. Also allows
to interact with an image with functions like `ui.itemHovered()`. You can do the same with `ui.drawImage()`, just use
`ui.getCursor()` for `p1`, `ui.getCursor() + size` for `p2` and `ui.dummy()` for interaction.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  2. `size`: `number|vec2` Size of resulting image in pixels.

  3. `color`: `rgbm?` Tint of the image, with white it would be drawn as it is. Default value: `rgbm.colors.white`.

  4. `borderColor`: `rgbm|nil` Optional 1-pixel wide border around image. Default value: `nil`.

  5. `uv1`: `number|vec2?` Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.

  6. `uv2`: `number|vec2?` Texture coordinates for bottom right corner. Default value: `vec2( 1, 1 )`.

  7. `mode`: `ui.ImageFit?` Stretch mode. Default value: `ui.ImageFit.Stretch`.
## Function ui.imageButton(imageSource, size, bgColor, color, uv1, uv2, framePadding, mode)
Adds a button with an image on it. If image is missing or loading (if it’s remote or asyncronous loading is enabled),
button would still appear, but without an image.

Note: if image source doesn’t have “##” in it, `color` and `bgColor` are swapped. For compatibility reason things are left as is, please
use `ui.iconButton()` instead.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted. Use `##…` postfix for unique ID if you have multiple buttons with the same filename (or, even better, use `ui.pushID()/ui.popID()`.

  2. `size`: `number|vec2` Size of resulting image in pixels.

  3. `bgColor`: `rgbm|nil` Optional background color for the image (transparent if not set). Default value: `nil`.

  4. `color`: `rgbm?` Tint of the image, with white it would be drawn as it is. Default value: `rgbm.colors.white`.

  5. `uv1`: `number|vec2?` Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.

  6. `uv2`: `number|vec2?` Texture coordinates for bottom right corner. Default value: `vec2( 1, 1 )`.

  7. `framePadding`: `number?` If -1, uses frame padding from style. If 0, there is no padding. If above zero, it’s used as actual padding value. Default value: -1.

  8. `mode`: `ui.ImageFit?` Stretch mode. Default value: `ui.ImageFit.Stretch`.

  Returns:

  - `boolean`
## Function ui.iconButton(iconID, size, color, bgColor, framePadding, uv1, uv2, keepAspectRatio, flags)
Adds a button with an image on it. If image is missing or loading (if it’s remote or asyncronous loading is enabled),
button would still appear, but without an image.

  Parameters:

  1. `iconID`: `ui.Icons` Icon or path to the image, absolute or relative to script folder or AC root. URLs are also accepted. Use `##…` postfix for unique ID if you have multiple buttons with the same filename (or, even better, use `ui.pushID()/ui.popID()`.

  2. `size`: `number|vec2|nil` Size of resulting image in pixels. If not set, default button size will be used. Default value: `nil`.

  3. `color`: `rgbm|nil` Tint of the image, with white it would be drawn as it is (text color if not set). Default value: `nil`.

  4. `bgColor`: `rgbm|nil` Optional background color for the image (transparent if not set). Default value: `nil`.

  5. `framePadding`: `number?` Padding (does not affect button size). If negative, default frame padding from current style is used. Use 0 with defined background color (like `rgbm.colors.transparent`) and `keepAspectRatio` set to `false` to hide the frame and only show the image. Default value: -1.

  6. `uv1`: `number|vec2?` Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.

  7. `uv2`: `number|vec2?` Texture coordinates for bottom right corner. Default value: `vec2( 1, 1 )`.

  8. `keepAspectRatio`: `boolean?` Set to `true` to stretch image to fit given size, making sure it would not get distorted. Default value: `true`.

  9. `flags`: `ui.ButtonFlags?` Default value: `ui.ButtonFlags.None`.

  Returns:

  - `boolean`
## Function ui.isImageReady(imageSource)
Returns `true`, if an image is ready to be drawn. If image was not used before, starts its loading.

Note: By default images from local files are loaded syncronously, use `ui.setAsynchronousImagesLoading(true)` function to change this behaviour.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  Returns:

  - `boolean`
## Function ui.setAsynchronousImagesLoading(value)
Activates synchronous loading for local images. By default local images are loaded syncronously, but by calling this function
and passing `true` to it, they would start to load asyncronously from there, reducing possible stutters. Any remote images are loaded
asyncronously no matter what.

Note: for now, any image ever loaded would remain in RAM and video memory. Try not to load way too many things.

  Parameters:

  1. `value`: `boolean?` Default value: `true`.
## Function ui.setForcedImagesCaching(value)
Forces CSP to ignore all those HTTP headers and reuse cached versions of remote images.

  Parameters:

  1. `value`: `boolean?` Default value: `true`.
## Function ui.calcItemWidth()
Width of item given pushed settings and current cursor position. NOT necessarily the width of last item unlike most 'Item' functions.

  Returns:

  - `number`
## Function ui.pushAllowKeyboardFocus(allowKeyboardFocus)
Allow focusing using Tab/Shift+Tab, enabled by default but you can disable it for certain widgets.

  Parameters:

  1. `allowKeyboardFocus`: `boolean|`true`|`false``
## Function ui.popAllowKeyboardFocus()
Removes last `ui.pushAllowKeyboardFocus()` modification.

  Returns:

  - `boolean`
## Function ui.pushButtonRepeat(repeatValue)
In repeat mode, button functions return repeated true in a typematic manner.
Note: you can call `ui.itemActive()` after any button to tell if the button is held in the current frame.

  Parameters:

  1. `repeatValue`: `boolean|`true`|`false``
## Function ui.popButtonRepeat()
Removes last `ui.pushButtonRepeat()` modification

  Returns:

  - `boolean`
## Function ui.indent(indentW)
Move content position toward the right.

  Parameters:

  1. `indentW`: `number?` If 0, indent spacing from style will be used. Default value: 0.0.
## Function ui.unindent(indentW)
Move content position back to the left.

  Parameters:

  1. `indentW`: `number?` If 0, indent spacing from style will be used. Default value: 0.0.
## Function ui.cursorStartPos()
Initial cursor position in window coordinates.

  Returns:

  - `vec2`
## Function ui.cursorScreenPos()
Cursor position in absolute screen coordinates (within AC window or its UI in VR, but also affected by UI scale).

  Returns:

  - `vec2`
## Function ui.setCursorScreenPos(pos)
Cursor position in absolute screen coordinates (within AC window or its UI in VR, but also affected by UI scale).

  Parameters:

  1. `pos`: `number|vec2`
## Function ui.alignTextToFramePadding()
Vertically align upcoming text baseline to frame padding so that it will align properly to regularly framed items (call if you have text on a line before a framed item).
function ui.alignTextToFramePadding() end
## Function ui.textLineHeight()
Pretty much just font size.

  Returns:

  - `number`
## Function ui.textLineHeightWithSpacing()
Returns font size and vertical item spacing (distance in pixels between 2 consecutive lines of text).

  Returns:

  - `number`
## Function ui.frameHeight()
Returns font size and frame padding.

  Returns:

  - `number`
## Function ui.frameHeightWithSpacing()
Returns font size, frame padding and vertical item spacing (distance in pixels between 2 consecutive lines of framed widgets).

  Returns:

  - `number`
## Function ui.fontSize()
Get current font size (height in pixels) of current font with current scale applied.

  Returns:

  - `number`
## Function ui.fontWhitePixelUV()
Get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API.

  Returns:

  - `vec2`
## Function ui.pushStyleVarAlpha(alpha)
Pushes new alpha value taking into account current style alpha, good for fading elements in case any parent elements could also fade.
To revert change, use `ui.popStyleVar()`.

  Parameters:

  1. `alpha`: `number`
## Function ui.pushAlignment(vertical, alignment)
Experimental.

  Parameters:

  1. `vertical`: `boolean?` Default value: `false`.

  2. `alignment`: `number?` Default value: 0.5.
## Function ui.popAlignment()
Experimental.
function ui.popAlignment() end
## Function ui.setScrollFromPosX(localX, centerXRatio)
Adjust scrolling amount to make given position visible. Generally `ui.cursorStartPos() + offset` to compute a valid position.

  Parameters:

  1. `localX`: `number`

  2. `centerXRatio`: `number?` Default value: 0.5.
## Function ui.setScrollFromPosY(localY, centerYRatio)
Adjust scrolling amount to make given position visible. Generally `ui.cursorStartPos() + offset` to compute a valid position.

  Parameters:

  1. `localY`: `number`

  2. `centerYRatio`: `number?` Default value: 0.5.
## Function ui.windowTitle()
Get current window title.

  Returns:

  - `string`
## Function ui.forceSimplifiedComposition()
Stop frosted effect of semi-transparent IMGUI surfaces for a single frame.
function ui.forceSimplifiedComposition() end
## Function ui.passthroughIMGUI()
Allow AC to see mouse events for a frame, even if IMGUI is handling them.
function ui.passthroughIMGUI() end
## Function ui.windowWidth()
Get current window width (shortcut for `ui.windowSize().x`)

  Returns:

  - `number`
## Function ui.windowHeight()
Get current window height (shortcut for `ui.windowSize().y`)

  Returns:

  - `number`
## Function ui.isWindowAppearing()
If current window just been opened.

  Returns:

  - `boolean`
## Function ui.isWindowCollapsed()
Is current window collapsed.

  Returns:

  - `boolean`
## Function ui.isWindowFocused(flags)
Is current window focused (or its root/child, depending on flags).

  Parameters:

  1. `flags`: `ui.FocusedFlags?` Default value: `ui.FocusedFlags.None`.

  Returns:

  - `boolean`
## Function ui.keyPressedAmount(keyIndex, repeatDelay, rate)
Uses provided repeat rate/delay. Return a count, most often 0 or 1, but might be > 1 if RepeatRate is small enough that DeltaTime > RepeatRate

  Parameters:

  1. `keyIndex`: `ui.KeyIndex`

  2. `repeatDelay`: `number`

  3. `rate`: `number`

  Returns:

  - `integer`
## Function ui.isAnyMouseDown()
Is any mouse button held.

  Returns:

  - `boolean`
## Function ui.isMouseReleased(mouseButton)
Did mouse button released (went from down to not down).

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  Returns:

  - `boolean`
## Function ui.isMouseDragging(mouseButton, lockThreshold)
Is mouse dragging. If `lockThreshold` < -1, uses io.MouseDraggingThreshold

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  2. `lockThreshold`: `number?` Default value: -1.0.

  Returns:

  - `boolean`
## Function ui.mousePosOnOpeningCurrentPopup()
Retrieve backup of mouse position at the time of opening popup we have `ui.beginPopup()` into

  Returns:

  - `vec2`
## Function ui.mouseDragDelta(mouseButton, lockThreshold)
Return the delta from the initial clicking position while the mouse button is pressed or was just released. This is locked and
return 0 until the mouse moves past a distance threshold at least once.

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.

  2. `lockThreshold`: `number?` If below zero, default mouse dragging threshold will be used. Default value: -1.0.

  Returns:

  - `vec2`
## Function ui.resetMouseDragDelta(mouseButton)
Resets mouse drag delta.

  Parameters:

  1. `mouseButton`: `ui.MouseButton?` Default value: `ui.MouseButton.Left`.
## Function ui.mouseCursor()
Get cursor type. Cursor type resets in with each new frame

  Returns:

  - `ui.MouseCursor`
## Function ui.setMouseCursor(type)
Set cursor type.

  Parameters:

  1. `type`: `ui.MouseCursor`
## Function ui.captureMouse(wantCaptureMouseValue)
Stops rest of Assetto Corsa from responding to mouse events, also sets `getUI().wantCaptureMouse` flag. Note:
 if you writing a script reacting to general mouse events, consider checking that flag to make sure IMGUI doesn’t have mouse captured currently.

  Parameters:

  1. `wantCaptureMouseValue`: `boolean?` Default value: `true`.
## Function ui.getClipboardText()
Get text that is currently in clipboard.

  Returns:

  - `string`
## Function ui.setClipboardText(text)
Set new text to clipboard.
Added by mistake, use `ac.setClipboardText()`.

  Parameters:

  1. `text`: `string`
## Function ui.time()
Get global IMGUI time. Incremented by `dt` every frame.

  Returns:

  - `number`
## Function ui.frameCount()
Get global IMGUI frame count. Incremented by 1 every frame.

  Returns:

  - `integer`
## Function ui.onUIFinale(callback)
Sets a callback which will be called when main UI IMGUI render is complete (currenly works for window calls of Lua apps).

  Parameters:

  1. `callback`: `fun()`

  Returns:

  - `ac.Disposable`
## Function ui.onChat(callback, settingsCallback)
Sets a callback for drawing chat UI which will be called first. Anything drawn here will likely be covered by other UI elements. Return `true`
to stop the rest of UI to be drawn in this frame. Use `mode` passed in your callback to determine the state of the game: chances are you’d need to draw your
HUD only with `'game'` mode.

New values for `mode` might in theory be added later (or maybe not, hard to tell at this point).

Not available to car and track scripts.

  Parameters:

  1. `callback`: `fun(mode: 'menu'|'game', readOnlyMode: boolean): boolean?`

  2. `settingsCallback`: `fun(): boolean??` Default value: `nil`.

  Returns:

  - `ac.Disposable`
## Function ui.onExclusiveHUD(callback)
Sets a callback for drawing UI which will be called first. Anything drawn here will likely be covered by other UI elements. Return `true`
to stop the rest of UI to be drawn in this frame (including AC UI). Return `'debug'` to also show Lua Debug app, in case you’d need it
for development. Use `mode` passed in your callback to determine the state of the game: chances are you’d need to draw your
HUD only with `'game'` mode.

New values for `mode` might in theory be added later (or maybe not, hard to tell at this point).

Not available to car and track scripts.

Since 0.2.8, return `'finalize'` to allow `ui.popup()` and `ui.onUIFinale()`.

  Parameters:

  1. `callback`: `fun(mode: 'menu'|'pause'|'results'|'replay'|'game'): 'debug'|'apps'|boolean?`

  Returns:

  - `ac.Disposable`
## Function ui.modalPopup(title, msg, okText, cancelText, okIconID, cancelIconID, callback)
Open modal popup message with OK and Cancel buttons, return user choice via callback.

  Parameters:

  1. `title`: `string`

  2. `msg`: `string`

  3. `okText`: `string|nil` Optional label for OK button. Default value: `nil`.

  4. `cancelText`: `string|nil` Optional label for cancel button. Default value: `nil`.

  5. `okIconID`: `ui.Icons|nil` Optional icon for OK button. Default value: `nil`.

  6. `cancelIconID`: `ui.Icons|nil` Optional icon for cancel button. Default value: `nil`.

  7. `callback`: `fun(okPressed: boolean)?` Default value: `nil`.
## Function ui.modalDialog(title, callback, autoclose, closeCallback)
Open modal dialog with custom UI. Return `true` from callback when it’s time to close the dialog.

 To match original dialogs use `ui.newLine()` after the message and vertical offset of four pixels before drawing the buttons. For buttons use
 `ui.modernButton()` with the height of 40 pixels and the gap of 8 pixels.

  Parameters:

  1. `title`: `string`

  2. `callback`: `fun(): boolean`

  3. `autoclose`: `boolean?` Automatically close if clicked outside of dialog. Default value: `false`.

  4. `closeCallback`: `fun()?` Default value: `nil`.
## Function ui.modalPrompt(title, msg, defaultValue, okText, cancelText, okIconID, cancelIconID, callback)
Open modal popup message with text input, OK and Cancel buttons, return user choice via callback.

  Parameters:

  1. `title`: `string`

  2. `msg`: `string`

  3. `defaultValue`: `string?`

  4. `okText`: `string?` Optional label for OK button.

  5. `cancelText`: `string?` Optional label for cancel button.

  6. `okIconID`: `ui.Icons` Optional icon for OK button.

  7. `cancelIconID`: `ui.Icons` Optional icon for cancel button.

  8. `callback`: `fun(value: string|nil)`
## Function ui.projectPoint(pos, considerUiScale)
Projects world point onto a screen (taking into account UV scale unless second argument is set to `false`).

  Parameters:

  1. `pos`: `vec3`

  2. `considerUiScale`: `boolean?` Default value: `true`.

  Returns:

  - `vec2` Returns vector with `inf` for values if point is outside of screen.
## Function ui.unloadImage(imageSource)
If possible, unloads image from memory and VRAM. Doesn’t work with all types of images.

  Parameters:

  1. `imageSource`: `ui.ImageSource`

  Returns:

  - `boolean` Returns `true` if file was unloaded successfully.
## Function ui.drawDriverIcon(carIndex, pos, useCustomIcon)
Draws 14×14 pixels driver icon (rounded livery or a custom icon if icon is overriden).

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `pos`: `number|vec2`

  3. `useCustomIcon`: `boolean?` Default value: `true`.
## Function ui.setDriverTooltip(carIndex)
Add tooltip with details about a certain driver.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.
## Function ui.setDriverPopup(id, carIndex)
Shows context menu for a certain driver. Use `ui.openPopup(id)` to trigger it first.

  Parameters:

  1. `id`: `string`

  2. `carIndex`: `integer` 0-based car index.

  Returns:

  - `boolean` Returns `false` once popup closes.
## Function ui.mentionDriverInChat(carIndex, autofocus)
Adds mention of a driver in chat input.

  Parameters:

  1. `carIndex`: `integer`

  2. `autofocus`: `boolean?` Default value: `true`.
## Function ui.imageState(imageSource)
Returns state of an image (might act strage with special textures, like the ones loaded from DLLs; new return values might be added later).

  Parameters:

  1. `imageSource`: `string` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.
## Function ac.setAppWindowVisible(appID, windowFilter, visible)
Shows a hidden app window or few while current script is alive (temporarily removing “HIDDEN” window flag).

  Parameters:

  1. `appID`: `string`

  2. `windowFilter`: `string?` Default value: '?'.

  3. `visible`: `boolean?` Default value: `true`.
## Function ac.setAppOpen(appID)
Opens a main window of a Lua app (or, if opened, brings it to focus).

  Parameters:

  1. `appID`: `string`
## Function loading.carID()

  Returns:

  - `string`
## Function loading.carSkinID()

  Returns:

  - `string`
## Function loading.trackID()

  Returns:

  - `string`
## Function loading.trackLayoutID()

  Returns:

  - `string`
## Function loading.progress()
Returns estimate of loading progress from 0 to 1.

  Returns:

  - `number`
## Function loading.stopped()
Returns `true` if loading has stopped and AC will shut down soon.

  Returns:

  - `boolean`
## Function loading.version()
Returns AC version string in a format `Assetto Corsa <VERSION> & Custom Shaders Patch <VERSION>`.

  Returns:

  - `string`
## Function loading.carName()

  Returns:

  - `string`
## Function loading.trackName()

  Returns:

  - `string`
## Function loading.status()
Main status message.

  Returns:

  - `string`
## Function loading.details()
Details status message.

  Returns:

  - `string`
## Function loading.carHints()

  Returns:

  - `string`
## Function loading.trackHints()

  Returns:

  - `string`
## Function loading.serverHints()

  Returns:

  - `string`
## Function loading.warning()
Returns `nil` or two strings for a warning (title and details). Please consider showing it if it’s non-nil, those warnings
might be important.

  Returns:

  - `string`
## Class ScriptData

# Module common/debug.lua

## Function ac.debug(key, value)
Displays value in Lua Debug app, great for tracking state of your values live.

  Parameters:

  1. `key`: `string`

  2. `value`: `any?`
## Function ac.log(...)
Prints a message to a CSP log and to Lua App Debug log. To speed things up and only use Lua Debug app, call `ac.setLogSilent()`.

  Parameters:

  1. `...`: `string|number|boolean` Values.
## Function ac.warn(...)
Prints a warning message to a CSP log and to Lua App Debug log. To speed things up and only use Lua Debug app, call `ac.setLogSilent()`.

  Parameters:

  1. `...`: `string|number|boolean` Values.
## Function ac.error(...)
Prints an error message to a CSP log and to Lua App Debug log. To speed things up and only use Lua Debug app, call `ac.setLogSilent()`.

  Parameters:

  1. `...`: `string|number|boolean` Values.
## Function print(...)
For compatibility, acts similar to `ac.log()`.
function print(...) end

# Module common/common_base.lua

## Function try(fn, catch, finally)
Calls a function in a safe way, catching errors. If any errors were to occur, `catch` would be
called with an error message as an argument. In either case (with and without error), if provided,
`finally` will be called.

Does not raise errors unless errors were thrown by `catch` or `finally`. Before CSP 0.2.5, if `catch`
throws an error, `finally` wouldn’t be called (fixed in 0.2.5).

  Parameters:

  1. `fn`: `fun(): T?`

  2. `catch`: `fun(err: string)|nil` If not set, error won’t propagate anyway.

  3. `finally`: `fun()|nil`

  Returns:

  - `T|nil`
## Function using(fn, dispose)
Calls a function and then calls `dispose` function. Note: `dispose` function will be called even if
there would be an error in `fn` function. But error would not be contained and will propagate.

Any error thrown by `fn()` will be raised and not captured, but `dispose()` will be called either way.

  Parameters:

  1. `fn`: `fun(): T?`

  2. `dispose`: `fun()?` CSPs before 0.2.5 require non-nil argument.

  Returns:

  - `T|nil`
## Function package.relative(path)
Resolves relative path to a Lua module (relative to Lua file you’re running this function from)
so it would be ready to be passed to `require()` function.

Note: performance might be a problem if you are calling it too much, consider caching the result.

  Parameters:

  1. `path`: `string`

  Returns:

  - `string`
## Function io.relative(path)
Resolves relative path to a file (relative to Lua file you’re running this function from)
so it would be ready to be passed to `io` functions (returns full path).

Note: performance might be a problem if you are calling it too much, consider caching the result.

  Parameters:

  1. `path`: `string`

  Returns:

  - `string`
## Function ac.fillStructWithBytes(destination, data)
Given an FFI struct and a string of data, fills struct with that data. Works only if size of struct matches size of data. Data string can contain zeroes.

  Parameters:

  1. `destination`: `T` FFI struct (type should be “cdata”).

  2. `data`: `binary` String with binary data.

  Returns:

  - `T`
## Function ac.stringToFFIStruct(src, dst, size)
Fills a string of an FFI struct with data up to a certain size. Make sure to not overfill the data.

  Parameters:

  1. `src`: `string` String to copy.

  2. `dst`: `string` A `const char[N]` field of a struct.

  3. `size`: `integer` Size of `const char[N]` field (N).
## Function ac.getCarDataFiles(index)
Returns ordered list of data file names (not full paths, just the names) of a certain car. Works for both packed and unpacked cars. If failed,
returns empty list.

  Parameters:

  1. `index`: `integer` 0-based car index.

  Returns:

  - `string`
## Function ac.getCarColliders(index, actualColliders)
Returns list of car colliders.

  Parameters:

  1. `index`: `integer` 0-based car index.

  2. `actualColliders`: `boolean?` Set to `true` to draw actual physics colliders (might differ due to some physics alterations).

# Module common/const.lua

## Function const(value)
Does nothing, but with preprocessing optimizations inlines value as constant.

  Parameters:

  1. `value`: `T`

  Returns:

  - `T`

# Module common/ac_matrices.lua

## Function mat3x3.identity()
Creates a new neutral matrix.

  Returns:

  - `mat3x3`
## Function mat3x3(row1, row2, row3)

  Parameters:

  1. `row1`: `vec3?`

  2. `row2`: `vec3?`

  3. `row3`: `vec3?`

  Returns:

  - `mat3x3`
## Class mat3x3

- `mat3x3.identity()`

  Creates a new neutral matrix.

  Returns:

    - `mat3x3`

- `mat3x3:set(value)`

  Parameters:

    1. `value`: `mat3x3`

  Returns:

    - `mat3x3`

- `mat3x3:clone()`

  Returns:

    - `mat3x3`
## Function mat4x4.identity()
Creates a new neutral matrix.

  Returns:

  - `mat4x4`
## Function mat4x4.translation(offset)
Creates a translation matrix.

  Parameters:

  1. `offset`: `vec3`

  Returns:

  - `mat4x4`
## Function mat4x4.rotation(angle, axis)
Creates a rotation matrix.

  Parameters:

  1. `angle`: `number` Angle in radians.

  2. `axis`: `vec3`

  Returns:

  - `mat4x4`
## Function mat4x4.euler(head, pitch, roll)
Creates a rotation matrix from Euler angles in radians.

  Parameters:

  1. `head`: `number`

  2. `pitch`: `number`

  3. `roll`: `number`

  Returns:

  - `mat4x4`
## Function mat4x4.scaling(scale)
Creates a scaling matrix.

  Parameters:

  1. `scale`: `vec3`

  Returns:

  - `mat4x4`
## Function mat4x4.look(position, look, up)
Creates a look-at matrix from position and directional vectors. Ensures all vectors are properly normalized.

  Parameters:

  1. `position`: `vec3`

  2. `look`: `vec3`

  3. `up`: `vec3?` Default value: `vec3(0, 1, 0)`.

  Returns:

  - `mat4x4`
## Function mat4x4.perspective(fovY, aspect, zNear, zFar)
Creates a perspective matrix.

  Parameters:

  1. `fovY`: `number` Vertical view angle in radians.

  2. `aspect`: `number` Aspect ratio.

  3. `zNear`: `number` Near clipping plane.

  4. `zFar`: `number` Far clipping plane.

  Returns:

  - `mat4x4`
## Function mat4x4.ortho(extentMin, extentMax)
Creates an orthogonal matrix. Might act unexpected with Z values, shifting by range should help.

  Parameters:

  1. `extentMin`: `vec3`

  2. `extentMax`: `vec3`

  Returns:

  - `mat4x4`
## Function mat4x4(row1, row2, row3, row4)

  Parameters:

  1. `row1`: `vec4?`

  2. `row2`: `vec4?`

  3. `row3`: `vec4?`

  4. `row4`: `vec4?`

  Returns:

  - `mat4x4`
## Class mat4x4

- `mat4x4.identity()`

  Creates a new neutral matrix.

  Returns:

    - `mat4x4`

- `mat4x4.translation(offset)`

  Creates a translation matrix.

  Parameters:

    1. `offset`: `vec3`

  Returns:

    - `mat4x4`

- `mat4x4.rotation(angle, axis)`

  Creates a rotation matrix.

  Parameters:

    1. `angle`: `number` Angle in radians.

    2. `axis`: `vec3`

  Returns:

    - `mat4x4`

- `mat4x4.euler(head, pitch, roll)`

  Creates a rotation matrix from Euler angles in radians.

  Parameters:

    1. `head`: `number`

    2. `pitch`: `number`

    3. `roll`: `number`

  Returns:

    - `mat4x4`

- `mat4x4.scaling(scale)`

  Creates a scaling matrix.

  Parameters:

    1. `scale`: `vec3`

  Returns:

    - `mat4x4`

- `mat4x4.look(position, look, up)`

  Creates a look-at matrix from position and directional vectors. Ensures all vectors are properly normalized.

  Parameters:

    1. `position`: `vec3`

    2. `look`: `vec3`

    3. `up`: `vec3?` Default value: `vec3(0, 1, 0)`.

  Returns:

    - `mat4x4`

- `mat4x4.perspective(fovY, aspect, zNear, zFar)`

  Creates a perspective matrix.

  Parameters:

    1. `fovY`: `number` Vertical view angle in radians.

    2. `aspect`: `number` Aspect ratio.

    3. `zNear`: `number` Near clipping plane.

    4. `zFar`: `number` Far clipping plane.

  Returns:

    - `mat4x4`

- `mat4x4.ortho(extentMin, extentMax)`

  Creates an orthogonal matrix. Might act unexpected with Z values, shifting by range should help.

  Parameters:

    1. `extentMin`: `vec3`

    2. `extentMax`: `vec3`

  Returns:

    - `mat4x4`

- `mat4x4:set(value)`

  Parameters:

    1. `value`: `mat4x4`

  Returns:

    - `mat4x4`

- `mat4x4:transformVectorTo(destination, vec)`

  Parameters:

    1. `destination`: `vec3`

    2. `vec`: `vec3`

  Returns:

    - `vec3`

- `mat4x4:transformVector(vec)`

  Parameters:

    1. `vec`: `vec3`

  Returns:

    - `vec3`

- `mat4x4:transformTo(destination, vec)`

  Parameters:

    1. `destination`: `vec4`

    2. `vec`: `vec4`

  Returns:

    - `vec4`

- `mat4x4:transform(vec)`

  Parameters:

    1. `vec`: `vec4`

  Returns:

    - `vec4`

- `mat4x4:transformPointTo(destination, vec)`

  Parameters:

    1. `destination`: `vec3`

    2. `vec`: `vec3`

  Returns:

    - `vec3`

- `mat4x4:transformPoint(vec)`

  Parameters:

    1. `vec`: `vec3`

  Returns:

    - `vec3`

- `mat4x4:clone()`

  Returns:

    - `mat4x4`

- `mat4x4:inverse()`

  Creates a new matrix.

  Returns:

    - `mat4x4`

- `mat4x4:inverseSelf()`

  Modifies current matrix.

  Returns:

    - `mat4x4` Returns self for easy chaining.

- `mat4x4:normalize()`

  Creates a new matrix.

  Returns:

    - `mat4x4`

- `mat4x4:normalizeSelf()`

  Modifies current matrix.

  Returns:

    - `mat4x4` Returns self for easy chaining.

- `mat4x4:transpose()`

  Creates a new matrix.

  Returns:

    - `mat4x4`

- `mat4x4:transposeSelf()`

  Modifies current matrix.

  Returns:

    - `mat4x4` Returns self for easy chaining.

- `mat4x4:mul(other)`

  Note: unlike vector’s `:mul()`, this one creates a new matrix!

  Parameters:

    1. `other`: `mat4x4`

  Returns:

    - `mat4x4`

- `mat4x4:mulSelf(other)`

  Modifies current matrix.

  Parameters:

    1. `other`: `mat4x4`

  Returns:

    - `mat4x4` Returns self for easy chaining.

- `mat4x4:mulTo(destination, other)`

  Writes result into a separate matrix.

  Parameters:

    1. `destination`: `mat4x4`

    2. `other`: `mat4x4`

  Returns:

    - `mat4x4` Returns destination matrix.

# Module common/math.lua

## Function math.gaussianAdjustment(x, k)
Takes value with even 0…1 distribution and remaps it to recreate a distribution
similar to Gaussian’s one (with k≈0.52, a default value). Lower to make bell more
compact, use a value above 1 to get some sort of inverse distibution.

  Parameters:

  1. `x`: `number` Value to adjust.

  2. `k`: `number` Bell curvature parameter.

  Returns:

  - `number`
## Function math.poissonSamplerSquare(size, tileMode)
Builds a list of points arranged in a square with poisson distribution.

  Parameters:

  1. `size`: `integer` Number of points.

  2. `tileMode`: `boolean?` If set to `true`, resulting points would be tilable without breaking poisson distribution.

  Returns:

  - `vec2`
## Function math.poissonSamplerCircle(size)
Builds a list of points arranged in a circle with poisson distribution.

  Parameters:

  1. `size`: `integer` Number of points.

  Returns:

  - `vec2`
## Function math.randomKey()
Generates a random number in [0, INT32_MAX) range. Can be a good argument for `math.randomseed()`.

  Returns:

  - `integer`
## Function math.seededRandom(seed)
Generates random number based on a seed.

  Parameters:

  1. `seed`: `integer|boolean|string` Seed.

  Returns:

  - `number` Random number from 0 to 1.
## Function math.round(number, decimals)
Rounds number, leaves certain number of decimals.

  Parameters:

  1. `number`: `number`

  2. `decimals`: `number?` Default value: 0 (rounding to a whole number).

  Returns:

  - `integer`
## Function math.clampN(value, min, max)
Clamps a number value between `min` and `max`.

  Parameters:

  1. `value`: `number`

  2. `min`: `number`

  3. `max`: `number`

  Returns:

  - `number`
## Function math.saturateN(value)
Clamps a number value between 0 and 1.

  Parameters:

  1. `value`: `number`

  Returns:

  - `number`
## Function math.clampV(value, min, max)
Clamps a copy of a vector between `min` and `max`. To avoid making copies, use `vec:clamp(min, max)`.

  Parameters:

  1. `value`: `T`

  2. `min`: `any`

  3. `max`: `any`

  Returns:

  - `T`
## Function math.saturateV(value)
Clamps a copy of a vector between 0 and 1. To avoid making copies, use `vec:saturate()`.

  Parameters:

  1. `value`: `T`

  Returns:

  - `T`
## Function math.clamp(x, min, max)
Clamps value between `min` and `max`, returning `min` if `x` is below `min` or `max` if `x` is above `max`. Universal version, so might be slower.
Also, if given a vector or a color, would make a copy of it.

  Parameters:

  1. `x`: `T`

  2. `min`: `any`

  3. `max`: `any`

  Returns:

  - `T`
## Function math.saturate(x)
Clamps value between 0 and 1, returning 0 if `x` is below 0 or 1 if `x` is above 1. Universal version, so might be slower.
Also, if given a vector or a color, would make a copy of it.

  Parameters:

  1. `x`: `T`

  Returns:

  - `T`
## Function math.sign(x)
Returns a sing of a value, or 0 if value is 0.

  Parameters:

  1. `x`: `number`

  Returns:

  - `integer`
## Function math.lerp(x, y, mix)
Linear interpolation between `x` and `y` using `mix` (x * (1 - mix) + y * mix).

  Parameters:

  1. `x`: `T`

  2. `y`: `T`

  3. `mix`: `number`

  Returns:

  - `T`
## Function math.lerpInvSat(value, min, max)
Returns 0 if value is less than v0, returns 1 if it’s more than v1, linear interpolation in-between.

  Parameters:

  1. `value`: `number`

  2. `min`: `number`

  3. `max`: `number`

  Returns:

  - `number`
## Function math.remap(value, oldA, oldB, newA, newB)
Returns `newA` if `value` equals to `oldA`, `newB` if `value` is `oldB`, applies linear interpolation for other input values. Doesn’t apply clamping.

  Parameters:

  1. `value`: `number`

  2. `oldA`: `number`

  3. `oldB`: `number`

  4. `newA`: `number`

  5. `newB`: `number`

  Returns:

  - `number`
## Function math.smoothstep(x)
Smoothstep operation. More about it in [wiki](https://en.wikipedia.org/wiki/Smoothstep).

  Parameters:

  1. `x`: `number`

  Returns:

  - `number`
## Function math.smootherstep(x)
Like a smoothstep operation, but even smoother.

  Parameters:

  1. `x`: `number`

  Returns:

  - `number`
## Function math.normalize(x)
Creates a copy of a vector and normalizes it. Consider using a method `vec:normalize()` instead when you can change the original vector to save on performanceMeter.

  Parameters:

  1. `x`: `T`

  Returns:

  - `T`
## Function math.cross(x, y)
Creates a copy of a vector and runs a cross product on it. Consider avoiding making a copy with `vec:cross(otherVec)`.

  Parameters:

  1. `x`: `vec3`

  Returns:

  - `vec3`
## Function math.dot(x, y)
Calculates dot product of two vectors.

  Parameters:

  1. `x`: `vec2|vec3|vec4`

  Returns:

  - `number`
## Function math.angle(x, y)
Calculates angle between vectors in radians.

  Parameters:

  1. `x`: `vec2|vec3|vec4`

  Returns:

  - `number` Radians.
## Function math.distance(x, y)
Calculates distance between vectors.

  Parameters:

  1. `x`: `vec2|vec3|vec4`

  Returns:

  - `number`
## Function math.distanceSquared(x, y)
Calculates squared distance between vectors (slightly faster without taking a square root).

  Parameters:

  1. `x`: `vec2|vec3|vec4`

  Returns:

  - `number`
## Function math.project(x, y)
Creates a copy of a vector and projects it onto a different vector. Consider avoiding making a copy with `vec:project(otherVec)`.

  Parameters:

  1. `x`: `T`

  Returns:

  - `T`
## Function math.isnan(x)
Checks if value is not-a-number.

  Parameters:

  1. `x`: `number`

  Returns:

  - `boolean`
## Function math.isinf(x)
Checks if value is positive or negative infinity.

  Parameters:

  1. `x`: `number`

  Returns:

  - `boolean`
## Function math.isfinite(x)
Checks if value is finite (not infinite or nan).

  Parameters:

  1. `x`: `number`

  Returns:

  - `boolean`
## Function math.isNaN(x)
## Function math.lagMult(lag, dt)

  Parameters:

  1. `lag`: `number`

  2. `dt`: `number`

  Returns:

  - `number`
## Function math.perlin(input, octaves, persistence)
Perlin noise for given input. Returns value within -1…1 range, or outside of it if `octaves` is above 1. If you’re using octaves, make sure `input`
won’t overflow when being multiplied by two multiple times.

  Parameters:

  1. `input`: `number|vec2|vec3`

  2. `octaves`: `integer?` Pass number greater than 1 to generate octave noise instead (sum `octaves` noise functions together increasing input and multiplying amplitude by `persistence` each step). Default value: 1.

  3. `persistence`: `number?` Persistance for octave noise. Used only if `octaves` is above 1. Default value: 0.5.

  Returns:

  - `number`
## Function math.convertHDR(input, toLDR)
Roughly convert HDR value to LDR using conversion hints provided by current WeatherFX style. Doesn’t apply nothing like tonemapping or exposure
correction, simply adjusts for a case where WeatherFX style uses small brightness multiplier or linear color space.

Note: shaders have the same function called `convertHDR()`.

  Parameters:

  1. `input`: `T` Value to convert.

  2. `toLDR`: `boolean?` Pass `true` to do the reverse and convert LDR to HDR. Default value: `false`.

  Returns:

  - `T`
## Function math.applyLag(value, target, lag, dt)

  Parameters:

  1. `value`: `T`

  2. `target`: `T`

  3. `lag`: `number`

  4. `dt`: `number`

  Returns:

  - `T`

# Module common/string.lua

## Function string.dump() return nil
Function won’t work: while CSP tries its best to guarantee API compatibility, ABI compatibility is not a priority at all,
and the underlying LuaJIT implementation frequently changes and might even be replaced with something else in the future.

  Returns:

  - `nil`
## Function string.split(self, separator, limit, trimResult, skipEmpty, splitByAnyChar)
Splits string into an array using separator.

  Parameters:

  1. `self`: `string` String to split.

  2. `separator`: `string?` Separator. If empty, string will be split into individual characters. Default value: ` `.

  3. `limit`: `integer?` Limit for pieces of string. Once reached, remaining string is put as a list piece.

  4. `trimResult`: `boolean?` Set to `true` to trim found strings. Default value: `false`.

  5. `skipEmpty`: `boolean?` Set to `false` to keep empty strings. Default value: `true` (for compatibility reasons).

  6. `splitByAnyChar`: `boolean?` Set to `true` to split not by a string `separator`, but by any characters in `separator`.

  Returns:

  - `string`
## Function string.numbers(self, limit)
Splits string into a bunch of numbers (not in an array). Any symbol that isn’t a valid part of number is considered to be a delimiter. Does not create an array
to keep things faster. To make it into an array, simply wrap the call in `{}`.

  Parameters:

  1. `self`: `string` String to split.

  2. `limit`: `integer?` Limit for amount of numbers. Once reached, remaining part is ignored.

  Returns:

  - `...` Numbers
## Function string.pack(self, ...)
Pack things. For format, see <https://www.lua.org/manual/5.3/manual.html#6.4.2>.
Use `a` for half-precision floating point value (two bytes).

  Parameters:

  1. `self`: `string` Format string.

  Returns:

  - `string`
## Function string.packsize(self)
Measure size of packed things. For format, see <https://www.lua.org/manual/5.3/manual.html#6.4.2>.
Use `a` for half-precision floating point value (two bytes).

  Parameters:

  1. `self`: `string` Format string.

  Returns:

  - `integer`
## Function string.unpack(self)
Unpack things. For format, see <https://www.lua.org/manual/5.3/manual.html#6.4.2>.
Use `a` for half-precision floating point value (two bytes).

  Parameters:

  1. `self`: `string` Format string.

  Returns:

  - `...`
## Function string.urlCheck(self, offset)
Checks if string starts with an URL or not. Uses flexible parsing scheme so even URLs not starting with
a scheme could be found.

  Parameters:

  1. `self`: `string` Target string.

  2. `offset`: `integer?` Starting search index, 1-based.

  Returns:

  - `integer`
## Function string.urlNext(self, offset)
Finds next URL in a string. Uses flexible parsing scheme so even URLs not starting with
a scheme could be found.

  Parameters:

  1. `self`: `string` Target string.

  2. `offset`: `integer?` Starting search index, 1-based.

  Returns:

  1. `integer`

  2. `integer`
## Function string.findIgnoreCase(self, needle, index)
Works like string.find with plain mode, but ignores case.

  Parameters:

  1. `self`: `string` String to find `needle` in.

  2. `needle`: `string` String to find.

  3. `index`: `integer?` Starting search index. Default value: `1`.

  Returns:

  - `integer`
## Function string.replace(self, replacee, replacer, limit, ignoreCase)
Searches and replaces all the substrings.

  Parameters:

  1. `self`: `string` String to find `replacee` and replace with `replacer` in.

  2. `replacee`: `string` String to find.

  3. `replacer`: `string?` String to replace. Default value: ``.

  4. `limit`: `integer?` Maximum number of found strings to replace. Default value: `math.huge`.

  5. `ignoreCase`: `boolean?` Option for case-incensitive search. Default value: `false`.

  Returns:

  - `string`
## Function string.codePointToUTF8(codePoint)
Returns UTF8 string for a corresponding code point.

  Parameters:

  1. `codePoint`: `integer`

  Returns:

  - `string`
## Function string.codePointAt(self, start)
Returns unicode codepoint and length in bytes from a point in a string. Throws an error with invalid UTF-8.

  Parameters:

  1. `self`: `string` String to get a codepoint from

  2. `start`: `integer` Index (starts with 1, if below counts from the end).

  Returns:

  1. `integer`

  2. `integer` Symbol length (or `nil` if there is no symbol with given index).
## Function string.nextEmoji(self, start)
Looks for a next emoji in the string. If next emoji is complex, all the symbols will be processed and returned as a single byte sequence. Uses 15th version
with data from Emoji Keyboard/Display Test Data for UTS #51.
Not working properly for CSP versions below v0.2.3-preview50.

  Parameters:

  1. `self`: `string` String to search emojis in.

  2. `start`: `integer` Index (starts with 1, if below counts from the end).

  Returns:

  1. `integer`

  2. `integer`
## Function string.urlEncode(self, plusForSpaces)
Encodes URL argument.

  Parameters:

  1. `self`: `string`

  2. `plusForSpaces`: `boolean?` Use `'+'` for space symbol (works for URLs, but if a regular URL encoding is needed, might be getting in a way). Default value: `true`.

  Returns:

  - `string`
## Function string.startsWith(self, another, offset)
Checks if the beginning of a string matches another string. If string to match is longer than the first one, always returns `false`.

  Parameters:

  1. `self`: `string` String to check the beginning of.

  2. `another`: `string` String to match.

  3. `offset`: `integer?` Optional offset for the matching beginning. Default value: `0`.

  Returns:

  - `boolean`
## Function string.endsWith(self, another, offset)
Checks if the end of a string matches another string. If string to match is longer than the first one, always returns `false`.

  Parameters:

  1. `self`: `string` String to check the end of.

  2. `another`: `string` String to match.

  3. `offset`: `integer?` Optional offset for the matching end. Default value: `0`.

  Returns:

  - `boolean`
## Function string.alphanumCompare(self, another)
Compares string alphanumerically.

  Parameters:

  1. `self`: `string` First string.

  2. `another`: `string` Second string.

  Returns:

  - `integer` Returns positive number if first string is larger than second one, or 0 if strings are equal.
## Function string.versionCompare(self, another)
Compares string as versions (splits by dots and uses alphanumerical comparator for each piece).

  Parameters:

  1. `self`: `string` First version.

  2. `another`: `string` Second version.

  Returns:

  - `integer` Returns positive number if first version is newer than second one, or 0 if versions are equal.
## Function string.trim(self, characters, direction)
Trims string at beginning and end.

  Parameters:

  1. `self`: `string` String to trim.

  2. `characters`: `string?` Characters to remove. Default value: `'\n\r\t '`.

  3. `direction`: `integer?` Direction to trim, 0 for trimming both ends, -1 for trimming beginning only, 1 for trimming the end. Default value: `0`.

  Returns:

  - `string`
## Function string.multiply(self, count)
Repeats string a given number of times (`repeat` is a reserved keyword, so here we are).

  Parameters:

  1. `self`: `string` String to trim.

  2. `count`: `integer` Number of times to repeat the string.

  Returns:

  - `string`
## Function string.pad(self, targetLength, pad, direction)
Pads string with symbols from `pad` until it reaches the desired length.

  Parameters:

  1. `self`: `string` String to trim.

  2. `targetLength`: `integer` Desired string length. If shorter than current length, string will be trimmed from the end.

  3. `pad`: `string?` String to pad with. If empty, no padding will be performed. If has more than one symbol, will be repeated to fill the space. Default value: ` ` (space).

  4. `direction`: `integer?` Direction to pad to, 1 for padding at the end, -1 for padding at the start, 0 for padding from both ends centering string. Default value: `1`.

  Returns:

  - `string`
## Function string.regfind(self, pattern, init, ignoreCase)
Similar to `string.find()`: looks for the first match of `pattern` and returns indices, but uses regular expressions.

Note: regular expressions currently are in ECMAScript format, so backtracking is not supported. Also, in most cases they are slower than regular Lua patterns.

  Parameters:

  1. `self`: `string` String to search in.

  2. `pattern`: `string` Regular expression.

  3. `init`: `integer?` 1-based offset to start searching from. Default value: `1`.

  4. `ignoreCase`: `boolean?` Set to `true` to make search case-insensitive. Default value: `false`.

  Returns:

  1. `integer`

  2. `integer`

  3. `...` Captured elements, if there are any capture groups in the pattern.
## Function string.regmatch(self, pattern, init, ignoreCase)
Similar to `string.match()`: looks for the first match of `pattern` and returns matches, but uses regular expressions.

Note: regular expressions currently are in ECMAScript format, so backtracking is not supported. Also, in most cases they are slower than regular Lua patterns.

  Parameters:

  1. `self`: `string` String to search in.

  2. `pattern`: `string` Regular expression.

  3. `init`: `integer?` 1-based offset to start searching from. Default value: `1`.

  4. `ignoreCase`: `boolean?` Set to `true` to make search case-insensitive. Default value: `false`.

  Returns:

  - `string` Captured elements if there are any capture groups in the pattern, or the whole captured string otherwise.
## Function string.reggmatch(self, pattern, ignoreCase)
Similar to `string.gmatch()`: iterates over matches of `pattern`, but uses regular expressions.

Note: regular expressions currently are in ECMAScript format, so backtracking is not supported. Also, in most cases they are slower than regular Lua patterns.

  Parameters:

  1. `self`: `string` String to search in.

  2. `pattern`: `string` Regular expression.

  3. `ignoreCase`: `boolean?` Set to `true` to make search case-insensitive. Default value: `false`.

  Returns:

  - `fun`
## Function string.reggsub(self, pattern, repl, limit, ignoreCase)
Similar to `string.gsub()`: replaces all entries of `pattern` with `repl`, but uses regular expressions.

Note: regular expressions currently are in ECMAScript format, so backtracking is not supported. Also, in most cases they are slower than regular Lua patterns.

  Parameters:

  1. `self`: `string` String to search in.

  2. `pattern`: `string` Regular expression.

  3. `limit`: `integer?` Limit maximum number of replacements. Default value: `math.huge`.

  4. `ignoreCase`: `boolean?` Set to `true` to make search case-insensitive. Default value: `false`.

  Returns:

  - `string` String with found entries replaced.
## Function string.cspmatch(self, filter, init)
Compares a string against CSP-style filter (using “?” for “any characters”).

  Parameters:

  1. `self`: `string` String to check.

  2. `filter`: `string` Filter to check. Surround with `{…}` to use complex queries, for example, `'{ ABC? & ! ?DEF }'`.

  3. `init`: `integer?` 1-based offset to start searching from. Default value: `1`.

  Returns:

  - `boolean`

# Module common/table.lua

## Function table.chain(table, ...)
Merges tables into one big table. Tables can be arrays or dictionaries, if it’s a dictionary same keys from subsequent tables will overwrite previously set keys.

  Parameters:

  1. `table`: `T`

  Returns:

  - `T`
## Function table.isArray(t)
Checks if table is an array or not. Arrays are tables that only have consequtive numeric keys.

  Parameters:

  1. `t`: `table|any[]`

  Returns:

  - `boolean`
## Function table.new(arrayElements, mapElements)
Creates a new table with preallocated space for given amount of elements.

  Parameters:

  1. `arrayElements`: `integer` How many elements the table will have as a sequence.

  2. `mapElements`: `integer` How many other elements the table will have.

  Returns:

  - `table`
## Function table.clear(t)
Cleares table without deallocating space using a fast LuaJIT call. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table`
## Function table.nkeys(t)
Returns the total number of elements in a given Lua table (i.e. from both the array and hash parts combined).

  Parameters:

  1. `t`: `table`

  Returns:

  - `integer`
## Function table.clone(t, deep)
Clones table using a fast LuaJIT call.

  Parameters:

  1. `t`: `T`

  2. `deep`: `boolean?` Set to `true` for deep cloning. Default value: `false`.

  Returns:

  - `T`
## Function table.removeItem(t, item)
Removes first item by value, returns true if any item was removed. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table<any, T>`

  2. `item`: `T`

  Returns:

  - `boolean`
## Function table.getOrCreate(t, key, callback, callbackData)
Returns an element from table with a given key. If there is no such element, calls callback
and uses its return value to add a new element and return that. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table<any, T>`

  2. `key`: `any`

  3. `callback`: `fun(callbackData: TCallbackData): T`

  4. `callbackData`: `TCallbackData?`

  Returns:

  - `T`
## Function table.contains(t, item)
Returns true if table contains an item. Can work with both array and non-array tables.

  Parameters:

  1. `t`: `table<any, T>`

  2. `item`: `T`

  Returns:

  - `boolean`
## Function table.random(t, filteringCallback, filteringCallbackData, randomDevice)
Returns a random item from a table. Optional callback works like a filter. Can work
with both array and non-array tables. Alternatively, optional callback can provide a number
for a weight of an item.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `filteringCallback`: `nil|fun(item: T, key: TKey, callbackData: TCallbackData): boolean`

  3. `filteringCallbackData`: `TCallbackData?`

  4. `randomDevice`: `nil|fun(): number` Optional callback for generating random numbers. Needs to return a value between 0 and 1. If not set, default `math.random` is used.

  Returns:

  - `T`
## Function table.indexOf(t, item)
Returns a key of a given element, or `nil` if there is no such element in a table. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `item`: `T`

  Returns:

  - `TKey|nil`
## Function table.same(t1, t2, deep)
Returns true if tables contents are the same.

  Parameters:

  1. `t1`: `table?`

  2. `t2`: `table?`

  3. `deep`: `boolean?` Default value: `true`.

  Returns:

  - `boolean`
## Function table.join(t, itemsJoin, keyValueJoin, toStringCallback, toStringCallbackData)
Joins elements of a table to a string, works with both arrays and non-array tables. Optinal
toStringCallback parameter can be used for a custom item serialization. All parameters but
`t` (for actual table) are optional and can be skipped.

Note: it wouldn’t work as fast as `table.concat`, but it would call a `tostring()` (or custom
serializer callback) for each element.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `itemsJoin`: `string?` Default value: ','.

  3. `keyValueJoin`: `string?` Default value: '='.

  4. `toStringCallback`: `nil|fun(item: T, key: TKey, callbackData: TCallbackData): string`

  5. `toStringCallbackData`: `TCallbackData?`

  Returns:

  - `TKey|nil`
## Function table.slice(t, from, to, step)
Slices array, basically acts like slicing thing in Python.

  Parameters:

  1. `t`: `T[]`

  2. `from`: `integer` Starting index.

  3. `to`: `integer?` Ending index.

  4. `step`: `integer?` Step.

  Returns:

  - `T`
## Function table.reverse(t)
Flips table from back to front, requires an array.

  Parameters:

  1. `t`: `T[]`

  Returns:

  - `T`
## Function table.map(t, callback, callbackData)
Calls callback function for each of table elements, creates a new table containing all the resulting values.
Can work with both array and non-array tables. For non-array tables, new table is going to be an array unless
callback function would return a key as a second return value.

If callback returns two values, second would be used as a key to create a table-like table (not an array-like one).

Note: if callback returns `nil`, value will be skipped, so this function can act as a filtering one too.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `(fun(item: T, index: TKey, callbackData: TCallbackData): TReturnValue, TReturnKey?)|nil` Mapping callback.

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `table`
## Function table.reduce(t, startingValue, callback, callbackData)
Calls callback function for each of table elements, creates a new table containing all the resulting values.
Can work with both array and non-array tables. For non-array tables, new table is going to be an array unless
callback function would return a key as a second return value.

If callback returns two values, second would be used as a key to create a table-like table (not an array-like one).

Note: if callback returns `nil`, value will be skipped, so this function can act as a filtering one too.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `startingValue`: `TData`

  3. `callback`: `fun(data: TData, item: T, index: TKey, callbackData: TCallbackData): TData` Reduction callback.

  4. `callbackData`: `TCallbackData?`

  Returns:

  - `TData`
## Function table.filter(t, callback, callbackData)
Creates a new table from all elements for which filtering callback returns true. Can work with both
array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): any` Filtering callback.

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `table`
## Function table.every(t, callback, callbackData)
Returns true if callback returns non-false value for every element of the table. Can work with both
array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): boolean`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `boolean`
## Function table.some(t, callback, callbackData)
Returns true if callback returns non-false value for at least a single element of the table. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): boolean`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `boolean`
## Function table.count(t, callback, callbackData)
Counts number of elements for which callback returns non-false value. Can work
with both array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `nil|fun(item: T, index: TKey, callbackData: TCallbackData): boolean` If not set, all elements will be counted.

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `integer`
## Function table.sum(t, callback, callbackData)
Calls callback for each element, returns sum of returned values. Can work
with both array and non-array tables. If callback is missing, sums actual values in table.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): boolean`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `integer`
## Function table.findFirst(t, callback, callbackData)
Returns first element and its key for which callback returns a non-false value. Can work
with both array and non-array tables. If nothing is found, returns `nil`.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): boolean`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `T`
## Function table.findByProperty(t, key, value)
Returns first element and its key for which a certain property matches the value. If nothing is
found, returns `nil`.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `key`: `string`

  3. `value`: `any`

  Returns:

  - `T`
## Function table.maxEntry(t, callback, callbackData)
Returns an element and its key for which callback would return the highest numerical value. Can work
with both array and non-array tables. If callback is missing, actual table elements will be compared.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): number`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `T`
## Function table.minEntry(t, callback, callbackData)
Returns an element and its key for which callback would return the lowest numerical value. Can work
with both array and non-array tables. If callback is missing, actual table elements will be compared.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, index: TKey, callbackData: TCallbackData): number`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `T`
## Function table.forEach(t, callback, callbackData)
Runs callback for each item in a table. Can work with both array and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `fun(item: T, key: TKey, callbackData: TCallbackData)`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `table`
## Function table.distinct(t, callback, callbackData)
Creates a new table with unique elements from original table only. Optionally, a callback
can be used to provide a key which uniqueness will be checked. Can work with both array
and non-array tables.

  Parameters:

  1. `t`: `table<TKey, T>`

  2. `callback`: `nil|fun(item: T, key: TKey, callbackData: TCallbackData): any`

  3. `callbackData`: `TCallbackData?`

  Returns:

  - `table`
## Function table.findLeftOfIndex(t, testCallback, testCallbackData)
Finds first element for which `testCallback` returns true, returns index of an element before it.
Elements should be ordered in such a way that there would be no more elements returning false to the right
of an element returning true.

If `testCallback` returns true for all elements, would return 0. If `testCallback` returns false for all,
returns index of the latest element.

  Parameters:

  1. `t`: `T[]`

  2. `testCallback`: `fun(item: T, index: integer, callbackData: TCallbackData): boolean`

  3. `testCallbackData`: `nil|TCallbackData`

  Returns:

  - `integer`
## Function table.assign(target, ...)
Similar to JavaScript’s `Object.assign()`, works with tables and arrays, returns first argument (modified).

  Parameters:

  1. `target`: `T`

  2. `...`: `table`

  Returns:

  - `T`
## Function table.flatten(t, maxLevel)
Flattens table similar to JavaScript function with the same name. Requires an array.

  Parameters:

  1. `t`: `any[]`

  2. `maxLevel`: `integer?` Default value: 1.

  Returns:

  - `any`
## Function table.range(endingIndex, startingIndex, step, callback, callbackData)
Creates a new table running in steps from `startingIndex` to `endingIndex`, including `endingIndex`.
If callback returns two values, second value is used as a key.

  Parameters:

  1. `endingIndex`: `integer?`

  2. `startingIndex`: `integer`

  3. `step`: `integer?`

  4. `callback`: `fun(index: integer, callbackData: TCallbackData): T, integer|string?`

  5. `callbackData`: `TCallbackData?`

  Returns:

  - `T`
## Function table.build(iterator, k, v)
Creates a new table from iterator. Supports iterators returning one or two values (if two values are returned, first is considered the key,
if not, values are simply added to a list).

  Parameters:

  1. `iterator`: `fun(...): T`

  Returns:

  - `T`

# Module common/io.lua

## Class io.FileAttributes
Structure containing various file or directory attributes, including various flags and dates. All values are precomputed and ready to be used (there is
no overhead in accessing them once you get the structure).
## Function io.scanDir(directory, mask, callback, callbackData)
Scan directory and call callback function for each of files, passing file name (not full name, but only name of the file) and attributes. If callback function would return
a non-nil value, iteration will stop and value returned by callback would return from this function. This could be used to
find a certain file without going through all files in the directory. Optionally, a mask can be used to pre-filter received files
entries.

If callback function is not provided, it’ll return list of files instead (file names only).

System entries “.” and “..” will not be included in the list of files. Accessing attributes does not add extra cost.

  Parameters:

  1. `directory`: `string` Directory to look for files in. Note: directory is relative to current directory, not to script directory. For AC in general it’s an AC root directory, but do not rely on it, instead use `ac.getFolder(ac.FolderID.Root)`.

  2. `mask`: `string?` Mask in a form of usual “*.*”. Default value: '*'.

  3. `callback`: `fun(fileName: string, fileAttributes: io.FileAttributes, callbackData: TCallbackData): TReturn?` Callback which will be ran for every file in directory fitting mask until it would return a non-nil value.

  4. `callbackData`: `TCallbackData?` Callback data that will be passed to callback as third argument, to avoid creating a capture.

  Returns:

  - `TReturn`

# Module common/os.lua

## Class os.ConsoleProcessResult
## Function os.parseDate(date, format)
Parse date and return a unix timestamp. Uses `std::get_time()` for actual parsing:
<https://en.cppreference.com/w/cpp/io/manip/get_time>.

  Parameters:

  1. `date`: `string` String containing date.

  2. `format`: `string?` Format string. Default value: `'%Y-%m-%dT%H:%M:%S'`.

  Returns:

  - `integer`
## Function os.openFileDialog(params, callback)
Opens regular Windows file opening dialog, calls callback with either an error or a path to a file selected by user
(or nil if selection was cancelled). All parameters in `params` table are optional (the whole table too).

  Parameters:

  1. `params`: `{title: string, defaultFolder: nil|string, folder: string, fileName: string, fileTypes: nil|{` name: string, mask: string }[], addAllFilesFileType: boolean, fileTypeIndex: integer, fileNameLabel: string, okButtonLabel: string, places: string[], flags: os.DialogFlags}|nil|`{defaultFolder = ac.getFolder(ac.FolderID.Root), fileTypes = {{name = 'Images', mask = '*.png;*.jpg;*.jpeg;*.bmp'}}, addAllFilesFileType = true, flags = bit.bor(os.DialogFlags.PathMustExist, os.DialogFlags.FileMustExist)}` "Table with properties:\n- `title` (`string`): Dialog title.\n- `defaultFolder` (`nil|string`): Default folder if there is not a recently used folder value available.\n- `folder` (`string`): Selected folder (unlike `defaultFolder`, overrides recently used folder).\n- `fileName` (`string`): File name that appears in the File name edit box when that dialog box is opened.\n- `fileTypes` (`nil|{ name: string, mask: string }[]`): File types (names and masks).\n- `addAllFilesFileType` (`boolean`): If providing file types, set this to true to automatically add “All Files (*.*)” type at the bottom\n- `fileTypeIndex` (`integer`): File type selected by default (1-based).\n- `fileNameLabel` (`string`): Text of the label next to the file name edit box.\n- `okButtonLabel` (`string`): Text of the Open button.\n- `places` (`string[]`): Additional places to show in the list of locations on the left.\n- `flags` (`os.DialogFlags`): Dialog flags (use `bit.bor()` to combine flags together to avoid errors with adding same flag twice)"

  2. `callback`: `fun(err: string, filename: string)`
## Function os.saveFileDialog(params, callback)
Opens regular Windows file saving dialog, calls callback with either an error or a path to a file selected by user
(or nil if selection was cancelled). All parameters in `params` table are optional (the whole table too).

  Parameters:

  1. `params`: `{title: string, defaultFolder: nil|string, defaultExtension: string, folder: string, fileName: string, saveAsItem: string, fileTypes: nil|{` name: string, mask: string }[], addAllFilesFileType: boolean, fileTypeIndex: integer, fileNameLabel: string, okButtonLabel: string, places: string[], flags: os.DialogFlags}|nil|`{defaultFolder = ac.getFolder(ac.FolderID.Root), fileTypes = {{name = 'Images', mask = '*.png;*.jpg;*.jpeg;*.bmp'}}, addAllFilesFileType = true, flags = bit.bor(os.DialogFlags.PathMustExist, os.DialogFlags.OverwritePrompt, os.DialogFlags.NoReadonlyReturn)}` "Table with properties:\n- `title` (`string`): Dialog title.\n- `defaultFolder` (`nil|string`): Default folder if there is not a recently used folder value available.\n- `defaultExtension` (`string`): Sets the default extension to be added to file names, with a dot in front.\n- `folder` (`string`): Selected folder (unlike `defaultFolder`, overrides recently used folder).\n- `fileName` (`string`): File name that appears in the File name edit box when that dialog box is opened.\n- `saveAsItem` (`string`): Ann item to be used as the initial entry in a Save As dialog.\n- `fileTypes` (`nil|{ name: string, mask: string }[]`): File types (names and masks).\n- `addAllFilesFileType` (`boolean`): If providing file types, set this to true to automatically add “All Files (*.*)” type at the bottom\n- `fileTypeIndex` (`integer`): File type selected by default (1-based).\n- `fileNameLabel` (`string`): Text of the label next to the file name edit box.\n- `okButtonLabel` (`string`): Text of the Save button.\n- `places` (`string[]`): Additional places to show in the list of locations on the left.\n- `flags` (`os.DialogFlags`): Dialog flags (use `bit.bor()` to combine flags together to avoid errors with adding same flag twice)"

  2. `callback`: `fun(err: string, filename: string)`
## Function os.runConsoleProcess(params, callback)
Run a console process in background with given arguments, return exit code and output in callback. Launched process will be tied
to AC process to shut down with AC (works only on Windows 8 and newer).

  Parameters:

  1. `params`: `{filename: string, arguments: string[], rawArguments: boolean, workingDirectory: string, timeout: integer, environment: table, inheritEnvironment: boolean, stdin: string, separateStderr: boolean, terminateWithScript: boolean, dataCallback: fun(err: boolean, data: string)}|`{` filename = '', arguments = {} }` "Table with properties:\n- `filename` (`string`): Application filename.\n- `arguments` (`string[]`): Arguments (quotes will be added automatically unless `rawArguments` is set to true).\n- `rawArguments` (`boolean`): Set to `true` to disable any arguments processing and pass them as they are, simply joining them with a space symbol.\n- `workingDirectory` (`string`): Working directory.\n- `timeout` (`integer`): Timeout in milliseconds. If above zero, process will be killed after given time has passed.\n- `environment` (`table`): If set to a table, values from that table will be used as environment variables instead of inheriting ones from AC process.\n- `inheritEnvironment` (`boolean`): Set to `true` to inherit AC environment variables before adding custom ones.\n- `stdin` (`string`): Optional data to pass to a process in stdin pipe.\n- `separateStderr` (`boolean`): Store stderr data in a separate string.\n- `terminateWithScript` (`boolean`): Terminate process if this Lua script were to terminate (for example, during reload).\n- `dataCallback` (`fun(err: boolean, data: string)`): If set to a function, data written in stdout and stderr will be passed to the function instead as it arrives."

  2. `callback`: `nil|fun(err: string, data: os.ConsoleProcessResult)`

# Module common/timer.lua

## Function setTimeout(callback, delay, uniqueKey)
Runs callback after certain time. Returns cancellation ID.
Note: all callbacks will be ran before `update()` call,
and they would only ran when script runs. So if your script is executed each frame and AC runs at 60 FPS, smallest interval
would be 0.016 s, and anything lower that you’d set would still act like 0.016 s. Also, intervals would only be called once
per frame.

  Parameters:

  1. `callback`: `fun()`

  2. `delay`: `number?` Delay time in seconds. Default value: 0.

  3. `uniqueKey`: `any?` Unique key: if set, timer wouldn’t be added unless there is no more active timers with such ID.

  Returns:

  - `integer`
## Function setInterval(callback, period, uniqueKey)
Repeteadly runs callback after certain time. Returns cancellation ID.
Note: all callbacks will be ran before `update()` call,
and they would only ran when script runs. So if your script is executed each frame and AC runs at 60 FPS, smallest interval
would be 0.016 s, and anything lower that you’d set would still act like 0.016 s. Also, intervals would only be called once
per frame.

  Parameters:

  1. `callback`: `fun(): function?` Return `clearInterval` (actual function) to clear interval.

  2. `period`: `number?` Period time in seconds. Default value: 0.

  3. `uniqueKey`: `any?` Unique key: if set, timer wouldn’t be added unless there is no more active timers with such ID.

  Returns:

  - `integer`
## Function clearTimeout(cancellationID)
Stops timeout.

  Parameters:

  1. `cancellationID`: `integer` Value earlier retuned by `setTimeout()`. If a non-numerical value is passed (like a `nil`), call is ignored and returns `false`.

  Returns:

  - `boolean` True if timeout with such ID has been found and stopped.
## Function clearInterval(cancellationID)
Stops interval.

  Parameters:

  1. `cancellationID`: `integer` Value earlier retuned by `setInterval()`.

  Returns:

  - `boolean` True if interval with such ID has been found and stopped.

# Module common/ac_extras_ini.lua

## Function ac.INIConfig(format, sections)
A wrapper for data parsed from an INI files, supports different INI formats. Parsing is done on
CSP side, rest is on CSP side. Use `:get()` and `:set()` methods to operate values.

  Parameters:

  1. `format`: `ac.INIFormat`

  2. `sections`: `table`

  Returns:

  - `ac.INIConfig`
## Class ac.INIConfig
A wrapper for data parsed from an INI files, supports different INI formats. Parsing is done on
CSP side, rest is on CSP side. Use `:get()` and `:set()` methods to operate values.

- `ac.INIConfig:get(section, key, defaultValue, offset)`

  Get value from parsed INI file. Note: getting vector values creates them anew, so if you’re going to use a value often, consider
caching it locally.

  Parameters:

    1. `section`: `string` Section name.

    2. `key`: `string` Value key.

    3. `defaultValue`: `T` Defines type of value to return, is returned if value is missing. If not set, list of strings is returned.

    4. `offset`: `integer?` Optional 1-based offset for data parsed in CSP format (in case value contains several items). Default value: 1.

  Returns:

    - `T`

- `ac.INIConfig:tryGetLut(section, key)`

  Attempts to load a 1D-to-1D LUT from an INI file, supports both inline “(|X=Y|…|)” LUTs and separate files next to configs (only
for configs loaded by filename or from car data)

  Returns:

    - `ac.DataLUT11`

- `ac.INIConfig:tryGet2DLut(section, key)`

  Attempts to load a 2D-to-1D LUT from an INI file, supports both inline “(|X,Y=Z|…|)” LUTs and separate files next to configs (only
for configs loaded by filename or from car data)

  Returns:

    - `ac.DataLUT21`

- `ac.INIConfig:iterate(prefix, noPostfixForFirst)`

  Iterates over sections of INI file with a certain prefix. Order matches order of CSP parsing such data.

Example:
```lua
for index, section in iniConfig:iterate('LIGHT') do
  print('Color: '..iniConfig:get(section, 'COLOR', 'red'))
end
```

  Parameters:

    1. `prefix`: `string` Prefix for section names.

    2. `noPostfixForFirst`: `boolean?` Only for default INI format. If set to `true`, first section would not have “_0” postfix.

  Returns:

    - `fun`

- `ac.INIConfig:iterateValues(section, prefix, digitsOnly)`

  Iterates over values of INI section with a certain prefix. Order matches order of CSP parsing such data.

Example:
```lua
for index, key in iniConfig:iterateValues('LIGHT_0', 'POSITION', true) do
  print('Position: '..tostring(iniConfig:get('LIGHT_0', key, vec3())))
end
```

  Parameters:

    1. `prefix`: `string` Prefix for section names.

    2. `digitsOnly`: `boolean?` If set to `true`, would only collect keys consisting of a prefix and a number (useful for configs with extra properties).

  Returns:

    - `fun`

- `ac.INIConfig:mapSection(section, defaults)`

  Takes table with default values and returns a table with values filled from config.

  Parameters:

    1. `section`: `string` Section name.

    2. `defaults`: `T` Table with keys and default values. Keys are the same as INI keys.

  Returns:

    - `T`

- `ac.INIConfig:mapConfig(defaults)`

  Takes table with default values and returns a table with values filled from config.

  Parameters:

    1. `defaults`: `T` Table with section names and sub-tables with keys and default values. Keys are the same as INI keys.

  Returns:

    - `T`

- `ac.INIConfig:set(section, key, value)`

  Set an INI value. Pass `nil` as value to remove it.

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `value`: `string|string[]|number|boolean|nil|vec2|vec3|vec4|rgb|rgbm`

  Returns:

    - `ac.INIConfig` Returns itself for chaining several methods together.

- `ac.INIConfig:setAndSave(section, key, value)`

  Set an INI value and save file immediately using special old Windows function to edit a single INI value. Compatible only with default
INI format. Doesn’t provide major peformance improvements, but might be useful if you prefer to keep original formatting as much as possible
when editing a single value only.

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `value`: `string|string[]|number|boolean|nil|vec2|vec3|vec4|rgb|rgbm`

  Returns:

    - `boolean` Returns `true` if new value is different and config was saved.

- `ac.INIConfig:serialize()`

  Serializes data in INI format using format specified on INIConfig creation. You can also use `tostring()` function.

  Returns:

    - `string`

- `ac.INIConfig:save(filename)`

  Saves contents to a file in INI form.

  Parameters:

    1. `filename`: `string?` Filename. If filename is not set, saves file with the same name as it was loaded. Updates `filename` field.

  Returns:

    - `ac.INIConfig` Returns itself for chaining several methods together.
## Function ac.INIConfig.parse(data, format, includeFolders)
Parse INI config from a string.

  Parameters:

  1. `data`: `string` Serialized INI data.

  2. `format`: `ac.INIFormat?` Format to parse. Default value: `ac.INIFormat.Default`.

  3. `includeFolders`: `('@cars'|'@tracks'|string)[]?` Optional folders to include files from (only for `ac.INIFormat.ExtendedIncludes` format). Use special values `'@cars'` and `'@tracks'` for car or track configs.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.load(filename, format, includeFolders)
Load INI file, optionally with includes.

  Parameters:

  1. `filename`: `string` INI config filename.

  2. `format`: `ac.INIFormat?` Format to parse. Default value: `ac.INIFormat.Default`.

  3. `includeFolders`: `('@cars'|'@tracks'|string)[]?` Optional folders to include files from (only for `ac.INIFormat.ExtendedIncludes` format). If not set, parent folder for config filename is used. Use special values `'@cars'` and `'@tracks'` for car or track configs.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.carData(carIndex, fileName)
Load car data INI file. Supports “data.acd” files as well. Returned files might be tweaked by
things like custom physics virtual tyres. To get original file, use `ac.INIConfig.load()`.

Returned file can’t be saved.

  Parameters:

  1. `carIndex`: `number` 0-based car index.

  2. `fileName`: `string` Car data file name, such as `'tyres.ini'`.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.trackData(fileName)
Load track data INI file. Can be used by track scripts which might not always  have access to those files directly.

Returned file can’t be saved.

  Parameters:

  1. `fileName`: `string` Car data file name, such as `'tyres.ini'`.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.carConfig(carIndex)
Returns CSP config for a car. Might be slow: some of those configs are huge. Make sure to cache the resulting value if you need to reuse it.

Returned file can’t be saved.

  Parameters:

  1. `carIndex`: `number` 0-based car index.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.trackConfig()
Returns CSP config for a track. Might be slow: some of those configs are huge. Make sure to cache the resulting value if you need to reuse it.

Returned file can’t be saved.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.onlineExtras()
Returns config with extra online options, the ones that can be set with Content Manager.

Returned file can’t be saved.

  Returns:

  - `ac.INIConfig|nil` If not an online session, returns `nil`.
## Function ac.INIConfig.raceConfig()
Returns race config (`cfg/race.ini`). Password and online GUID won’t be included.

Returned file can’t be saved.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.videoConfig()
Returns video config (`cfg/video.ini`).

Returned file can’t be saved.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.controlsConfig()
Returns controls config (`cfg/controls.ini`).

Returned file can’t be saved.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.currentSetup()
Returns current setup INI file (either previously loaded or saved). Any changes in actual setup in pits won’t be reflected in the returned
data unless file was saved.

Returned file can be saved. Use `ac.onSetupFile()` to listen to data changes and either read extra data from setup file, or change the contents after file has been saved.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.cspModule(cspModuleID)
Load config of a CSP module by its name.

  Parameters:

  1. `cspModuleID`: `ac.CSPModuleID` Name of a CSP module.

  Returns:

  - `ac.INIConfig`
## Function ac.INIConfig.scriptSettings()
Load config of the current Lua script (“settings.ini” in script directory and settings overriden by user, meant to be customizable with Content Manager).

  Returns:

  - `ac.INIConfig`

# Module common/ac_extras_datalut.lua

## Function ac.DataLUT11()
Creates a new empty 1D-to-1D LUT. Use `ac.DataLUT11:add(input, output)` to fill it with data.

  Returns:

  - `ac.DataLUT11`
## Function ac.DataLUT11.parse(data)
Parse 1D-to-1D LUT from a string in “(|Input1=Output1|Input2=Output2|…|)” format.

  Parameters:

  1. `data`: `string` Serialized LUT data.

  Returns:

  - `ac.DataLUT11`
## Function ac.DataLUT11.load(filename)
Load 1D-to-1D LUT file.

  Parameters:

  1. `filename`: `string` LUT filename.

  Returns:

  - `ac.DataLUT11`
## Function ac.DataLUT11.carData(carIndex, fileName)
Load car data 1D-to-1D LUT file. Supports “data.acd” files as well.

  Parameters:

  1. `carIndex`: `number` 0-based car index.

  2. `fileName`: `string` Car data file name, such as `'power.lut'`.

  Returns:

  - `ac.DataLUT11`
## Function ac.DataLUT21()
Creates a new empty 2D-to-1D LUT. Use `ac.DataLUT21:add(input, output)` to fill it with data.

  Returns:

  - `ac.DataLUT21`
## Function ac.DataLUT21.parse(data)
Parse 2D-to-1D LUT from a string in “(|X1,Y1=Output1|X2,Y2=Output2|…|)” format.

  Parameters:

  1. `data`: `string` Serialized LUT data.

  Returns:

  - `ac.DataLUT21`
## Function ac.DataLUT21.load(filename)
Load 2D-to-1D LUT file.

  Parameters:

  1. `filename`: `string` LUT filename.

  Returns:

  - `ac.DataLUT21`
## Function ac.DataLUT21.carData(carIndex, fileName)
Load car data 2D-to-1D LUT file. Supports “data.acd” files as well.

  Parameters:

  1. `carIndex`: `number` 0-based car index.

  2. `fileName`: `string` Car data file name, such as `'speed_throttle.2dlut'`.

  Returns:

  - `ac.DataLUT21`
## Class ac.DataLUT11
Simple 1D-to-1D lookup table wrapper, helps to deal with all those “.lut“ files in car data.

- `ac.DataLUT11:add(input, output)`

  Add a new value to LUT.

  Parameters:

    1. `input`: `number`

    2. `output`: `number`

  Returns:

    - `ac.DataLUT11` Returns self for easy chaining.

- `ac.DataLUT11:bounds()`

  Returns data boundaries.

  Returns:

    1. `vec2` Minimum input and output.

    2. `vec2` Maximum input and output.

- `ac.DataLUT11:get(input)`

  Computes a LUT value using either linear or cubic interpolation (set field `ac.DataLUT11.useCubicInterpolation` to
`true` to use cubic interpolation).

  Parameters:

    1. `input`: `number`

  Returns:

    - `number`

- `ac.DataLUT11:getPointInput(index)`

  Returns input value of a certain point of a LUT, or `math.nan` if there is no such point.

  Parameters:

    1. `index`: `number` 0-based index.

  Returns:

    - `number`

- `ac.DataLUT11:getPointOutput(index)`

  Returns output value of a certain point of a LUT, or `math.nan` if there is no such point.

  Parameters:

    1. `index`: `number` 0-based index.

  Returns:

    - `number`

- `ac.DataLUT11:serialize(longFormat)`

  Convert LUT into a string, either in a short (inlined, for an INI config) or long (for a separate file) format.

  Parameters:

    1. `longFormat`: `boolean?` Set to `true` to use long format. Default value: `false`.

  Returns:

    - `string`
## Class ac.DataLUT21
Simple 2D-to-1D lookup table wrapper, helps to deal with all those “.2dlut“ files in car data. Tables can miss some values,
such areas will be further interpolated.

- `ac.DataLUT21:bounds()`

  Returns data boundaries.

  Returns:

    1. `vec3` Minimum input (X, Y) and output (Z).

    2. `vec3` Maximum input (X, Y) and output (Z).

- `ac.DataLUT21:add(input, output)`

  Add a new value to a 2D LUT.

  Parameters:

    1. `input`: `vec2`

    2. `output`: `number`

  Returns:

    - `ac.DataLUT21` Returns self for easy chaining.

- `ac.DataLUT21:get(input)`

  Computes a LUT value using either bilinear or bicubic interpolation (set field `ac.DataLUT21.useBicubicInterpolation` to
`true` to use bicubic interpolation).

  Parameters:

    1. `input`: `vec2`

  Returns:

    - `number`

- `ac.DataLUT21:serialize()`

  Convert LUT into a string in a short (inlined, for an INI config) format.

  Returns:

    - `string`

# Module common/ac_extras_connect.lua

## Function ac.connect(layout, keepLive, namespace)
Creates a new shared structure to quickly exchange data between different Lua scripts within a session. Example:
```lua
local sharedData = ac.connect{
  ac.StructItem.key('myChannel'),        -- optional, to avoid collisions
  someString = ac.StructItem.string(24), -- 24 is for capacity
  someInt = ac.StructItem.int(),
  someDouble = ac.StructItem.double(),
  someVec = ac.StructItem.vec3()
}
```

Note: to connect two scripts, both of them chould use `ac.connect()` and pass exactly the same layouts. Also, consider using more
specific names to avoid possible unwanted collisions. For example, instead of using `value = ac.StructItem.int()` which might be
used somewhere else, use `weatherBrightnessValue = ac.StructItem.int()`. Or, simply add `ac.StructItem.key('myUniqueKey')`.

For safety reasons, car scripts can only connect to other car scripts, and track scripts can only connect to other track scripts.

  Parameters:

  1. `layout`: `T` A table containing fields of structure and their types. Use `ac.StructItem` methods to select types. Alternatively, you can pass a string for the body of the structure here, but be careful with it.

  2. `keepLive`: `boolean?` Set to true to keep structure even if any references were removed or script was unloaded.

  3. `namespace`: `nil|ac.SharedNamespace` Optional namespace stopping scripts of certain types to access data of scripts with different types. For more details check `ac.SharedNamespace` documentation.

  Returns:

  - `T`
## Function ac.StructItem.combine(layout, compact)
Create a new struct from a given layout. Could be used in calls like `ac.structBytes()` and `ac.fillStructWithBytes()`. Each call defines and creates a new struct, so don’t
call them each frame, I believe LuaJIT doesn’t do garbage collection on struct definitions.

  Parameters:

  1. `layout`: `T`

  2. `compact`: `boolean?`

  Returns:

  1. `T`

  2. `integer` Structure size.

  3. `string` Structure name.

# Module common/ac_struct_item.lua

## Function ac.StructItem.key(key)
Adds a key to a structure to ensure its uniqueness. Consider using something like “yourUsername.yourContentID” or something
like that for a key, so that your data would not interfere with data from Lua scripts written by other developers. Note:
if you’re exchanging data between physics and graphics thread in your car, you might have to append `car.index` to there as
well so that different cars would have either own data things.

  Returns:

  - `nil`
## Function ac.StructItem.explicit(alignment, packing)
Enables explicit ordering for your structures.
By default, CSP will reorder fields in your structures for optimal data packing. Because all scripts written in Lua share the same algorithm,
it’s all fine and good, but if you want for your script to exchange data with other programs, explicit order would work much better.

  Parameters:

  1. `alignment`: `integer?` Optional override for alignment of child structures.

  2. `packing`: `integer?` Optional overrider for packing of fields.

  Returns:

  - `nil`
## Function ac.StructItem.half()

  Returns:

  - `number`
## Function ac.StructItem.float()

  Returns:

  - `number`
## Function ac.StructItem.double()

  Returns:

  - `number`
## Function ac.StructItem.norm8()

  Returns:

  - `number`
## Function ac.StructItem.unorm8()

  Returns:

  - `number`
## Function ac.StructItem.norm16()

  Returns:

  - `number`
## Function ac.StructItem.unorm16()

  Returns:

  - `number`
## Function ac.StructItem.int16()

  Returns:

  - `integer`
## Function ac.StructItem.uint16()

  Returns:

  - `integer`
## Function ac.StructItem.int32()

  Returns:

  - `integer`
## Function ac.StructItem.uint32()

  Returns:

  - `integer`
## Function ac.StructItem.int64()

  Returns:

  - `integer`
## Function ac.StructItem.uint64()

  Returns:

  - `integer`
## Function ac.StructItem.boolean()

  Returns:

  - `boolean`
## Function ac.StructItem.char()
Same as `ac.StructItem.int8()`.

  Returns:

  - `integer`
## Function ac.StructItem.byte()
Same as `ac.StructItem.uint8()`.

  Returns:

  - `integer`
## Function ac.StructItem.int8()

  Returns:

  - `integer`
## Function ac.StructItem.uint8()

  Returns:

  - `integer`
## Function ac.StructItem.vec2()

  Returns:

  - `vec2`
## Function ac.StructItem.vec3()

  Returns:

  - `vec3`
## Function ac.StructItem.vec4()

  Returns:

  - `vec4`
## Function ac.StructItem.rgb()

  Returns:

  - `rgb`
## Function ac.StructItem.rgbm()

  Returns:

  - `rgbm`
## Function ac.StructItem.hsv()

  Returns:

  - `hsv`
## Function ac.StructItem.quat()

  Returns:

  - `quat`
## Function ac.StructItem.array(elementType, size)

  Parameters:

  1. `elementType`: `T`

  2. `size`: `integer`

  Returns:

  - `T`
## Function ac.StructItem.struct(fields)

  Parameters:

  1. `fields`: `T`

  Returns:

  - `T`
## Function ac.StructItem.string(capacity)

  Parameters:

  1. `capacity`: `integer?` Maximum string capacity. Default value: 32.

  Returns:

  - `string`
## Function ac.StructItem.mat3x3()

  Returns:

  - `mat3x3`
## Function ac.StructItem.mat4x4()

  Returns:

  - `mat4x4`
## Function ac.StructItem.transform(compactPosition, compactRotation, rangeFrom, rangeTo)
Matrix packed to 6, 9 or 12 bytes (depending on settings).

Note: to update value you need to use assignment operator (`.field = newValue`), altering matrix of this property with methods like
`:mulSelf()` only changes unpacked value on your side, but not the actual structure value.

  Parameters:

  1. `compactPosition`: `boolean?` If `true`, position is packed into 3 bytes, otherwise it will take 6 bytes. Default value: `false`.

  2. `compactRotation`: `boolean?` If `true`, rotation is packed into 3 bytes, otherwise it will take 6 bytes. Default value: `false`.

  3. `rangeFrom`: `number|vec3?` Minimal expected position. Pass it together with `rangeTo` to encode position data more efficiently.

  4. `rangeTo`: `number|vec3?` Maximum expected position. Pass it together with `rangeFrom` to encode position data more efficiently.

  Returns:

  - `mat4x4`

# Module common/ac_extras_hashspace.lua

## Function ac.HashSpace(cellSize)

  Parameters:

  1. `cellSize`: `number` Should be about twice as large as your largest entity.

  Returns:

  - `ac.HashSpace`

# Module common/ac_extras_numlut.lua

## Function ac.Lut(data, hsvColumns)

  Parameters:

  1. `data`: `string` String with LUT data, in a format similar to AC LUT formats. Please note: rows must be ordered for efficient binary search.

  2. `hsvColumns`: `integer[]` 1-based indices of columns storing HSV data. Such columns, of course, will be interpolated differently (for example, mixing hues 350 and 20 would produce 10).

  Returns:

  - `ac.Lut`
## Function ac.LutJit:new(o, data, hsvRows)
Creates new ac.LuaJit instance. Deprecated and broken, use `ac.Lut` instead.

  Parameters:

  1. `data`: `any`

  2. `hsvRows`: `integer[]`  1-based indices of columns (not rows) storing HSV values in them.

  Returns:

  - `table`

# Module common/ac_extras_connectmmf.lua

## Function ac.readMemoryMappedFile(filename, layout, persist)
Opens shared memory file for reading. Do not attempt to modify any of its contents: doing so pretty much always would result in Assetto Corsa
just straight up crashing.

  Parameters:

  1. `filename`: `string` Shared memory file filename (without “Local\” bit).

  2. `layout`: `T` String for the body of the structure.

  3. `persist`: `boolean?` Keep file alive even after the script stopped or the variable was cleared by garbage collector. Default value: `false`.

  Returns:

  - `T`
## Function ac.writeMemoryMappedFile(filename, layout, persist)
Opens shared memory file for writing. Note: if the file would exist at the moment of opening (for example, created before by a different
Lua script, or by a separate process), it would retain its current state, but if it’s a new file, it’ll be initialized with all zeroes.

  Parameters:

  1. `filename`: `string` Shared memory file filename (without “Local\” bit).

  2. `layout`: `T` String for the body of the structure.

  3. `persist`: `boolean?` Keep file alive even after the script stopped or the variable was cleared by garbage collector. Default value: `false`.

  Returns:

  - `T`
## Function ac.disposeMemoryMappedFile(reference)
Forcefully closes memory mapped file opened either for reading or writing without waiting for GC to pick it up.
function ac.disposeMemoryMappedFile(reference) end

# Module common/ac_general_utils.lua

## Function ac.evaluateLapTime()
Estimates lap time and sector times for main car using AC function originally used by Time Attack mode. Could be
helpful in creating custom time attack modes. Uses “ideal_line.ai” from “track folder/data”, so might not work
well with mods. If that file is missing, returns nil.

# Module common/ac_storage.lua

## Class ac.StoredValue

- `ac.StoredValue:get()`

  Returns:

    - `string|number|boolean|vec2|vec3|vec4|rgb|rgbm`

- `ac.StoredValue:set(value)`

  Parameters:

    1. `value`: `string|number|boolean|vec2|vec3|vec4|rgb|rgbm`
## Function ac.storage(layout, keyPrefix)
Storage function. Easiest way to use is to pass it a table with default values — it would give you a table back
which would load values on reads and save values on writes. Values have to be either strings, numbers, booleans,
vectors or colors. Example:
```lua
local storedValues = ac.storage{
  someKey = 15,
  someStringValue = 20
}
storedValues.someKey = 20
```
Alternatively, you can use it as a function which would take a key and a default value and return you an
`ac.StoredValue` wrapper with methods `:get()` and `:set(newValue)`:
```lua
local stored = ac.storage('someKey', 15)
stored:get()
stored:set(20)
```
Or, just access it directly in `localStorage` style of JavaScript. Similar to JavaScript, this way you can only store
strings:
```lua
ac.storage.key = 'value'
ac.debug('loaded', ac.storage.key)
```
Data will be saved in “Documents\Assetto Corsa\cfg\extension\state\lua”, in corresponding subfolder. Actual writing
will happen a few seconds after new value was pushed, and only if value was changed, so feel free to use this function
to write things often.

  Parameters:

  1. `layout`: `T`

  2. `keyPrefix`: `string|nil` Optional parameter for adding a prefix to keys.

  Returns:

  - `T`
## Function ac.storageHasKey(storage, key)
Checks if storage table created by `ac.storage(table)` has a certain key or not.

  Parameters:

  1. `storage`: `any`

  2. `key`: `string`

  Returns:

  - `boolean`
## Function ac.storageChanged()
Returns `true` if any storage value has changed since the previous call.

  Returns:

  - `boolean`

# Module common/ac_configs.lua

## Class ac.ConfigProvider

- `ac.ConfigProvider.bool(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `boolean|nil`

  Returns:

    - `boolean`

- `ac.ConfigProvider.number(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `number`

  Returns:

    - `number`

- `ac.ConfigProvider.string(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `string|nil`

  Returns:

    - `string`

- `ac.ConfigProvider.rgb(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `rgb|nil`

  Returns:

    - `rgb`

- `ac.ConfigProvider.rgbm(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `rgbm|nil`

  Returns:

    - `rgbm`

- `ac.ConfigProvider.vec2(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `vec2|nil`

  Returns:

    - `vec2`

- `ac.ConfigProvider.vec3(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `vec3|nil`

  Returns:

    - `vec3`

- `ac.ConfigProvider.vec4(section, key, defaultValue)`

  Parameters:

    1. `section`: `string`

    2. `key`: `string`

    3. `defaultValue`: `vec4|nil`

  Returns:

    - `vec4`
## Function ac.getTrackConfig(section, key, defaultValue)
Reads a value from the config of currently loaded track. To use it, you need to specify `defaultValue` value, it would be used to determine
the type of the value you need (and would be returned if value in config is missing).

Alternatively, if called without arguments, returns ac.ConfigProvider which then can be used to access
values in a typed manner. For it, `defaultValue` is optional.

  Parameters:

  1. `section`: `string` Section name in config (the one in square brackets).

  2. `key`: `string` Config key (value before “=” sign).

  3. `defaultValue`: `T` Value that’s returned as a result if value is missing. Also determines the type needed.

  Returns:

  - `T`
## Function ac.getCarConfig(carIndex, section, key, defaultValue)
Reads a value from the config of a car. To use it, you need to specify `defaultValue` value, it would be used to determine
the type of the value you need (and would be returned if value in config is missing).

Alternatively, if called with car index only, returns ac.ConfigProvider which then can be used to access
values in a typed manner. For it, `defaultValue` is optional.

  Parameters:

  1. `carIndex`: `integer` 0-based car index.

  2. `section`: `string` Section name in config (the one in square brackets).

  3. `key`: `string` Config key (value before “=” sign).

  4. `defaultValue`: `T` Value that’s returned as a result if value is missing. Also determines the type needed.

  Returns:

  - `T`

# Module common/ac_reftypes.lua

## Function refbool(value)
Stores a boolean value and can be used as a reference to it.

  Parameters:

  1. `value`: `boolean` Stored value.

  Returns:

  - `refbool`
## Class refbool
Stores a boolean value and can be used as a reference to it.

- `refbool.isrefbool(x)`

  Returns:

    - `boolean`

- `refbool:set(newValue)`

  For easier use with UI controls.

  Parameters:

    1. `newValue`: `boolean|`true`|`false``

  Returns:

    - `refbool`
## Function refnumber(value)
Stores a numerical value and can be used as a reference to it.

  Parameters:

  1. `value`: `number` Stored value.

  Returns:

  - `refnumber`
## Class refnumber
Stores a numerical value and can be used as a reference to it.

- `refnumber.isrefnumber(x)`

  Returns:

    - `boolean`

- `refnumber:set(newValue)`

  For easier use with UI controls.

  Parameters:

    1. `newValue`: `number`

  Returns:

    - `refnumber`

# Module common/ac_web.lua

## Class WebResponse
## Function web.timeouts(resolve, connect, send, receive)
Configures timeouts in milliseconds for the following web requests. If you’re sure in your server, consider lowering timeouts so that
in a case of a missing internet connection it wouldn’t take forever to determine the issue. Parameters will be passed to `WinHttpSetTimeouts()`
function (https://learn.microsoft.com/en-us/windows/win32/api/winhttp/nf-winhttp-winhttpsettimeouts).

  Parameters:

  1. `resolve`: `integer?` Time in milliseconds for DNS resolve, 0 to disable timeout. Default value: 4000 ms.

  2. `connect`: `integer?` Time in milliseconds for establishing connection. Default value: 10000 ms.

  3. `send`: `integer?` Time in milliseconds for sending data. Default value: 30000 ms.

  4. `receive`: `integer?` Time in milliseconds for receiving data. Default value: 30000 ms.
## Function web.get(url, headers, callback)
Sends a GET HTTP or HTTPS request. Note: you can only have two requests running at once, mostly to make sure
a faulty script wouldn’t spam a remote server or overload internet connection (that’s how I lost access
to one of my API tokens for some time, accidentally sending a request each frame).

  Parameters:

  1. `url`: `string` URL.

  2. `headers`: `table<string, string|number|boolean>?` Optional headers. Use special `[':headers-only'] = true` header if you only need to load headers (for servers without proper support of HEAD method).

  3. `callback`: `fun(err: string, response: WebResponse)`
## Function web.post(url, headers, data, callback)
Sends a POST HTTP or HTTPS request. Note: you can only have two requests running at once, mostly to make sure
a faulty script wouldn’t spam a remote server or overload internet connection (that’s how I lost access
to one of my API tokens for some time, accidentally sending a request each frame).

  Parameters:

  1. `url`: `string` URL.

  2. `headers`: `table<string, string|number|boolean>?` Optional headers. Use special `[':headers-only'] = true` header if you only need to load headers (for servers without proper support of HEAD method).

  3. `data`: `WebPayload?` Optional data.

  4. `callback`: `fun(err: string, response: WebResponse)`
## Function web.request(method, url, headers, data, callback)
Sends a custom HTTP or HTTPS request. Note: you can only have two requests running at once, mostly to make sure
a faulty script wouldn’t spam a remote server or overload internet connection (that’s how I lost access
to one of my API tokens for some time, accidentally sending a request each frame).

  Parameters:

  1. `method`: `"'GET'"|"'POST'"|"'PUT'"|"'HEAD'"|"'DELETE'"|"'PATCH'"|"'OPTIONS'"` HTTP method.

  2. `url`: `string` URL.

  3. `headers`: `table<string, string|number|boolean>?` Optional headers. Use special `[':headers-only'] = true` header if you only need to load headers (for servers without proper support of HEAD method).

  4. `data`: `WebPayload?` Optional data.

  5. `callback`: `fun(err: string, response: WebResponse)`
## Function web.socket(url, headers, callback, params)
Open a WebSocket connection.

  Parameters:

  1. `url`: `string` URL.

  2. `headers`: `table<string, string|number|boolean>?` Optional headers.

  3. `callback`: `nil|fun(data: binary)`

  4. `params`: `web.SocketParams?`

  Returns:

  - `web.Socket`

# Module common/stringify.lua

## Function stringify(obj, compact, depthLimit)
Serialize Lua value (table, number, string, etc.) in a Lua table format (similar to how `JSON.stringify` in JavaScript
generates a thing with JavaScript syntax). Format seems to be called Luaon. Most of Lua entities are supported, including array-like tables, table
tables and mixed ones. CSP API things, such as vectors or colors, are also supported. For things like threads,
functions or unknown cdata types instead a placeholder object will be created.

Circular references also result in creating similar objects, for example: `t = {1, 2, 3, t}` would result in
`{ 1, 2, 3, { type = 'circular reference' } }`.

If any table in given data would have a `__stringify()` function, it would be called as a method (so first argument
would be the table with `__stringify` itself). If that function would return a string, that string will be used
instead of regular table serialization. The idea is for classes to define a method like this and output a line of code
which could be used to create a new instance like this on deserialization. Note: for such like to use a custom function
like a class constructor, you would either need to register that function with a certain name or provide a table referring
to it on deserialization. That’s because although deserialization uses `load()` function to parse and run data as Lua code,
it wouldn’t allow code to access existing functions by default.

  Parameters:

  1. `obj`: `table|number|string|boolean|nil` Object to serialize.

  2. `compact`: `boolean?` If true, resulting string would not have spaces and line breaks, slightly faster and a lot more compact.

  3. `depthLimit`: `integer?` Limits how deep serialization would go. Default value: 20.

  Returns:

  - `string` String with input data presented in Lua syntax.
## Function stringify.parse(serialized, namespace)
Parse a string with Lua table syntax into a Lua object (table, number, string, vector, etc.), can support custom objects as well.
Only functions from `namespace` can be used (as well as vectors and functions registered earlier with `stringify.register()`),
so if you’re using custom classes, make sure to either register them earlier or pass them in `namespace` table. Alternatively,
you can just pass `_G` as `namespace`, but it might be pretty unsecure, so maybe don’t do it.

Would raise an error if failed to parse or if any of initializers would raise an error.

  Parameters:

  1. `serialized`: `string` Serialized data.

  2. `namespace`: `table|nil` Namespace table. Serialized data would be evaluated as Lua code and would have access to it.

  Returns:

  - `table|number|string|boolean|nil`
## Function stringify.tryParse(serialized, namespace, fallback)
Parse a string with Lua table syntax into a Lua object (table, number, string, vector, etc.), can support custom objects as well.
Only functions from `namespace` can be used (as well as vectors and functions registered earlier with `stringify.register()`),
so if you’re using custom classes, make sure to either register them earlier or pass them in `namespace` table. Alternatively,
you can just pass `_G` as `namespace`, but it might be pretty unsecure, so maybe don’t do it.

Returns fallback value if failed to parse, or if `serialized` is empty or not set, or if any of initializers would raise an error.

  Parameters:

  1. `serialized`: `string?` Serialized data.

  2. `namespace`: `table|nil` Namespace table. Serialized data would be evaluated as Lua code and would have access to it.

  3. `fallback`: `T|nil` Value to return if parsing failed.

  Returns:

  - `T`
## Function stringify.register(name, fn)
Registers a new initializer function with a given name.

  Parameters:

  1. `name`: `string` Name of an initializer (how serialized data would refer to it).

  2. `fn`: `function` Initializer function (returning value for serialized data to use).
## Function stringify.substep(out, ptr, obj, lineBreak, depthLimit)
Serialization substep. Works similar to `stringify()` itself, but instead of returning string simply adds new terms to
`out` table. Use it in custom `__stringify` methods for serializing child items if you need the best performance.

  Parameters:

  1. `out`: `string[]` Output table with words to concatenate later (without any joining string).

  2. `ptr`: `integer` Position within `out` table to write next word into. At the very start, when table is empty, it would be 1.

  3. `obj`: `any` Item to serialize.

  4. `lineBreak`: `string|nil` Line break with some spaces for aligning child items, or `nil` if compact stringify mode is used. One tab is two spaces.

  5. `depthLimit`: `integer` Limits how many steps down serialization can go. If 0 or below, no tables would be serialized.

  Returns:

  - `integer` Updated `ptr` value (if one item was added to `out`, should increase by 1).
## Function stringify.binary(obj)
Different serializer, produces binary data instead of human-readable. Faster and with even more compact output, but not human-readable.

  Parameters:

  1. `obj`: `table|number|string|boolean|nil` Object to serialize.

  Returns:

  - `string` String with input data presented in binary format, so it won’t be readable and will contain zero bytes.
## Function stringify.binary.parse(serialized)
Parses binary data prepared with `stringify.binary()`.

  Parameters:

  1. `serialized`: `string` Serialized data.

  Returns:

  - `table|number|string|boolean|nil`
## Function stringify.binary.tryParse(serialized, fallback)
Tries to parse binary data prepared with `stringify.binary()`.

Returns fallback value if failed to parse, or if `serialized` is empty or not set, or if any of initializers would raise an error.

  Parameters:

  1. `serialized`: `string?` Serialized data.

  2. `fallback`: `T|nil` Value to return if parsing failed.

  Returns:

  - `T`
## Class ClassStringifiable
A small helper to add as a parent class for EmmyLua to work better.

- `ClassStringifiable:__stringify(out, ptr, obj, lineBreak, depthLimit)`

  Serialize instance of class. Can either return a `string`, or construct it into `out` table and return a new position in it. String itself should be a like of
Lua code which would reconstruct the object on deserialization. Don’t forget to either register referred function with `stringify.register()` or provide
a reference to it in `namespace` table with `stringify.parse()`.

Note: to serialize sub-objects, such as constructor arguments, you can use `stringify()` or `stringify.substep()` if you’re using an approach with
manually constructing `out` table. Alternatively for basic types you can use `string.format()`: “%q” would give you a string in Lua format, so you can use it
like so:
```lua
function MyClass:__serialize()
  return string.format('MyClass(%q, %s)', self.stringName, self.numericalCounter)
end
```

  Parameters:

    1. `out`: `string[]` Output table with words to concatenate later (without any joining string).

    2. `ptr`: `integer` Position within `out` table to write next word into. At the very start, when table is empty, it would be 1.

    3. `obj`: `any` Item to serialize.

    4. `lineBreak`: `string|nil` Line break with some spaces for aligning child items, or `nil` if compact stringify mode is used. One tab is two spaces.

    5. `depthLimit`: `integer` Limits how many steps down serialization can go. If 0 or below, no tables would be serialized.

  Returns:

    - `integer` Updated `ptr` value (if one item was added to `out`, should increase by 1).

# Module common/json.lua

## Function JSON.stringify(data)
Serializes a Lua entity (like a table) into a compact JSON.

  Parameters:

  1. `data`: `table|number|string|boolean|nil`

  Returns:

  - `string`
## Function JSON.parse(data)
Parses a compact JSON into a Lua entity. Note: if JSON is damaged, parser won’t throw an error, but
results might be somewhat unpredictable. It’s an intended behaviour: in 99% of cases JSON parser
used to exchange data with, for example, API endpoints, will receive correct data, but some of those
AC JSON files are pretty screwed and often include things like missing commas, comments, etc.

  Parameters:

  1. `data`: `string?`

  Returns:

  - `any`

# Module common/ac_primitive_vec2.d.lua

## Function vec2.new(x, y)
Creates new vector. It’s usually faster to create a new item with `vec2(x, y)` directly, but the way LuaJIT works,
that call only works with two numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Returns:

  - `vec2`
## Function vec2.isvec2(p)
Checks if value is vec2 or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function vec2.tmp()
Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `vec2`
## Function vec2.intersect(p1, p2, p3, p4)
Intersects two line segments, one going from `p1` to `p2` and another going from `p3` to `p4`. Returns intersection point or `nil` if there is no intersection.

  Returns:

  - `vec2`
## Function vec2(x, y)
Two-dimensional vector. All operators are overloaded. Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec2()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec2()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  Returns:

  - `vec2`
## Class vec2
Two-dimensional vector. All operators are overloaded. Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec2()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec2()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

- `vec2.new(x, y)`

  Creates new vector. It’s usually faster to create a new item with `vec2(x, y)` directly, but the way LuaJIT works,
that call only works with two numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Returns:

    - `vec2`

- `vec2.isvec2(p)`

  Checks if value is vec2 or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `vec2.tmp()`

  Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `vec2`

- `vec2.intersect(p1, p2, p3, p4)`

  Intersects two line segments, one going from `p1` to `p2` and another going from `p3` to `p4`. Returns intersection point or `nil` if there is no intersection.

  Returns:

    - `vec2`

- `vec2:clone()`

  Makes a copy of a vector.

  Returns:

    - `vec2`

- `vec2:unpack()`

  Unpacks vec2 into two numbers.

  Returns:

    - `number`

- `vec2:table()`

  Turns vec2 into a table with two values.

  Returns:

    - `number`

- `vec2:type()`

  Returns reference to vec2 class.
function vec2:type() end

- `vec2:set(x, y)`

  Parameters:

    1. `x`: `vec2|number`

    2. `y`: `number?`

  Returns:

    - `vec2` Returns itself.

- `vec2:setScaled(vec, scale)`

  Parameters:

    1. `vec`: `vec2`

    2. `scale`: `number`

  Returns:

    - `vec2` Returns itself.

- `vec2:setLerp(value1, value2, mix)`

  Parameters:

    1. `value1`: `vec2`

    2. `value2`: `vec2`

    3. `mix`: `number`

  Returns:

    - `vec2` Returns itself.

- `vec2:copyTo(out)`

  Copies its values to a different vector.

  Parameters:

    1. `out`: `vec2`

  Returns:

    - `vec2` Returns itself.

- `vec2:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `vec2|number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:addScaled(valueToAdd, scale, out)`

  Parameters:

    1. `valueToAdd`: `vec2`

    2. `scale`: `number`

    3. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `vec2|number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `vec2`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:div(valueToDivideBy, out)`

  Parameters:

    1. `valueToDivideBy`: `vec2`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:pow(exponent, out)`

  Parameters:

    1. `exponent`: `vec2|number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:min(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec2|number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:max(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec2|number`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:saturate(out)`

  Parameters:

    1. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:clamp(min, max, out)`

  Parameters:

    1. `min`: `vec2`

    2. `max`: `vec2`

    3. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:length()`

  Returns:

    - `number`

- `vec2:lengthSquared()`

  Returns:

    - `number`

- `vec2:distance(otherVector)`

  Parameters:

    1. `otherVector`: `vec2`

  Returns:

    - `number`

- `vec2:distanceSquared(otherVector)`

  Parameters:

    1. `otherVector`: `vec2`

  Returns:

    - `number`

- `vec2:closerToThan(otherVector, distanceThreshold)`

  Parameters:

    1. `otherVector`: `vec2`

    2. `distanceThreshold`: `number`

  Returns:

    - `boolean`

- `vec2:angle(otherVector)`

  Parameters:

    1. `otherVector`: `vec2`

  Returns:

    - `number` Radians.

- `vec2:dot(otherVector)`

  Parameters:

    1. `otherVector`: `vec2`

  Returns:

    - `number`

- `vec2:normalize(out)`

  Normalizes itself (unless different `out` is provided).

  Parameters:

    1. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:lerp(otherVector, mix, out)`

  Rewrites own values with values of lerp of itself and other vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec2`

    2. `mix`: `number`

    3. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

- `vec2:project(otherVector, out)`

  Rewrites own values with values of projection of itself onto another vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec2`

    2. `out`: `vec2|nil` Optional destination argument.

  Returns:

    - `vec2` Returns itself or out value.

# Module common/ac_primitive_vec3.d.lua

## Function vec3.new(x, y, z)
Creates new vector. It’s usually faster to create a new item with `vec3(x, y, z)` directly, but the way LuaJIT works,
that call only works with three numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  Returns:

  - `vec3`
## Function vec3.isvec3(p)
Checks if value is vec3 or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function vec3.tmp()
Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `vec3`
## Function vec3(x, y, z)
Three-dimensional vector. All operators are overloaded.
Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec3()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec3()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  Returns:

  - `vec3`
## Class vec3
Three-dimensional vector. All operators are overloaded.
Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec3()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec3()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

- `vec3.new(x, y, z)`

  Creates new vector. It’s usually faster to create a new item with `vec3(x, y, z)` directly, but the way LuaJIT works,
that call only works with three numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

    1. `x`: `number?`

    2. `y`: `number?`

    3. `z`: `number?`

  Returns:

    - `vec3`

- `vec3.isvec3(p)`

  Checks if value is vec3 or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `vec3.tmp()`

  Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `vec3`

- `vec3:clone()`

  Makes a copy of a vector.

  Returns:

    - `vec3`

- `vec3:unpack()`

  Unpacks vec3 into three numbers.

  Returns:

    - `number`

- `vec3:table()`

  Turns vec3 into a table with three values.

  Returns:

    - `number`

- `vec3:type()`

  Returns reference to vec3 class.
function vec3:type() end

- `vec3:set(x, y, z)`

  Parameters:

    1. `x`: `vec3|number`

    2. `y`: `number?`

    3. `z`: `number?`

  Returns:

    - `vec3` Returns itself.

- `vec3:setScaled(vec, scale)`

  Parameters:

    1. `vec`: `vec3`

    2. `scale`: `number`

  Returns:

    - `vec3` Returns itself.

- `vec3:setLerp(value1, value2, mix)`

  Parameters:

    1. `value1`: `vec3`

    2. `value2`: `vec3`

    3. `mix`: `number`

  Returns:

    - `vec3` Returns itself.

- `vec3:setCrossNormalized(value1, value2)`

  Sets itself to a normalized result of cross product of value1 and value2.

  Parameters:

    1. `value1`: `vec3`

    2. `value2`: `vec3`

  Returns:

    - `vec3` Returns itself.

- `vec3:copyTo(out)`

  Copies its values to a different vector.

  Parameters:

    1. `out`: `vec3`

  Returns:

    - `vec3` Returns itself.

- `vec3:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `vec3|number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:addScaled(valueToAdd, scale, out)`

  Parameters:

    1. `valueToAdd`: `vec3`

    2. `scale`: `number`

    3. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `vec3|number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `vec3`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:div(valueToDivideBy, out)`

  Parameters:

    1. `valueToDivideBy`: `vec3`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:pow(exponent, out)`

  Parameters:

    1. `exponent`: `vec3|number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:min(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec3|number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:max(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec3|number`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:saturate(out)`

  Parameters:

    1. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:clamp(min, max, out)`

  Parameters:

    1. `min`: `vec3`

    2. `max`: `vec3`

    3. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:length()`

  Returns:

    - `number`

- `vec3:lengthSquared()`

  Returns:

    - `number`

- `vec3:distance(otherVector)`

  Parameters:

    1. `otherVector`: `vec3`

  Returns:

    - `number`

- `vec3:distanceSquared(otherVector)`

  Parameters:

    1. `otherVector`: `vec3`

  Returns:

    - `number`

- `vec3:closerToThan(otherVector, distanceThreshold)`

  Parameters:

    1. `otherVector`: `vec3`

    2. `distanceThreshold`: `number`

  Returns:

    - `boolean`

- `vec3:angle(otherVector)`

  Parameters:

    1. `otherVector`: `vec3`

  Returns:

    - `number` Radians.

- `vec3:dot(otherVector)`

  Parameters:

    1. `otherVector`: `vec3`

  Returns:

    - `number`

- `vec3:normalize(out)`

  Normalizes itself (unless different `out` is provided).

  Parameters:

    1. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:cross(otherVector, out)`

  Rewrites own values with values of cross product of itself and other vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec3`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:lerp(otherVector, mix, out)`

  Rewrites own values with values of lerp of itself and other vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec3`

    2. `mix`: `number`

    3. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:project(otherVector, out)`

  Rewrites own values with values of projection of itself onto another vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec3`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:rotate(quaternion, out)`

  Rewrites own values with values of itself rotated with quaternion (unless different `out` is provided).

  Parameters:

    1. `quaternion`: `quat`

    2. `out`: `vec3|nil` Optional destination argument.

  Returns:

    - `vec3` Returns itself or out value.

- `vec3:distanceToLine(a, b)`

  Returns distance from point to a line. For performance reasons doesn’t do any checks, so be careful with incoming arguments.

  Returns:

    - `number`

- `vec3:distanceToLineSquared(a, b)`

  Returns squared distance from point to a line. For performance reasons doesn’t do any checks, so be careful with incoming arguments.

  Returns:

    - `number`

# Module common/ac_primitive_vec4.d.lua

## Function vec4.new(x, y, z, w)
Creates new vector. It’s usually faster to create a new item with `vec4(x, y, z, w)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  4. `w`: `number?`

  Returns:

  - `vec4`
## Function vec4.isvec4(p)
Checks if value is vec4 or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function vec4.tmp()
Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `vec4`
## Function vec4(x, y, z, w)
Four-dimensional vector. All operators are also overloaded.
Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec4()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec4()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  4. `w`: `number?`

  Returns:

  - `vec4`
## Class vec4
Four-dimensional vector. All operators are also overloaded.
Note: creating a lot of new vectors can create extra work for garbage collector reducing overall effectiveness.
Where possible, instead of using mathematical operators consider using methods altering state of already existing vectors. So, instead of:
```lua
someVec = vec4()
…
someVec = math.normalize(vec1 + vec2) * 10
```
Consider rewriting it like:
```lua
someVec = vec4()
…
someVec:set(vec1):add(vec2):normalize():scale(10)
```

- `vec4.new(x, y, z, w)`

  Creates new vector. It’s usually faster to create a new item with `vec4(x, y, z, w)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

    1. `x`: `number?`

    2. `y`: `number?`

    3. `z`: `number?`

    4. `w`: `number?`

  Returns:

    - `vec4`

- `vec4.isvec4(p)`

  Checks if value is vec4 or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `vec4.tmp()`

  Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `vec4`

- `vec4:clone()`

  Makes a copy of a vector.

  Returns:

    - `vec4`

- `vec4:unpack()`

  Unpacks vec4 into four numbers.

  Returns:

    - `number`

- `vec4:table()`

  Turns vec4 into a table with four values.

  Returns:

    - `number`

- `vec4:type()`

  Returns reference to vec4 class.
function vec4:type() end

- `vec4:set(x, y, z, w)`

  Parameters:

    1. `x`: `vec4|number`

    2. `y`: `number?`

    3. `z`: `number?`

    4. `w`: `number?`

  Returns:

    - `vec4` Returns itself.

- `vec4:setScaled(vec, scale)`

  Parameters:

    1. `vec`: `vec4`

    2. `scale`: `number`

  Returns:

    - `vec4` Returns itself.

- `vec4:setLerp(value1, value2, mix)`

  Parameters:

    1. `value1`: `vec4`

    2. `value2`: `vec4`

    3. `mix`: `number`

  Returns:

    - `vec4` Returns itself.

- `vec4:setCrossNormalized(value1, value2)`

  Sets itself to a normalized result of cross product of value1 and value2.

  Parameters:

    1. `value1`: `vec4`

    2. `value2`: `vec4`

  Returns:

    - `vec4` Returns itself.

- `vec4:copyTo(out)`

  Copies its values to a different vector.

  Parameters:

    1. `out`: `vec4`

  Returns:

    - `vec4` Returns itself.

- `vec4:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `vec4|number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:addScaled(valueToAdd, scale, out)`

  Parameters:

    1. `valueToAdd`: `vec4`

    2. `scale`: `number`

    3. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `vec4|number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `vec4`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:div(valueToDivideBy, out)`

  Parameters:

    1. `valueToDivideBy`: `vec4`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:pow(exponent, out)`

  Parameters:

    1. `exponent`: `vec4|number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:min(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec4|number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:max(otherValue, out)`

  Parameters:

    1. `otherValue`: `vec4|number`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:saturate(out)`

  Parameters:

    1. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:clamp(min, max, out)`

  Parameters:

    1. `min`: `vec4`

    2. `max`: `vec4`

    3. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:length()`

  Returns:

    - `number`

- `vec4:lengthSquared()`

  Returns:

    - `number`

- `vec4:distance(otherVector)`

  Parameters:

    1. `otherVector`: `vec4`

  Returns:

    - `number`

- `vec4:distanceSquared(otherVector)`

  Parameters:

    1. `otherVector`: `vec4`

  Returns:

    - `number`

- `vec4:closerToThan(otherVector, distanceThreshold)`

  Parameters:

    1. `otherVector`: `vec4`

    2. `distanceThreshold`: `number`

  Returns:

    - `boolean`

- `vec4:angle(otherVector)`

  Parameters:

    1. `otherVector`: `vec4`

  Returns:

    - `number` Radians.

- `vec4:dot(otherVector)`

  Parameters:

    1. `otherVector`: `vec4`

  Returns:

    - `number`

- `vec4:normalize(out)`

  Normalizes itself (unless different `out` is provided).

  Parameters:

    1. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:lerp(otherVector, mix, out)`

  Rewrites own values with values of lerp of itself and other vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec4`

    2. `mix`: `number`

    3. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

- `vec4:project(otherVector, out)`

  Rewrites own values with values of projection of itself onto another vector (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `vec4`

    2. `out`: `vec4|nil` Optional destination argument.

  Returns:

    - `vec4` Returns itself or out value.

# Module common/ac_primitive_rgb.d.lua

## Function rgb.new(r, g, b, m)
Creates new instance. It’s usually faster to create a new item with `rgb(r, g, b, mult)` directly, but the way LuaJIT works,
that call only works with three numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

  1. `r`: `number?`

  2. `g`: `number?`

  3. `b`: `number?`

  Returns:

  - `rgb`
## Function rgb.isrgb(p)
Checks if value is rgb or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function rgb.tmp()
Temporary color. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `rgb`
## Function rgb.from0255(r, g, b, a)
Creates color from 0…255 values

  Parameters:

  1. `r`: `number` From 0 to 255

  2. `g`: `number` From 0 to 255

  3. `b`: `number` From 0 to 255

  Returns:

  - `rgb`
## Function rgb(r, g, b)
Three-channel color. All operators are overloaded. White is usually `rgb=1,1,1`.

  Parameters:

  1. `r`: `number?`

  2. `g`: `number?`

  3. `b`: `number?`

  Returns:

  - `rgb`
## Class rgb
Three-channel color. All operators are overloaded. White is usually `rgb=1,1,1`.

- `rgb.new(r, g, b, m)`

  Creates new instance. It’s usually faster to create a new item with `rgb(r, g, b, mult)` directly, but the way LuaJIT works,
that call only works with three numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

    1. `r`: `number?`

    2. `g`: `number?`

    3. `b`: `number?`

  Returns:

    - `rgb`

- `rgb.isrgb(p)`

  Checks if value is rgb or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `rgb.tmp()`

  Temporary color. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `rgb`

- `rgb.from0255(r, g, b, a)`

  Creates color from 0…255 values

  Parameters:

    1. `r`: `number` From 0 to 255

    2. `g`: `number` From 0 to 255

    3. `b`: `number` From 0 to 255

  Returns:

    - `rgb`

- `rgb:clone()`

  Makes a copy of a vector.

  Returns:

    - `rgb`

- `rgb:unpack()`

  Unpacks rgb into three numbers.

  Returns:

    - `rgb`

- `rgb:table()`

  Turns rgb into a table with three numbers.

  Returns:

    - `number`

- `rgb:type()`

  Returns reference to rgb class.
function rgb:type() end

- `rgb:set(r, g, b)`

  Parameters:

    1. `r`: `rgb|number`

    2. `g`: `number?`

    3. `b`: `number?`

  Returns:

    - `rgb` Returns itself.

- `rgb:setScaled(x, mult)`

  Parameters:

    1. `x`: `rgb`

    2. `mult`: `number`

  Returns:

    - `rgb` Returns itself.

- `rgb:setLerp(value1, value2, mix)`

  Parameters:

    1. `value1`: `rgb`

    2. `value2`: `rgb`

    3. `mix`: `number`

  Returns:

    - `rgb` Returns itself.

- `rgb:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `rgb|number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:addScaled(valueToAdd, scale, out)`

  Parameters:

    1. `valueToAdd`: `rgb`

    2. `scale`: `number`

    3. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `rgb|number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `rgb`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:div(valueToDivideBy, out)`

  Parameters:

    1. `valueToDivideBy`: `rgb`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:pow(exponent, out)`

  Parameters:

    1. `exponent`: `rgb|number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:min(otherValue, out)`

  Parameters:

    1. `otherValue`: `rgb|number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:max(otherValue, out)`

  Parameters:

    1. `otherValue`: `rgb|number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:saturate(out)`

  Parameters:

    1. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:clamp(min, max, out)`

  Parameters:

    1. `min`: `rgb`

    2. `max`: `rgb`

    3. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:adjustSaturation(saturation, out)`

  Adjusts saturation using a very simple formula.

  Parameters:

    1. `saturation`: `number`

    2. `out`: `rgb|nil` Optional destination argument.

  Returns:

    - `rgb` Returns itself or out value.

- `rgb:normalize()`

  Makes sure brightest value does not exceed 1.

  Returns:

    - `rgb` Returns itself.

- `rgb:value()`

  Returns brightest value (aka V in HSV).

  Returns:

    - `number`

- `rgb:hue()`

  Returns hue.

  Returns:

    - `number`

- `rgb:saturation()`

  Returns saturation.

  Returns:

    - `number`

- `rgb:luminance()`

  Returns luminance value.

  Returns:

    - `number`

- `rgb:rgbm(mult)`

  Returns rgbm.

  Parameters:

    1. `mult`: `number?` Default value: 1.

  Returns:

    - `rgbm`

- `rgb:hsv()`

  Returns HSV color of rgb*mult.

  Returns:

    - `hsv`

- `rgb:vec3()`

  Returns rgb*mult turned to vec3.

  Returns:

    - `vec3`

- `rgb:hex()`

  Returns string with hex representation and leading “#”.

  Returns:

    - `string`

# Module common/ac_primitive_hsv.d.lua

## Function hsv.new(h, s, v)
Creates new instance. It’s usually faster to create a new item with `hsv(h, s, v)`.

  Parameters:

  1. `h`: `number?`

  2. `s`: `number?`

  3. `v`: `number?`

  Returns:

  - `hsv`
## Function hsv.ishsv(p)
Checks if value is hsv or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function hsv.tmp()
Temporary HSV color. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `hsv`
## Function hsv(h, s, v)
HSV color (hue, saturation, value). Equality operator is overloaded.

  Parameters:

  1. `h`: `number?`

  2. `s`: `number?`

  3. `v`: `number?`

  Returns:

  - `hsv`
## Class hsv
HSV color (hue, saturation, value). Equality operator is overloaded.

- `hsv.new(h, s, v)`

  Creates new instance. It’s usually faster to create a new item with `hsv(h, s, v)`.

  Parameters:

    1. `h`: `number?`

    2. `s`: `number?`

    3. `v`: `number?`

  Returns:

    - `hsv`

- `hsv.ishsv(p)`

  Checks if value is hsv or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `hsv.tmp()`

  Temporary HSV color. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `hsv`

- `hsv:clone()`

  Makes a copy of a vector.

  Returns:

    - `hsv`

- `hsv:unpack()`

  Unpacks hsv into three numbers.

  Returns:

    - `rgb`

- `hsv:table()`

  Turns hsv into a table with three numbers.

  Returns:

    - `number`

- `hsv:type()`

  Returns reference to hsv class.
function hsv:type() end

- `hsv:set(h, s, v)`

  Parameters:

    1. `h`: `number`

    2. `s`: `number`

    3. `v`: `number`

  Returns:

    - `hsv` Returns itself.

- `hsv:rgb()`

  Returns RGB color.

  Returns:

    - `rgb`

# Module common/ac_primitive_rgbm.d.lua

## Function rgbm.new(r, g, b, m)
Creates new instance. It’s usually faster to create a new item with `rgbm(r, g, b, mult)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

  1. `r`: `number?`

  2. `g`: `number?`

  3. `b`: `number?`

  4. `m`: `number?` Default value: 1.

  Returns:

  - `rgbm`
## Function rgbm.isrgbm(p)
Checks if value is rgbm or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function rgbm.tmp()
Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `rgbm`
## Function rgbm.from0255(r, g, b, a)
Creates color from 0…255 values

  Parameters:

  1. `r`: `number` From 0 to 255.

  2. `g`: `number` From 0 to 255.

  3. `b`: `number` From 0 to 255.

  4. `a`: `number?` From 0 to 1. Default value: 1.

  Returns:

  - `rgbm`
## Function rgbm(r, g, b, mult)
Four-channel color. Fourth value, `mult`, can be used for alpha, for brightness, anything like that. All operators are also 
overloaded. White is usually `rgb=1,1,1`.

  Parameters:

  1. `r`: `number?`

  2. `g`: `number?`

  3. `b`: `number?`

  4. `mult`: `number?`

  Returns:

  - `rgbm`
## Class rgbm
Four-channel color. Fourth value, `mult`, can be used for alpha, for brightness, anything like that. All operators are also 
overloaded. White is usually `rgb=1,1,1`.

- `rgbm.new(r, g, b, m)`

  Creates new instance. It’s usually faster to create a new item with `rgbm(r, g, b, mult)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

    1. `r`: `number?`

    2. `g`: `number?`

    3. `b`: `number?`

    4. `m`: `number?` Default value: 1.

  Returns:

    - `rgbm`

- `rgbm.isrgbm(p)`

  Checks if value is rgbm or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `rgbm.tmp()`

  Temporary vector. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `rgbm`

- `rgbm.from0255(r, g, b, a)`

  Creates color from 0…255 values

  Parameters:

    1. `r`: `number` From 0 to 255.

    2. `g`: `number` From 0 to 255.

    3. `b`: `number` From 0 to 255.

    4. `a`: `number?` From 0 to 1. Default value: 1.

  Returns:

    - `rgbm`

- `rgbm:clone()`

  Makes a copy of a vector.

  Returns:

    - `rgbm`

- `rgbm:unpack()`

  Unpacks rgbm into rgb and number.

  Returns:

    - `rgb`

- `rgbm:table()`

  Turns rgbm into a table with four values.

  Returns:

    - `number`

- `rgbm:type()`

  Returns reference to rgbm class.
function rgbm:type() end

- `rgbm:set(rgb, mult)`

  Parameters:

    1. `rgb`: `rgbm|rgb`

    2. `mult`: `number?`

  Returns:

    - `rgbm` Returns itself.

- `rgbm:setLerp(value1, value2, mix)`

  Parameters:

    1. `value1`: `rgbm`

    2. `value2`: `rgbm`

    3. `mix`: `number`

  Returns:

    - `rgbm` Returns itself.

- `rgbm:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `rgbm|number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:addScaled(valueToAdd, scale, out)`

  Parameters:

    1. `valueToAdd`: `rgbm`

    2. `scale`: `number`

    3. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `rgbm|number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `rgbm`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:div(valueToDivideBy, out)`

  Parameters:

    1. `valueToDivideBy`: `rgbm`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:pow(exponent, out)`

  Parameters:

    1. `exponent`: `rgbm|number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:min(otherValue, out)`

  Parameters:

    1. `otherValue`: `rgbm|number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:max(otherValue, out)`

  Parameters:

    1. `otherValue`: `rgbm|number`

    2. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:saturate(out)`

  Parameters:

    1. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:clamp(min, max, out)`

  Parameters:

    1. `min`: `rgbm`

    2. `max`: `rgbm`

    3. `out`: `rgbm|nil` Optional destination argument.

  Returns:

    - `rgbm` Returns itself or out value.

- `rgbm:normalize()`

  Makes sure brightest value does not exceed 1.

  Returns:

    - `rgbm` Returns itself.

- `rgbm:value()`

  Returns brightest value.

  Returns:

    - `number`

- `rgbm:luminance()`

  Returns luminance value.

  Returns:

    - `number`

- `rgbm:color()`

  Returns color (rgb*mult).

  Returns:

    - `rgb`

- `rgbm:hsv()`

  Returns HSV color of rgb*mult.

  Returns:

    - `hsv`

- `rgbm:vec3()`

  Returns rgb*mult turned to vec3.

  Returns:

    - `vec3`

- `rgbm:vec4()`

  Returns vec4, where X, Y and Z are RGB values and W is mult.

  Returns:

    - `vec4`

- `rgbm:hex()`

  Returns string with hex representation and leading “#”.

  Returns:

    - `string`

# Module common/ac_primitive_quat.d.lua

## Function quat.new(x, y, z, w)
Creates new quaternion. It’s usually faster to create a new item with `quat(x, y, z, w)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  4. `w`: `number?`

  Returns:

  - `quat`
## Function quat.isquat(p)
Checks if value is quat or not.

  Parameters:

  1. `p`: `any`

  Returns:

  - `boolean`
## Function quat.fromAngleAxis(angle, x, y, z)
Creates a new quaternion.

  Parameters:

  1. `angle`: `number` In radians.

  2. `x`: `vec3|number`

  3. `y`: `number?`

  4. `z`: `number?`

  Returns:

  - `quat`
## Function quat.fromDirection(x, y, z)
Creates a new quaternion.

  Parameters:

  1. `x`: `vec3|number`

  2. `y`: `number?`

  3. `z`: `number?`

  Returns:

  - `quat`
## Function quat.between(u, v)
Creates a new quaternion.

  Parameters:

  1. `u`: `quat`

  2. `v`: `quat`

  Returns:

  - `quat`
## Function quat.tmp()
Temporary quaternion. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

  - `quat`
## Function quat(x, y, z, w)
Quaternion. All operators are overloaded.

  Parameters:

  1. `x`: `number?`

  2. `y`: `number?`

  3. `z`: `number?`

  4. `w`: `number?`

  Returns:

  - `quat`
## Class quat
Quaternion. All operators are overloaded.

- `quat.new(x, y, z, w)`

  Creates new quaternion. It’s usually faster to create a new item with `quat(x, y, z, w)` directly, but the way LuaJIT works,
that call only works with four numbers. If you only provide a single number, rest will be set to 0. This call, however, supports
various calls (which also makes it slightly slower).

  Parameters:

    1. `x`: `number?`

    2. `y`: `number?`

    3. `z`: `number?`

    4. `w`: `number?`

  Returns:

    - `quat`

- `quat.isquat(p)`

  Checks if value is quat or not.

  Parameters:

    1. `p`: `any`

  Returns:

    - `boolean`

- `quat.fromAngleAxis(angle, x, y, z)`

  Creates a new quaternion.

  Parameters:

    1. `angle`: `number` In radians.

    2. `x`: `vec3|number`

    3. `y`: `number?`

    4. `z`: `number?`

  Returns:

    - `quat`

- `quat.fromDirection(x, y, z)`

  Creates a new quaternion.

  Parameters:

    1. `x`: `vec3|number`

    2. `y`: `number?`

    3. `z`: `number?`

  Returns:

    - `quat`

- `quat.between(u, v)`

  Creates a new quaternion.

  Parameters:

    1. `u`: `quat`

    2. `v`: `quat`

  Returns:

    - `quat`

- `quat.tmp()`

  Temporary quaternion. For most cases though, it might be better to define those locally and use those. Less chance of collision.

  Returns:

    - `quat`

- `quat:clone()`

  Makes a copy of a quaternion.

  Returns:

    - `quat`

- `quat:unpack()`

  Unpacks quat into four numbers.

  Returns:

    - `number`

- `quat:table()`

  Turns quat into a table with four values.

  Returns:

    - `number`

- `quat:type()`

  Returns reference to quat class.
function quat:type() end

- `quat:set(x, y, z, w)`

  Parameters:

    1. `x`: `quat|number`

    2. `y`: `number?`

    3. `z`: `number?`

    4. `w`: `number?`

  Returns:

    - `quat` Returns itself.

- `quat:setAngleAxis(angle, x, y, z)`

  Parameters:

    1. `angle`: `number` In radians.

    2. `x`: `vec3|number`

    3. `y`: `number?`

    4. `z`: `number?`

  Returns:

    - `quat` Returns itself.

- `quat:getAngleAxis()`

  Returns:

    1. `number` Angle in radians.

    2. `number` Axis, X.

    3. `number` Axis, Y.

    4. `number` Axis, Z.

- `quat:setBetween(u, v)`

  Parameters:

    1. `u`: `quat`

    2. `v`: `quat`

  Returns:

    - `quat` Returns itself.

- `quat:setDirection(x, y, z)`

  Parameters:

    1. `x`: `vec3|number`

    2. `y`: `number?`

    3. `z`: `number?`

  Returns:

    - `quat` Returns itself.

- `quat:add(valueToAdd, out)`

  Parameters:

    1. `valueToAdd`: `quat|number`

    2. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:sub(valueToSubtract, out)`

  Parameters:

    1. `valueToSubtract`: `quat|number`

    2. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:mul(valueToMultiplyBy, out)`

  Parameters:

    1. `valueToMultiplyBy`: `quat`

    2. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:scale(multiplier, out)`

  Parameters:

    1. `multiplier`: `number`

    2. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:length()`

  Returns:

    - `number`

- `quat:normalize(out)`

  Normalizes itself (unless different `out` is provided).

  Parameters:

    1. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:lerp(otherVector, mix, out)`

  Rewrites own values with values of lerp of itself and other quaternion (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `quat`

    2. `mix`: `number`

    3. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

- `quat:slerp(otherVector, mix, out)`

  Rewrites own values with values of slerp of itself and other quaternion (unless different `out` is provided).

  Parameters:

    1. `otherVector`: `quat`

    2. `mix`: `number`

    3. `out`: `quat|nil` Optional destination argument.

  Returns:

    - `quat` Returns itself or out value.

# Module common/ac_render_enums.lua



# Module common/ac_ui.lua

## Function ui.SmoothInterpolation(initialValue, weightMult)
Very simple thing for smooth UI animations. Call it with a number for its initial state and it would
return you a function. Each frame, call this function with your new target value and it would give you
a smoothly changing numerical value. Unlike functions like `math.applyLag()`, this one is a bit more
complicated, taking into account velocity as well.

  Parameters:

  1. `initialValue`: `number` Initial value with which animation will start.

  2. `weightMult`: `number?` Weight multiplier for smoother or faster animation. Default value: 1.

  Returns:

  - `fun`
## Function ui.FadingElement(drawCallback, initialState)
Another simple helper for easily creating elements fading in and out. Just pass it a draw callback and
and initial state (should it be visible or not), and then call returned function every frame passing it
a boolean to specify if item should be visible or not. Example:
```lua
local timeLeft = 120

local function drawTimeLeft()
  ui.text(string.format('Time left: %02.0f', math.max(0, timeLeft)))
  -- keep in mind: when timer would reach 0, block would still be visible for a bit while fading out, so
  -- that’s why there is that `math.max()` call
end

local fadingTimer = ui.FadingElement(drawTimeLeft)

function script.update(dt)
  timeLeft = timeLeft - dt
  fadingTimer(timeLeft > 0 and timeLeft < 60)  -- only show timer if time left is below 60 seconds
end
```

  Parameters:

  1. `drawCallback`: `fun()` Draw callback. Would only be called if alpha is above 0.2%, so there is no overhead if element is hidden.

  2. `initialState`: `boolean?` Should element be visible from the start. Default value: `false`.

  Returns:

  - `fun`
## Class ui.FileIcon
Helper for drawing file icons.

- `ui.FileIcon:style(style)`

  Set icon style.

  Parameters:

    1. `style`: `ui.FileIcon.Style`
## Class ui.DWriteFont
DirectWrite font name builder. Instead of using it, you can simply provide a string, but this thing might be a nicer way. You can chain its methods too:
```lua
local MyFavouriteFont = ui.DWriteFont('Best Font', './data'):weight(ui.DWriteFont.Weight.Bold):style(ui.DWriteFont.Style.Italic):stretch(ui.DWriteFont.Stretch.Condensed)
…
ui.pushFont(MyFavouriteFont)  -- you could also just put font here, but if defined once and reused, it would generate less garbage for GC to clean up.
ui.dwriteText('Hello world!', 14)
ui.popFont()
```

- `ui.DWriteFont:weight(weight)`

  Set font weight. Bold styles can be emulated even if there isn’t such font face, although quality of real font face would be better.

  Parameters:

    1. `weight`: `ui.DWriteFont.Weight|integer` Alternatively, could be an integer in 1…999 range.

  Returns:

    - `self`

- `ui.DWriteFont:style(style)`

  Set font style. Italic style can be emulated even if there isn’t such font face, although quality of real font face would be better.

  Parameters:

    1. `style`: `ui.DWriteFont.Style`

  Returns:

    - `self`

- `ui.DWriteFont:stretch(stretch)`

  Set font stretch.

  Parameters:

    1. `stretch`: `ui.DWriteFont.Stretch`

  Returns:

    - `self`

- `ui.DWriteFont:axis(key, value)`

  Set a custom axis value (available on Windows 10 Build 20348 or newer, otherwise values will be ignored).

  Parameters:

    1. `key`: `'weight'|'width'|'slant'|'opticalSize'|'italic'|string` Font variation table with list of keys is shown on https://fontdrop.info/.

    2. `value`: `number`

  Returns:

    - `self`

- `ui.DWriteFont:allowRealSizes(allow)`

  Disable font size rounding. Please use carefully: if you would to animate font size, it would quickly generate way too many atlases
and increase both VRAM consumption and drawing time. If you need to animate font size, consider using `ui.beginScale()`/`ui.endScale()` instead.

  Parameters:

    1. `allow`: `boolean?` Default value: `true`.

  Returns:

    - `self`

- `ui.DWriteFont:allowEmoji(allow)`

  Allow or disallow use of colored emojis. If disabled, default black and white system glyphs will be drawn instead to system capabilities.
Emoji are enabled by default.

  Parameters:

    1. `allow`: `boolean?` Default value: `true`.

  Returns:

    - `self`
## Function ui.weatherIcon(weatherType)
Returns an icon for a given weather type

  Parameters:

  1. `weatherType`: `ac.WeatherType`

  Returns:

  - `ui.Icons`
## Function ui.pushStyleVar(varID, value)
Push style variable.

  Parameters:

  1. `varID`: `ui.StyleVar`

  2. `value`: `number|vec2`
## Function ui.pushID(value)
Push ID (use it if you, for example, have a list of buttons created in a loop).

  Parameters:

  1. `value`: `number|string`
## Function ui.inputText(label, str, flags, size)
Text input control. Returns updated string (which would be the input string unless it changed, so no)
copying there. Second return value would change to `true` when text has changed. Example:
```lua
myText = ui.inputText('Enter something:', myText)
```

Third value returned is `true` if Enter was pressed while editing text.

  Parameters:

  1. `label`: `string`

  2. `str`: `string`

  3. `flags`: `ui.InputTextFlags?`

  4. `size`: `vec2?` If specified, text input is multiline.

  Returns:

  1. `string`

  2. `boolean`

  3. `boolean`
## Function ui.colorPicker(label, color, flags)
Color picker control. Returns true if color has changed (as usual with Lua, colors are passed)
by reference so update value would be put in place of old one automatically.

  Parameters:

  1. `label`: `string`

  2. `color`: `rgb|rgbm`

  3. `flags`: `ui.ColorPickerFlags?`

  Returns:

  - `boolean`
## Function ui.colorButton(label, color, flags, size)
Color button control. Returns true if color has changed (as usual with Lua, colors are passed)
by reference so update value would be put in place of old one automatically.

  Parameters:

  1. `label`: `string`

  2. `color`: `rgb|rgbm`

  3. `flags`: `ui.ColorPickerFlags?`

  4. `size`: `vec2?`

  Returns:

  - `boolean`
## Function ui.toast(icon, message, undoCallback)
Show popup message.

  Parameters:

  1. `icon`: `ui.Icons`

  2. `message`: `string`

  3. `undoCallback`: `fun()|nil` If provided, there’ll be an undo button which, when clicked, will call this callback.
## Function ui.transparentWindow(id, pos, size, noPadding, inputs, content)
Draw a window with transparent background.

  Parameters:

  1. `id`: `string` Window ID, has to be unique within your script.

  2. `pos`: `vec2` Window position.

  3. `size`: `vec2` Window size.

  4. `noPadding`: `boolean?` Disables window padding. Default value: `false`.

  5. `inputs`: `boolean?` Enables inputs (buttons and such). Default value: `false`.

  6. `content`: `fun(): T?` Window content callback.

  Returns:

  - `T`
## Function ui.toolWindow(id, pos, size, noPadding, inputs, content)
Draw a window with semi-transparent background.

  Parameters:

  1. `id`: `string` Window ID, has to be unique within your script.

  2. `pos`: `vec2` Window position.

  3. `size`: `vec2` Window size.

  4. `noPadding`: `boolean?` Disables window padding. Default value: `false`.

  5. `inputs`: `boolean?` Enables inputs (buttons and such). Default value: `false`.

  6. `content`: `fun(): T?` Window content callback.

  Returns:

  - `T`
## Function ui.tooltip(padding, content)
Draw a tooltip with custom content.

  Parameters:

  1. `padding`: `vec2?` Tooltip padding. Default value: `vec2(20, 8)`.

  2. `content`: `fun(): T?` Window content callback.

  Returns:

  - `T`
## Function ui.childWindow(id, size, border, flags, content)
Draw a child window: perfect for clipping content, for scrolling lists, etc. Think of it more like
a HTML div with overflow set to either scrolling or hidden, for example.

  Parameters:

  1. `id`: `string` Window ID, has to be unique within given context (like, two sub-windows of the same window should have different IDs).

  2. `size`: `vec2` Window size.

  3. `border`: `boolean?` Window border.

  4. `flags`: `ui.WindowFlags?` Window flags.

  5. `content`: `fun(): T?` Window content callback.

  Returns:

  - `T`
## Function ui.treeNode(label, flags, content)
Draw a tree node element: a collapsible block with content inside it (which might include other tree
nodes). Great for grouping things together. Note: if you need to have a tree node with changing label,
use label like “your changing label###someUniqueID” for it to work properly. Everything after “###” will
count as ID and not be shown. Same trick applies to other controls as well, such as tabs, buttons, etc.

  Parameters:

  1. `label`: `string` Tree node label (which also acts like its ID).

  2. `flags`: `ui.TreeNodeFlags?` Tree node flags.

  3. `content`: `fun(): T?` Tree node content callback (called only if tree node is expanded).

  Returns:

  - `T`
## Function ui.tabBar(id, flags, content)
Draw a section with tabs. Inside, use `ui.tabItem()` to draw actual tabs like so:
```lua
ui.tabBar('someTabBarID', function ()
  ui.tabItem('Tab 1', function () --[[ Contents of Tab 1 ]] end)
  ui.tabItem('Tab 2', function () --[[ Contents of Tab 2 ]] end)
end)
```

  Parameters:

  1. `id`: `string` Tab bar ID.

  2. `flags`: `ui.TabBarFlags?` Tab bar flags.

  3. `content`: `fun(): T?` Individual tabs callback.

  Returns:

  - `T`
## Function ui.tabItem(label, flags, content, opened)
Draw a new tab in a tab bar. Note: if you need to have a tab with changing label,
use label like “your changing label###someUniqueID” for it to work properly. Everything after “###” will
count as ID and not be shown. Same trick applies to other controls as well, such as tree nodes, buttons, etc.
```lua
ui.tabBar('someTabBarID', function ()
  ui.tabItem('Tab 1', function () --[[ Contents of Tab 1 ]] end)
  ui.tabItem('Tab 2', function () --[[ Contents of Tab 2 ]] end)
end)
```

  Parameters:

  1. `label`: `string` Tab label.

  2. `flags`: `ui.TabItemFlags?` Tab flags.

  3. `content`: `fun(): T?` Tab content callback (called only if tab is selected).

  4. `opened`: `refbool?` Pass a `refbool` with `true` value here to show close button. When clicked, value in `refbool` will  be set to `false`.

  Returns:

  - `T`
## Function ui.onImageReady(imageSource, callback)
Sets a callback that will be called when image is loaded. If image is already loaded, calls `callback` immediately, before
exiting the function.

Note: By default images from local files are loaded syncronously, use `ui.setAsynchronousImagesLoading(true)` function to change this behaviour.

  Parameters:

  1. `imageSource`: `ui.ImageSource` Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.

  2. `callback`: `fun()` Callback to call once image is loaded.
## Function ui.itemPopup(id, mouseButton, content)
Adds context menu to previously drawn item which would open when certain mouse button would be pressed. Once it happens,
content callback will be called each frame to draw contents of said menu.
```lua
ui.itemPopup(ui.MouseButton.Right, function ()
  if ui.selectable('Item 1') then --[[ Item 1 was clicked ]] end
  if ui.selectable('Item 2') then --[[ Item 2 was clicked ]] end
  ui.separator()
  if ui.selectable('Item 3') then --[[ Item 3 was clicked ]] end
  -- Other types of controls would also work
end)
```

  Parameters:

  1. `id`: `string` Context menu ID.

  2. `mouseButton`: `ui.MouseButton` Mouse button

  3. `content`: `fun(): T?` Menu content callback (called only if menu is opened).

  Returns:

  - `T`
## Function ui.combo(label, previewValue, flags, content)
Adds a dropdown list (aka combo box). Items are drawn in content callback function, or alternatively
it can work with a list of strings and an ID of a selected item, returning either ID of selected item and
boolean with `true` value if it was changed, or if ID is a refnumber, it would just return a boolean value
for whatever it was changed or not.

  Parameters:

  1. `label`: `string` Label of the element.

  2. `previewValue`: `string?` Preview value.

  3. `flags`: `ui.ComboFlags?` Combo box flags.

  4. `content`: `fun(): T?` Combo box items callback.

  Returns:

  - `T`
## Function ui.slider(label, value, min, max, format, power)
Adds a slider. For value, either pass `refnumber` and slider would return a single boolean with `true` value
if it was moved (and storing updated value in passed `refnumber`), or pass a regular number and then
slider would return number and then a boolean. Example:
```lua
-- With refnumber:
local ref = refnumber(currentValue)
if ui.slider('Test', ref) then currentValue = ref.value end

-- Without refnumber:
local value, changed = ui.slider('Test', currentValue)
if changed then currentValue = value end

-- Or, of course, if you don’t need to know if it changed (and, you can always use `ui.itemEdited()` as well):
currentValue = ui.slider('Test', currentValue)
```
I personally prefer to hide slider label and instead use its format string to show what’s it for. IMGUI would
not show symbols after “##”, but use them for ID calculation.
```lua
currentValue = ui.slider('##someSliderID', currentValue, 0, 100, 'Quantity: %.0f')
```
By the way, a bit of clarification: “##” would do
that, but “###” would result in ID where only symbols going after “###” are taken into account. Helps if you
have a control which label is constantly changing. For example, a tab showing a number of elements or current time.

To enter value with keyboard, hold Ctrl and click on it.

  Parameters:

  1. `label`: `string` Slider label.

  2. `value`: `refnumber|number` Current slider value.

  3. `min`: `number?` Default value: 0.

  4. `max`: `number?` Default value: 1.

  5. `format`: `string|'%.3f'|nil` C-style format string. Default value: `'%.3f'`.

  6. `power`: `number|boolean|nil` Power for non-linear slider. Default value: `1` (linear). Pass `true` to enable integer mode instead.

  Returns:

  1. `number` Possibly updated slider value.

  2. `boolean` True if slider has moved.
## Function ui.drawRaceFlag(color)
Draws race flag of a certain type, or in a certain color in its usual position.
Use it if you want to add a new flag type: this way, if custom UI later would replace flags with
a different look (or even if it’s just a custom texture mod), it would still work.

Note: if your script can access physics and you need a regular flag, using `physics.overrideRacingFlag()`
would work better (it would also affect track conditions and such).

  Parameters:

  1. `color`: `ac.FlagType|rgbm`
## Function ui.drawCarIcon(iconID, color, hint)
Draws icon for car state, along with low fuel icon. If more than one icon is visible at once, subsequent ones are drawn
to the right of previous icon. Settings altering position and opacity of low fuel icon also apply here. Background is
included by default: simply pass a semi-transparent symbol here.

  Parameters:

  1. `iconID`: `ui.Icons|fun(iconSize: number)` Might be an icon ID or anything else `ui.icon()` can take, or a function taking icon size.

  2. `color`: `rgbm?` Icon tint for background. Default value: `rgbm.colors.white`.

  3. `hint`: `string?` Optional hint appearing if mouse is hovering the icon.
## Function ui.atlasIconID(filename, uv1, uv2)
Generates ID to use with `ui.icon()` to draw an icon from an atlas.

  Parameters:

  1. `filename`: `string` Texture filename.

  2. `uv1`: `vec2` UV coordinates of the upper left corner.

  3. `uv2`: `vec2` UV coordinates of the bottom right corner.

  Returns:

  - `ui.Icons` Returns an ID to be used as an argument for `ui.icon()` function.
## Function ui.atlasIcons(filename, columns, rows, icons)
Generates a table acting like icons atlas.

  Parameters:

  1. `filename`: `string` Texture filename.

  2. `columns`: `integer` Number of columns in the atlas.

  3. `rows`: `integer` Number of rows in the atlas.

  4. `icons`: `T` Table with icons from left top corner, each icon is a table with 1-based row and column indices.

  Returns:

  - `T`
## Function ui.ExtraCanvas(resolution, mips, antialiasingMode, textureFormat, flags)

  Parameters:

  1. `resolution`: `vec2|integer` Resolution in pixels. Usually textures with sizes of power of two work the best.

  2. `mips`: `integer?` Number of MIPs for a texture. MIPs are downsized versions of main texture used to avoid aliasing. Default value: 1 (no MIPs).

  3. `antialiasingMode`: `render.AntialiasingMode?` Antialiasing mode. Default value: `render.AntialiasingMode.None` (disabled).

  4. `textureFormat`: `render.TextureFormat?` Texture format. Default value: `render.TextureFormat.R8G8B8A8.UNorm`.

  5. `flags`: `render.TextureFlags?` Extra flags. Default value: `0`.

  Returns:

  - `ui.ExtraCanvas`
## Class ui.ExtraCanvas
Extra canvases are textures you can use in UI calls instead of filenames or apply as material textures to scene geometry,
and also edit them live by drawing things into them using “ui…” functions. A few possible use cases as an example:
- If your app or display uses a complex background or another element, it might be benefitial to draw it into a texture once and then reuse it;
- If you want to apply some advanced transformations to some graphics, it might work better to use texture;
- It can also be used to blur some elements by drawing them into a texture and then drawing it blurred.

Note: update happens from a different short-lived UI context, so interactive controls would not work here.

- `ui.ExtraCanvas:dispose()`

  Disposes canvas and releases resources.
function _ui_ExtraCanvas:dispose() end

- `ui.ExtraCanvas:mip(index)`

  Return explicit MIP to use as an image. If called with index of 0, returns texture similar to main one, but only with a single MIP.

  Parameters:

    1. `index`: `integer` 0-based MIP index.

- `ui.ExtraCanvas:setName(name)`

  Sets canvas name for debugging. Canvases with set name appear in Lua Debug App, allowing to monitor their state.

  Parameters:

    1. `name`: `string?` Name to display texture as. If set to `nil` or `false`, name will be reset and texture will be hidden.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:update(callback)`

  Updates texture, calling `callback` to draw things with. If you want to do several changes, it would work better to group them in a
single `canvas:update()` call.

Note: canvas won’t be cleared here, to clear it first, use `canvas:clear()` method.

  Parameters:

    1. `callback`: `fun(dt: number)` Drawing function. Might not be called if canvas has been disposed or isn’t available for drawing into.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:updateWithShader(params)`

  Updates texture using a shadered quad. Faster than using `:update()` with `ui.renderShader()`:
no time will be wasted setting up IMGUI pass and preparing all that data, just a single draw call.
Shader is compiled at first run, which might take a few milliseconds.
If you’re drawing things continuously, use `async` parameter and shader will be compiled in a separate thread,
while drawing will be skipped until shader is ready.

You can bind up to 32 textures and pass any number/boolean/vector/color/matrix values to the shader, which makes
it a very effective tool for any custom drawing you might need to make.

  Parameters:

    1. `params`: `{p1: vec2, p2: vec2, uv1: vec2, uv2: vec2, mip: integer, blendMode: render.BlendMode, async: boolean, cacheKey: number, defines: table, textures: table, values: table, directValuesExchange: boolean, shader: string}|`{textures` = {}, values = {}, shader = 'float4 main(PS_IN pin) {return float4(pin.Tex.x, pin.Tex.y, 0, 1);}'}` "Table with properties:\n- `p1` (`vec2`): Position of upper left corner relative to whole screen or canvas. Default value: `vec2(0, 0)`.\n- `p2` (`vec2`): Position of bottom right corner relative to whole screen or canvas. Default value: size of canvas.\n- `uv1` (`vec2`): Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.\n- `uv2` (`vec2`): Texture coordinates for bottom right corner. Default value: `vec2(1, 1)`.\n- `mip` (`integer`): 0-based index of target MIP layer. Default value: `0`. Use `:mip(index - 1)` as a texture input to access previous MIP view in case you want to generate new MIPs from previous ones. If this parameter is above 0, automatic MIPs generation stops.\n- `blendMode` (`render.BlendMode`): Blend mode. Default value: `render.BlendMode.Opaque`.\n- `async` (`boolean`): If set to `true`, drawing won’t occur until shader would be compiled in a different thread.\n- `cacheKey` (`number`): Optional cache key for compiled shader (caching will depend on shader source code, but not on included files, so make sure to change the key if included files have changed).\n- `defines` (`table`): Defines to pass to the shader, either boolean, numerical or string values (don’t forget to wrap complex expressions in brackets). False values won’t appear in code and true will be replaced with 1 so you could use `#ifdef` and `#ifndef` with them.\n- `textures` (`table`): Table with textures to pass to a shader. For textures, anything passable in `ui.image()` can be used (filename, remote URL, media element, extra canvas, etc.). If you don’t have a texture and need to reset bound one, use `false` for a texture value (instead of `nil`)\n- `values` (`table`): Table with values to pass to a shader. Values can be numbers, booleans, vectors, colors or 4×4 matrix. Values will be aligned automatically.\n- `directValuesExchange` (`boolean`): If you’re reusing table between calls instead of recreating it each time and pass `true` as this parameter, `values` table will be swapped with an FFI structure allowing to skip data copying step and achieve the best performance. Note: with this mode, you’ll have to transpose matrices manually.\n- `shader` (`string`): Shader code (format is HLSL, regular DirectX shader); actual code will be added into a template in “assettocorsa/extension/internal/shader-tpl/ui.fx”."

  Returns:

    - `boolean` Returns `false` if shader is not yet ready and no drawing occured (happens only if `async` is set to `true`).

- `ui.ExtraCanvas:updateSceneWithShader(params)`

  Updates texture using a shader with a fullscreen pass. Faster than using `:update()` with `ui.renderShader()`:
no time will be wasted setting up IMGUI pass and preparing all that data, just a single draw call.
Shader is compiled at first run, which might take a few milliseconds.
If you’re drawing things continuously, use `async` parameter and shader will be compiled in a separate thread,
while drawing will be skipped until shader is ready.

You can bind up to 32 textures and pass any number/boolean/vector/color/matrix values to the shader, which makes
it a very effective tool for any custom drawing you might need to make.

Unlike `:updateWithShader()`, this version is single pass stereo-aware and can be used in the middle of
rendering scene, and has access to camera state and some rendering pipeline textures by default (see “fullscreen.fx” template).
Use it if you need to prepare an offscreen buffer to apply to the scene.

  Parameters:

    1. `params`: `{p1: vec2, p2: vec2, uv1: vec2, uv2: vec2, mip: integer, blendMode: render.BlendMode, async: boolean, cacheKey: number, defines: table, textures: table, values: table, directValuesExchange: boolean, shader: string}|`{textures` = {}, values = {}, shader = 'float4 main(PS_IN pin) {return float4(pin.Tex.x, pin.Tex.y, 0, 1);}'}` "Table with properties:\n- `p1` (`vec2`): Position of upper left corner relative to whole screen or canvas. Default value: `vec2(0, 0)`.\n- `p2` (`vec2`): Position of bottom right corner relative to whole screen or canvas. Default value: size of canvas.\n- `uv1` (`vec2`): Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.\n- `uv2` (`vec2`): Texture coordinates for bottom right corner. Default value: `vec2(1, 1)`.\n- `mip` (`integer`): 0-based index of target MIP layer. Default value: `0`. Use `:mip(index - 1)` as a texture input to access previous MIP view in case you want to generate new MIPs from previous ones. If this parameter is above 0, automatic MIPs generation stops.\n- `blendMode` (`render.BlendMode`): Blend mode. Default value: `render.BlendMode.Opaque`.\n- `async` (`boolean`): If set to `true`, drawing won’t occur until shader would be compiled in a different thread.\n- `cacheKey` (`number`): Optional cache key for compiled shader (caching will depend on shader source code, but not on included files, so make sure to change the key if included files have changed).\n- `defines` (`table`): Defines to pass to the shader, either boolean, numerical or string values (don’t forget to wrap complex expressions in brackets). False values won’t appear in code and true will be replaced with 1 so you could use `#ifdef` and `#ifndef` with them.\n- `textures` (`table`): Table with textures to pass to a shader. For textures, anything passable in `ui.image()` can be used (filename, remote URL, media element, extra canvas, etc.). If you don’t have a texture and need to reset bound one, use `false` for a texture value (instead of `nil`)\n- `values` (`table`): Table with values to pass to a shader. Values can be numbers, booleans, vectors, colors or 4×4 matrix. Values will be aligned automatically.\n- `directValuesExchange` (`boolean`): If you’re reusing table between calls instead of recreating it each time and pass `true` as this parameter, `values` table will be swapped with an FFI structure allowing to skip data copying step and achieve the best performance. Note: with this mode, you’ll have to transpose matrices manually.\n- `shader` (`string`): Shader code (format is HLSL, regular DirectX shader); actual code will be added into a template in “assettocorsa/extension/internal/shader-tpl/ui.fx”."

  Returns:

    - `boolean` Returns `false` if shader is not yet ready and no drawing occured (happens only if `async` is set to `true`).

- `ui.ExtraCanvas:clear(col)`

  Clears canvas.

  Parameters:

    1. `col`: `rgbm?` Default value: `rgbm.colors.transparent`.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:applyAntialiasing()`

  Manually applies antialiasing to the texture (works only if it was created with a specific antialiasing mode).
By default antialiasing is applied automatically, but calling this function switches AA to a manual mode.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:mipsUpdate()`

  Generates MIPs. Once called, switches texture to manual MIPs generating mode. Note: this operation is not that expensive, but it’s not free.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:setExposure(value)`

  Overrides exposure used if antialiasing mode is set to YEBIS value. By default scene exposure is used.

  Parameters:

    1. `value`: `number?` Exposure used by YEBIS post-processing. Pass `nil` to reset to default behavior.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:save(filename, format)`

  Saves canvas as an image.

  Parameters:

    1. `filename`: `string` Destination filename.

    2. `format`: `ac.ImageFormat|nil` Texture format (by default guessed based on texture name).

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:encode()`

  Returns image encoded in DDS format. Might be useful if you would need to store an image
in some custom form (if so, consider compressing it with `ac.compress()`).

Note: you can later use `ui.decodeImage()` to get a string which you can then pass as a texture name
to any of texture receiving functions. This way, you can load image into a new canvas later: just
create a new canvas (possibly using `ui.imageSize()` first to get image size) and update it drawing
imported image to the full size of the canvas.

  Returns:

    - `string|nil` Binary data, or `nil` if binary data export has failed.

- `ui.ExtraCanvas:size()`

  Returns texture resolution (or zeroes if element has been disposed).

  Returns:

    - `vec2`

- `ui.ExtraCanvas:mips()`

  Returns number of MIP maps (1 for no MIP maps and it being a regular texture).

  Returns:

    - `integer`

- `ui.ExtraCanvas:sharedHandle(crossProcess)`

  Returns shared handle to the texture. Shared handle can be used in other scripts with `ui.SharedTexture()`, or, if `crossProcess` flag
is set to `true`, also accessed by other processes.

  Parameters:

    1. `crossProcess`: `boolean?` Set to `true` to be able to pass a handle to other processes. Requires `render.TextureFlags.Shared` flag to be set during creation. Default value: `false`.

  Returns:

    - `integer`

- `ui.ExtraCanvas:clone()`

  Clones current canvas.

  Returns:

    - `ui.ExtraCanvas` Returns new canvas.

- `ui.ExtraCanvas:backup()`

  Backup current state of canvas, return a function which can be called to restore original state. Note:
it clones current canvas texture, so don’t make too many backup copies at once.

  Returns:

    - `fun`

- `ui.ExtraCanvas:copyFrom(other)`

  Copies contents from another canvas, CPU canvas data, image or an icon. Faster than copying by drawing. If source is disposed or missing,
does not alter the contents of the canvas.

  Parameters:

    1. `other`: `ui.ExtraCanvas|ui.ExtraCanvasData|ui.Icons` Canvas to copy content from.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:gaussianBlurFrom(other, kernelSize)`

  Fills with canvas with blurred version of another texture, applying two optimized gaussian blur passes.

  Parameters:

    1. `other`: `ui.ImageSource` Canvas to copy content from.

    2. `kernelSize`: `ui.GaussianBlurKernelSize?` Kernel size. Default value: 63.

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.

- `ui.ExtraCanvas:accessData(callback)`

  Downloads data from GPU to CPU asyncronously (usually takes about 0.15 ms to get the data). Resulting data can be
used to access colors of individual pixels or upload it back to CPU restoring original state.

  Parameters:

    1. `callback`: `fun(err: string, data: ui.ExtraCanvasData)`

  Returns:

    - `ui.ExtraCanvas` Returns itself for chaining several methods together.
## Class ui.ExtraCanvasData
Contents of `ui.ExtraCanvas` copied to CPU. There, that data can no longer be used to draw things (but it can be uploaded
back to GPU with `canvas:copyFrom()`), but it can be used to quickly access colors of individual pixels. Unlike `ui.ExtraCanvas`,
instances of `ui.ExtraCanvasData` consume RAM, not VRAM.

To save RAM while storing several copies of data, you can use `data:compress()` to apply fast LZ4 compression. Note that each time
you would use data by reading colors of pixels, data would get decompressed automatically. Copying extra data back to canvas with
`canvas:copyFrom()` works with both compressed and decompressed data (data would be decompressed temporary).

- `ui.ExtraCanvasData:dispose()`

  Disposes canvas and releases resources.
function _ui_ExtraCanvasData:dispose() end

- `ui.ExtraCanvasData:compress()`

  Compresses data using LZ4 algorithm if data wasn’t compressed already.

  Returns:

    - `ui.ExtraCanvasData` Returns itself for chaining several methods together.

- `ui.ExtraCanvasData:size()`

  Returns original texture resolution (or zeroes if data has been disposed).

  Returns:

    - `vec2`

- `ui.ExtraCanvasData:compressed()`

  Returns `true` if data is currently compressed.

  Returns:

    - `boolean`

- `ui.ExtraCanvasData:memoryFootprint()`

  Returns space taken by data in bytes.

  Returns:

    - `integer`

- `ui.ExtraCanvasData:floatValue(x, y)`

  Returns numeric value of a pixel of R32FLOAT texture. If coordinates are outside, or data has been disposed, returns zeroes.

  Parameters:

    1. `x`: `integer` 0-based X coordinate.

    2. `y`: `integer` 0-based Y coordinate.

  Returns:

    - `number` Pixel color from 0 to 1.

- `ui.ExtraCanvasData:color(x, y)`

  Returns color of a pixel of RGBA8888 texture. If coordinates are outside, or data has been disposed, returns zeroes.

  Parameters:

    1. `x`: `integer` 0-based X coordinate.

    2. `y`: `integer` 0-based Y coordinate.

  Returns:

    - `rgbm` Pixel color from 0 to 1.

- `ui.ExtraCanvasData:colorTo(color, x, y)`

  Writes color of a pixel to a provided `rgbm` value. Same as `data:color()`, but does not create new color values, so should be
easier on garbage collector and more useful if you need to go through a lot of pixels for some reason.

  Parameters:

    1. `color`: `rgbm` 0-based X coordinate.

    2. `x`: `integer` 0-based X coordinate.

    3. `y`: `integer` 0-based Y coordinate.

  Returns:

    - `rgbm` Pixel color from 0 to 1 (same as input `color`).
## Function ui.shortcut(key, ...)
Returns a function which returns `true` when keyboard shortcut is pressed.

  Parameters:

  1. `key`: `{key: ui.KeyIndex, ctrl: boolean, alt: boolean, shift: boolean, super: boolean}|`{` key = ui.KeyIndex.A, ctrl = false }`

  Returns:

  - `fun`
## Function ui.renderTexture(params)
Draws image using custom drawcall (not an IMGUI drawcall). Any transformations and color shifts
wouldn’t work. But there are some extra shading features available here.

  Parameters:

  1. `params`: `{filename: string, p1: vec2, p2: vec2, color: rgbm, colorOffset: rgbm, uv1: vec2, uv2: vec2, blendMode: render.BlendMode, mask1: string, mask1UV1: vec2, mask1UV2: vec2, mask1Flags: render.TextureMaskFlags, mask2: string, mask2UV1: vec2, mask2UV2: vec2, mask2Flags: render.TextureMaskFlags}|`{filename` = '', p1 = vec2(0, 0), p2 = vec2(1, 1), color = rgbm.colors.white, uv1 = vec2(0, 0), uv2 = vec2(1, 1), blendMode = render.BlendMode.BlendAccurate}` "Table with properties:\n- `filename` (`string`): Path to the image, absolute or relative to script folder or AC root. URLs are also accepted.\n- `p1` (`vec2`): Position of upper left corner relative to whole screen or canvas.\n- `p2` (`vec2`): Position of bottom right corner relative to whole screen or canvas.\n- `color` (`rgbm`): Tint of the image, with white it would be drawn as it is. In this call, can be above 0. Default value: `rgbm.colors.white`.\n- `colorOffset` (`rgbm`): Color offset. Default value: `rgbm.colors.transparent`.\n- `uv1` (`vec2`): Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.\n- `uv2` (`vec2`): Texture coordinates for bottom right corner. Default value: `vec2(1, 1)`.\n- `blendMode` (`render.BlendMode`): Blend mode. Default value: `render.BlendMode.BlendAccurate`.\n- `mask1` (`string`): Optional mask #1, resulting image will be drawn only if mask is non-transparent and with non-zero alpha channel. Default value: `nil`.\n- `mask1UV1` (`vec2`): Texture coordinates for upper left corner of a mask. Default value: `vec2(0, 0)`.\n- `mask1UV2` (`vec2`): Texture coordinates for bottom right corner of a mask. Default value: `vec2(1, 1)`.\n- `mask1Flags` (`render.TextureMaskFlags`): Flags for the first mask. Default value: 6.\n- `mask2` (`string`): Optional mask #2, resulting image will be drawn only if mask is non-transparent and with non-zero alpha channel. Default value: `nil`.\n- `mask2UV1` (`vec2`): Texture coordinates for upper left corner of a mask. Default value: `vec2(0, 0)`.\n- `mask2UV2` (`vec2`): Texture coordinates for bottom right corner of a mask. Default value: `vec2(1, 1)`.\n- `mask2Flags` (`render.TextureMaskFlags`): Flags for the second mask. Default value: 6."
## Function ui.renderShader(params)
Draws a quad with a custom shader. Shader is compiled at first run, which might take a few milliseconds.
If you’re drawing things continuously, use `async` parameter and shader will be compiled in a separate thread,
while drawing will be skipped until shader is ready.

You can bind up to 32 textures and pass any number/boolean/vector/color/matrix values to the shader, which makes
it a very effective tool for any custom drawing you might need to make.

Example:
```lua
ui.renderShader({
  async = true,
  p1 = vec2(),
  p2 = ui.windowSize(),
  blendMode = render.BlendMode.BlendAdd,
  textures = {
    txInput1 = 'texture.png',  -- any key would work, but it’s easier to have a common prefix like “tx”
    txInput2 = mediaPlayer,
    txMissing = false
  },
  values = {
    gValueColor = rgbm(1, 2, 0, 0.5),  -- any key would work, but it’s easier to have a common prefix like “g”
    gValueNumber = math.random(),
    gValueVec = vec2(1, 2),
    gFlag = math.random() > 0.5
  },
  shader = [[
    float4 main(PS_IN pin) {
      float4 in1 = txInput1.Sample(samAnisotropic, pin.Tex);
      float4 in2 = txInput2.Sample(samAnisotropic, pin.Tex + gValueVec);
      return gFlag ? in1 + in2 * gValueColor : in2;
    }
  ]]
})
```

Tip: to simplify and speed things up, it might make sense to move table outside of a function to reuse it from frame
to frame, simply accessing and updating textures, values and other parameters before call. However, make sure not to
add new textures and values, otherwise it would require to recompile shader and might lead to VRAM leaks (if you would
end up having thousands of no more used shaders). If you don’t have a working texture at the time of first creating
that table, use `false` for missing texture value.

Note: if shader would fail to compile, a C++ exception will be triggered, terminating script completely (to prevent AC
from crashing, C++ exceptions halt Lua script that triggered them until script gets a full reload).

  Parameters:

  1. `params`: `{p1: vec2, p2: vec2, uv1: vec2, uv2: vec2, blendMode: render.BlendMode, async: boolean, cacheKey: number, defines: table, textures: table, values: table, directValuesExchange: boolean, shader: string}|`{p1` = vec2(0, 0), p2 = vec2(1, 1), blendMode = render.BlendMode.BlendAccurate, textures = {}, values = {}, shader = 'float4 main(PS_IN pin) {return float4(pin.Tex.x, pin.Tex.y, 0, 1);}'}` "Table with properties:\n- `p1` (`vec2`): Position of upper left corner relative to whole screen or canvas.\n- `p2` (`vec2`): Position of bottom right corner relative to whole screen or canvas.\n- `uv1` (`vec2`): Texture coordinates for upper left corner. Default value: `vec2(0, 0)`.\n- `uv2` (`vec2`): Texture coordinates for bottom right corner. Default value: `vec2(1, 1)`.\n- `blendMode` (`render.BlendMode`): Blend mode. Default value: `render.BlendMode.BlendAccurate`.\n- `async` (`boolean`): If set to `true`, drawing won’t occur until shader would be compiled in a different thread.\n- `cacheKey` (`number`): Optional cache key for compiled shader (caching will depend on shader source code, but not on included files, so make sure to change the key if included files have changed).\n- `defines` (`table`): Defines to pass to the shader, either boolean, numerical or string values (don’t forget to wrap complex expressions in brackets). False values won’t appear in code and true will be replaced with 1 so you could use `#ifdef` and `#ifndef` with them.\n- `textures` (`table`): Table with textures to pass to a shader. For textures, anything passable in `ui.image()` can be used (filename, remote URL, media element, extra canvas, etc.). If you don’t have a texture and need to reset bound one, use `false` for a texture value (instead of `nil`)\n- `values` (`table`): Table with values to pass to a shader. Values can be numbers, booleans, vectors, colors or 4×4 matrix. Values will be aligned automatically.\n- `directValuesExchange` (`boolean`): If you’re reusing table between calls instead of recreating it each time and pass `true` as this parameter, `values` table will be swapped with an FFI structure allowing to skip data copying step and achieve the best performance. Note: with this mode, you’ll have to transpose matrices manually.\n- `shader` (`string`): Shader code (format is HLSL, regular DirectX shader); actual code will be added into a template in “assettocorsa/extension/internal/shader-tpl/ui.fx”."

  Returns:

  - `boolean` Returns `false` if shader is not yet ready and no drawing occured (happens only if `async` is set to `true`).
## Function ui.beginSubgroup(offsetX)
Begins new group offset horizontally to the right, pushes item width to fill available space. Call `ui.endSubgroup()` when done.

  Parameters:

  1. `offsetX`: `number?` Default value: 20.
## Function ui.endSubgroup()
Ends group began with `ui.beginSubgroup()`.
function ui.endSubgroup() end
## Function ui.GIFPlayer(source)
GIF player can be used to display animated GIFs. Also supports regular and animated WEBP images.

  Parameters:

  1. `source`: `string|{width: number, height: number, decompress: boolean?}` URL, filename or binary data.

  Returns:

  - `ui.GIFPlayer`
## Class ui.GIFPlayer
GIF player can be used to display animated GIFs. Also supports regular and animated WEBP images.

- `ui.GIFPlayer:resolution()`

  Get GIF resolution. If GIF is not yet loaded, returns zeroes.

  Returns:

    - `vec2` Width and height in pixels.

- `ui.GIFPlayer:push(data)`

  Push new bitmap data to a live-updating image.

  Parameters:

    1. `data`: `binary`

  Returns:

    - `boolean` Returns `false` if data doesn’t fit.

- `ui.GIFPlayer:rewind()`

  Rewinds GIF back to beginning.

  Returns:

    - `boolean`

- `ui.GIFPlayer:ready()`

  Checks if GIF is loaded and ready to be drawn.

  Returns:

    - `boolean`

- `ui.GIFPlayer:valid()`

  Returns `false` if GIF decoding has failed.

  Returns:

    - `boolean`
## Function ui.SharedTexture(handle, ntMode)

  Parameters:

  1. `handle`: `integer` Shared texture handle. Can be either a `D3D11_RESOURCE_MISC_SHARED` handle or a handle from `:sharedHandle()` of an extra canvas.

  2. `ntMode`: `nil|integer|boolean?` Set to `true` if the handle is NT handle. Alternatively, set to an integer with source process ID. Default value: `false`. Note: for NT handles it’s better to use the named textures and pass it as a string instead (with the overload).

  Returns:

  - `ui.SharedTexture`
## Class ui.SharedTexture
A wrapper for accessing textures shared by other Lua scripts or even by other applications. For the latter, textures need to have `D3D11_RESOURCE_MISC_SHARED` flag and be on the same GPU.

- `ui.SharedTexture:dispose()`

  Dispose texture and release its view. Call this method if remote texture is being destroyed.
function _ui_SharedTexture:dispose() end

- `ui.SharedTexture:setName(name)`

  Sets texture name for debugging. Textures with set name appear in Lua Debug App, allowing to monitor their state.

  Parameters:

    1. `name`: `string?` Name to display texture as. If set to `nil` or `false`, name will be reset and texture will be hidden.

  Returns:

    - `self` Returns itself for chaining several methods together.

- `ui.SharedTexture:handle()`

  Get texture handle used for creating a texture. If texture has failed to load, returns 0. If texture is loaded by name and loaded properly, returns 1.

  Returns:

    - `integer`

- `ui.SharedTexture:resolution()`

  Get texture resolution. If texture has failed to load, returns zeroes.

  Returns:

    - `vec2` Width and height in pixels.

- `ui.SharedTexture:valid()`

  Returns `false` if access to a shared texture has failed.

  Returns:

    - `boolean`
## Function ui.captureKeyboard(wantCaptureKeyboard, wantCaptureText, globalInput)
Stops rest of Assetto Corsa from responding to keyboard events (key bindings, etc.), also sets `getUI().wantCaptureKeyboard` flag.
Note: if you writing a script reacting to general keyboard events, consider checking that flag to make sure IMGUI doesn’t have
keyboard captured currently.

Resulting structure is a good way to access keyboard input data, both the button events and characters being entered.

  Parameters:

  1. `wantCaptureKeyboard`: `boolean?` Default value: `true`.

  2. `wantCaptureText`: `boolean?` Default value: `false`.

  3. `globalInput`: `boolean?` Set to `true` to capture input from something like a script display. Default value: `false`.

  Returns:

  - `ui.CapturedKeyboard`
## Function ui.interactiveArea(id, size)
Similar to `ui.invisibleButton()`, but this one can be activated similar to text input and if it is active, will monitor keyboard state.

  Parameters:

  1. `id`: `string?` Default value: `'nil'`.

  2. `size`: `vec2?` Default value: `vec2(0, 0)`.

  Returns:

  1. `ui.CapturedKeyboard`

  2. `boolean` Set to `true` if area was just activated.
## Function ui.popup(callback, params)
Create a new popup. Function `callback()` will be called each frame to render its content until popup is closed. Pass `title` in parameters to create
a window instead (you can still call `ui.closePopup()` from the window to close it).

  Parameters:

  1. `callback`: `fun()`

  2. `params`: `{onClose: fun()?, position: vec2?, pivot: vec2?, size: vec2|{min: vec2?, max: vec2?, initial: vec2?}?, padding: vec2?, flags: ui.WindowFlags?, backgroundColor: rgbm?, title: string?, parentless: boolean?}?`
## Class ui.CapturedKeyboard

- `ui.CapturedKeyboard:queue()`

  Characters being typed. Automatically takes into account keyboard layout, held shift and all that stuff.

  Returns:

    - `string` Empty string if there were no characters.

- `ui.CapturedKeyboard:down(index)`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyCtrl(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyShift(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyAlt(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyCtrlShift(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyCtrlAlt(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`

- `ui.CapturedKeyboard:hotkeyCtrlShiftAlt(button)`

  Parameters:

    1. `button`: `ui.KeyIndex?`

  Returns:

    - `boolean`
## Function ui.UserIconsLayer(priority, column)
Creates a new layer with user icons. Use `carN::special::driver` to draw an icon of a driver in a certain car (replace N with 0-based car index).

  Parameters:

  1. `priority`: `integer` Layer with higher priority will be used.

  2. `column`: `number?` Column. If set, extra icons per user can be set. Columns are ordered from lowest to biggest. To get number of icon columns use `ac.getCar().extraIconsCount`. To draw an icon X, use `carN::special::driver::X`. Note: unlike main icons, those extra icons are not drawn in most parts of UI. New CSP UI only draws up to two extra icons per driver.

  Returns:

  - `fun`
## Function ui.itemRect()
Note: unlike `ui.itemRectMin()` and `ui.itemRectMax()`, this one returns references instead of creating new vectors. Be careful if you
are to call this function and reuse results after calling it again.

  Returns:

  1. `vec2`

  2. `vec2`
## Function ui.addSettings(params, callback)
Adds a new settings item in settings list in apps.

  Parameters:

  1. `params`: `{icon: ui.Icons, name: string, size: {default: vec2, min: vec2, max: vec2, automatic: nil|boolean}, id: string, padding: vec2, backgroundColor: rgbm, category: 'settings'|'main'|'developer'|nil, tags: string[]|nil, parent: string, onOpen: fun(), onClose: fun(), onMenu: fun(), onRemove: fun(), keepClosed: boolean}|`{icon` = ui.Icons.Settings, name = '', size = {default = vec2(), min = vec2(), max = vec2(), automatic = false}}` "Table with properties:\n- `icon` (`ui.Icons`): Settings icon.\n- `name` (`string`): Name of the settings item (name of a script by default).\n- `size` (`{default: vec2, min: vec2, max: vec2, automatic: nil|boolean}`): Size settings. Default size: `vec2(320, 240)`, default min size: `vec2(40, 20)`.\n- `id` (`string`): If specified, state of a window will be remembered across AC runs or Lua reloads.\n- `padding` (`vec2`): Custom padding for the window.\n- `backgroundColor` (`rgbm`): Custom background color for the window.\n- `category` (`'settings'|'main'|'developer'|nil`): Optionally, this function can be used for simply creating new apps.\n- `tags` (`string[]|nil`): Optional list of tags for search to find the app.\n- `parent` (`string`): ID of a parent window. If set, and parent window is found, `category` will be ignored.\n- `onOpen` (`fun()`): Callback called when the tool is opened.\n- `onClose` (`fun()`): Callback called when the tool is closed.\n- `onMenu` (`fun()`): Callback for extra items in context menu opening from taskbar.\n- `onRemove` (`fun()`): Callback called once when the tool is removed. If set, there will be an item for removing the tool in taskbar context menu.\n- `keepClosed` (`boolean`): Set to `true` to keep app closed even if it was opened before."

  2. `callback`: `fun()` Callback function to draw contents of the settings window.

  Returns:

  - `ac.Disposable|fun`
## Function ui.setNextTextSpanStyle(from, to, color, bold)

  Parameters:

  1. `from`: `integer` 1-based index, similar to string.sub().

  2. `to`: `integer` 1-based index, similar to string.sub().

  3. `color`: `rgbm|nil` Default value: `nil`.

  4. `bold`: `boolean|nil` Default value: `nil`.
## Function ui.inputTextCommand(command, argument, lookActive)

  Parameters:

  1. `command`: `'getSelected'|'getText'|'setText'|'keepStateOnEscape'|'suggest'|'selectAll'|'delete'|'undo'|'redo'|'paste'|'copy'|'cut'|''`

  2. `argument`: `string|number|boolean|nil` Default value: `nil`.

  3. `lookActive`: `boolean?` Default value: `true`.

  Returns:

  - `string`
## Function ui.drawPie(center, radius, angleFrom, angleTo, color, image)
Draw filled circle (if `angleTo - angleFrom ≥ 2π`) or its sector. Optionally textured.

  Parameters:

  1. `center`: `vec2` Center of the circle.

  2. `radius`: `number` Circle radius.

  3. `angleFrom`: `number` Starting angle in radians.

  4. `angleTo`: `number` Ending angle in radians.

  5. `color`: `rgb|rgbm?` Color. Default value: `rgbm.colors.white`.

  6. `image`: `ui.ImageSource` Optional background image.
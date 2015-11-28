package abv.cpu;

#if neko
typedef Mutex = neko.vm.Mutex;
#elseif cpp
typedef Mutex = cpp.vm.Mutex;
#elseif java
typedef Mutex = java.vm.Mutex;
#elseif flash
typedef Mutex = flash.concurrent.Mutex;
#end

// abv.cpu.Mutex


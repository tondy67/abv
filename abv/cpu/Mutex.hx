package abv.cpu;

#if neko
typedef Mutex = neko.vm.Mutex;
#elseif cpp
typedef Mutex = cpp.vm.Mutex;
#end

// abv.cpu.Mutex


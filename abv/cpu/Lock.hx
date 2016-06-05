package abv.cpu;

#if neko
typedef Lock = neko.vm.Lock;
#elseif cpp
typedef Lock = cpp.vm.Lock;
#elseif java
typedef Lock = java.vm.Lock;
#end

// abv.cpu.Lock


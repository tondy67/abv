package abv.cpu;
/**
 * Thread
 **/
#if neko
typedef Thread = neko.vm.Thread;
#elseif cpp
typedef Thread = cpp.vm.Thread;
#end 

// abv.cpu.Thread


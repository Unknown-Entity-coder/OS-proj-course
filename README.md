This project integrates the SHA256 hashing algorithm into the xv6 operating system. The implementation spans user space, kernel space, and a custom system call. Below are the details of each component:

1) User Space Implementation
To run the user space SHA256 hashing:

bash
Copy code
$ sha256 sample.txt  
This command hashes the contents of sample.txt.
The resulting hash and the number of clock ticks taken are displayed as output.
2) Kernel Space Implementation
The kernel space SHA256 implementation executes automatically during each system boot.
A hard-coded value is hashed, and both the hash and the ticks count are printed during the boot process.
3) System Call Implementation
To use the custom SHA256 system call:

bash
Copy code
$ sha_syscall <text_to_hash>  
This program invokes the SHA256 system call and hashes the provided argument (<text_to_hash>).
The hash result and the ticks count are displayed as output.

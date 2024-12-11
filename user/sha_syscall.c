#include "kernel/types.h"
#include "user/user.h"
#include "kernel/syscall.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Pass an argument!\n\n");
        exit(1);
    }

    // Print the arguments received
    printf("Arguments received:\n");
    for (int i = 1; i < argc; i++) {
        printf("Argument %d: %s\n\n", i, argv[i]);
    }

    // Call the SHA-256 system call with the user-provided string
    int start_time = time();
    
                      get_sha256(argv[1]);
                      
int end_time = time();

int final_time = end_time - start_time;

printf("\nComputed in Ticks =  %d\n", final_time);
    
   

    exit(0);
}


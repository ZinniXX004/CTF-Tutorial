#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char* FLAG = "CTF{buffer_overflow_ez}";

void print_header() {
    printf("========================================\n");
    printf("      SECURE VAULT SYSTEM v2.0 (PATCHED)\n");
    printf("========================================\n");
}

void granted() {
    printf("\n[+] ACCESS GRANTED. Welcome, Admin.\n");
    printf("[*] The secret is: %s\n", FLAG);
    fflush(stdout);
}

void denied() {
    printf("\n[-] ACCESS DENIED. Intruder detected.\n");
    fflush(stdout);
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);

    struct {
        char buffer[64];
        volatile int is_admin; 
    } user;

    user.is_admin = 0; 

    print_header();
    
    printf("[DEBUG] 'buffer' is at: %p\n", (void*)user.buffer);
    printf("[DEBUG] 'is_admin' is at: %p\n", (void*)&user.is_admin);
    
    printf("\nEnter Password: "); 
   
    if (fgets(user.buffer, sizeof(user.buffer), stdin) == NULL) {
        return 1; // Error reading
    }
    
    // Remove newline character if present (fgets includes it)
    user.buffer[strcspn(user.buffer, "\n")] = 0;

    // ----------------

    // This check is now safe because 'user.buffer' cannot overflow into 'user.is_admin'
    if (user.is_admin != 0) {
        granted();
    } else {
        denied();
    }

    return 0;
}

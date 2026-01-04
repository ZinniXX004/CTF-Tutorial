#define _CRT_SECURE_NO_WARNINGS // Allow unsafe functions
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// On Windows, unistd.h doesn't exist by default, but don't need it strictly here
// If you need sleep(), use <windows.h> and Sleep()

const char* FLAG = "CTF{buffer_overflow_ez}";

void print_header() {
    printf("========================================\n");
    printf("      SECURE VAULT SYSTEM v1.0          \n");
    printf("========================================\n");
}

void granted() {
    printf("\n[+] ACCESS GRANTED. Welcome, Admin.\n");
    printf("[*] The secret is: %s\n", FLAG);
    printf("========================================\n");
    fflush(stdout); // Force output to appear immediately
}

void denied() {
    printf("\n[-] ACCESS DENIED. Intruder detected.\n");
    printf("========================================\n");
    fflush(stdout);
}

int main() {
    // Disable buffering so Python captures output immediately
    setvbuf(stdout, NULL, _IONBF, 0);

    struct {
        char buffer[64];
        volatile int is_admin; 
    } user;

    user.is_admin = 0; 

    print_header();
    
    // Use %p for pointers. On 64-bit Windows, this will look like 000000FAKEADDRESS
    printf("[DEBUG] 'buffer' is at: %p\n", (void*)user.buffer);
    printf("[DEBUG] 'is_admin' is at: %p\n", (void*)&user.is_admin);
    printf("[DEBUG] Current Admin Level: %d\n", user.is_admin);
    
    printf("\nEnter Password: ");
    
    // WARNING: 'gets' reads until newline
    // If MinGW complains too much, we will write a custom unsafe function
    gets(user.buffer); 

    if (user.is_admin != 0) {
        granted();
    } else {
        denied();
    }

    return 0;
}

#include <cstddef>

// This program just wastes a defined amount of memory and keeps 1 core busy
int main(int argc, char** argv) {
	
	// Create a 512MB array of bytes
	const std::size_t SIZE = 512 * 1024 * 1024;
	unsigned char *arr = new unsigned char[SIZE];
	
	// Loop forever setting bytes in the array
	while (true) {
		for(std::size_t i = 0; i < SIZE; i++) {
			arr[i] += i % 256;
		}
	}
	
	// Won't normally get here. No need to free the array as this will automatically
	// get cleaned on program exit (e.g. ctrl-c)
	return 0;
}

#include <stdlib.h>
#include <stdio.h>

#include <Windows.h>
#include <Unknwn.h>

int main(int argc, char* argv[])
{
	const int size = sizeof(IUnknown);
	const auto v = E_ABORT;

	void* ptr = CoCreateInstance;

	return EXIT_SUCCESS;
}

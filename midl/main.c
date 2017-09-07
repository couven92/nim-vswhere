#include <Windows.h>
#include <stdio.h>

#include "Setup.Configuration_h.h"

#ifndef UNREFERENCED_PARAMETER
#define UNREFERENCED_PARAMETER(x) (x)
#endif // !UNREFERENCED_PARAMETER

static void print_error(HRESULT hr)
{
	char hr_message[1000];
	DWORD hr_message_len = FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, NULL, hr, 0, hr_message, sizeof(hr_message) / sizeof(hr_message[0]), NULL);
	fprintf(stderr, "%*.*s", (int)hr_message_len, sizeof(hr_message) / sizeof(hr_message[0]), hr_message);
}

int main(int argc, char* argv[])
{
	IID IID_ISetupConfiguration_local;
	IID IID_ISetupConfiguration2_local;
	CLSID CLSID_SetupConfiguration;
	HRESULT hr;
	ISetupConfiguration* setupConfiguration;
	ISetupConfiguration2* setupConfiguration2;

	UNREFERENCED_PARAMETER(argc);
	UNREFERENCED_PARAMETER(argv);

#define HRESULT_CHECKED(x) hr = x; if FAILED(hr) goto error
	HRESULT_CHECKED(CLSIDFromString(OLESTR("{177F0C4A-1CD3-4DE7-A32C-71DBBB9FA36D}"), &CLSID_SetupConfiguration));
	HRESULT_CHECKED(IIDFromString(OLESTR("{42843719-DB4C-46C2-8E7C-64F1816EFD5B}"), &IID_ISetupConfiguration_local));
	HRESULT_CHECKED(IIDFromString(OLESTR("{26AAB78C-4A60-49D6-AF3B-3C35BC93365D}"), &IID_ISetupConfiguration2_local));
	HRESULT_CHECKED(CoInitialize(NULL));

#define printf_instance(type, instance) printf("%s: %s (0x%p)\n", #instance, #type, instance);
#define printf_field(pInstance, vtblType, member) printf("\t[%02d] 0x%p: %s\n", offsetof(vtblType, member), pInstance->lpVtbl->member, #member)

	HRESULT_CHECKED(CoCreateInstance(&CLSID_SetupConfiguration, NULL, CLSCTX_INPROC, &IID_ISetupConfiguration_local, &setupConfiguration));
	printf_instance(ISetupConfiguration*, setupConfiguration);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, QueryInterface);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, AddRef);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, Release);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, EnumInstances);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, GetInstanceForCurrentProcess);
	printf_field(setupConfiguration, ISetupConfigurationVtbl, GetInstanceForPath);

	HRESULT_CHECKED(setupConfiguration->lpVtbl->QueryInterface(setupConfiguration, &IID_ISetupConfiguration2_local, &setupConfiguration2));
	printf_instance(ISetupConfiguration2*, setupConfiguration);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, QueryInterface);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, AddRef);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, Release);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, EnumInstances);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, GetInstanceForCurrentProcess);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, GetInstanceForPath);
	printf_field(setupConfiguration2, ISetupConfiguration2Vtbl, EnumAllInstances);

	return EXIT_SUCCESS;

error:
	print_error(hr);
	return EXIT_FAILURE;
}
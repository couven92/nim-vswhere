import windowssdk / importc_windowssdk
import windowssdk / shared / guiddef
import windowssdk / um / unknwn
import windowssdk / um / winnt

type InstanceState* = enum
  ## The state of an instance.
  eNone = 0             ## The instance state has not been determined.
  eLocal = 1            ## The instance installation path exists.
  eRegistered = 2       ## A product is registered to the instance.
  eNoRebootRequired = 4 ## No reboot is required for the instance.
  eNoErrors = 8         ## No errors were reported for the instance.
  eComplete = 0xffff    ## The instance represents a complete install.

whenUseWindowsSdk:
  {.importc: "IID_ISetupInstance".}
  const iid_ISetupInstance*: Iid = Iid(data1: 0xB41463C3'u32, data2: 0x8866, data3: 0x43B5, data4: [0xBC'u8, 0x33'u8, 0x2B'u8, 0x06'u8, 0x76'u8, 0xF7'u8, 0xF4'u8, 0x2E'u8])
type
  ISetupInstanceVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getInstanceId: proc(pbstrInstanceId: pointer): HResult {.stdcall.}
  ISetupInstance* = object
    lpVtbl: ptr ISetupInstanceVtbl
converter toIUnknown*(x: ptr ISetupInstance): ptr IUnknown =
  cast[ptr IUnknown](x)

type
  ISetupInstance2Vtbl = object
    vtbl_ISetupInstance: ISetupInstanceVtbl
  ISetupInstance2* = object
    lpVtbl: ptr ISetupInstance2Vtbl
converter toISetupInstance*(x: ptr ISetupInstance2): ptr ISetupInstance =
  cast[ptr ISetupInstance](x)

whenUseWindowsSdk:
  {.importc: "IID_IEnumSetupInstances".}
  const iid_IEnumSetupInstances*: Iid = Iid(data1: 0x6380BCFF'u32, data2: 0x41D3, data3: 0x4B2E, data4: [0x8B'u8, 0x2E'u8, 0xBF'u8, 0x8A'u8, 0x68'u8, 0x10'u8, 0xC8'u8, 0x48'u8])
type
  IEnumSetupInstancesVtbl = object
    vtbl_IUnknown: IUnknownVtbl
  IEnumSetupInstances* = object
    lpVtbl: ptr IEnumSetupInstancesVtbl
converter toIUnknown*(x: ptr IEnumSetupInstances): ptr IUnknown =
  cast[ptr IUnknown](x)

whenUseWindowsSdk:
  {.importc: "IID_ISetupConfiguration".}
  const iid_ISetupConfiguration*: Iid = Iid(data1: 0x42843719'u32, data2: 0xDB4C, data3: 0x46C2, data4: [0x8E'u8, 0x7C'u8, 0x64'u8, 0xF1'u8, 0x81'u8, 0x6E'u8, 0xFD'u8, 0x5B'u8])
type
  ISetupConfigurationVtbl = object
    vtbl_IUnknown: IUnknownVtbl
  ISetupConfiguration* = object
    lpVtbl: ptr ISetupConfigurationVtbl
converter toIUnknown*(x: ptr ISetupConfiguration): ptr IUnknown =
  cast[ptr IUnknown](x)

whenUseWindowsSdk:
  {.importc: "IID_ISetupConfiguration2".}
  const iid_ISetupConfiguration2*: Iid = Iid(data1: 0x26AAB78C'u32, data2: 0x4A60, data3: 0x49D6, data4: [0xAF'u8, 0x3B'u8, 0x3C'u8, 0x35'u8, 0xBC'u8, 0x93'u8, 0x36'u8, 0x5D'u8])
type
  ISetupConfiguration2Vtbl = object
    vtbl_ISetupConfiguration: ISetupConfigurationVtbl
  ISetupConfiguration2* = object
    lpVtbl: ptr ISetupConfiguration2Vtbl
converter toISetupConfiguration*(x: ptr ISetupConfiguration2): ptr ISetupConfiguration =
  cast[ptr ISetupConfiguration](x)

whenUseWindowsSdk:
  {.importc: "IID_ISetupPackageReference".}
  const iid_ISetupPackageReference*: Iid = Iid(data1: 0xda8d8a16'u32, data2: 0xb2b6, data3: 0x4487, data4: [0xa2'u8, 0xf1'u8, 0x59'u8, 0x4c'u8, 0xcc'u8, 0xcd'u8, 0x6b'u8, 0xf5'u8])
type
  ISetupPackageReferenceVtbl = object
    vtbl_IUnknown: IUnknownVtbl
  ISetupPackageReference* = object
    lpVtbl: ptr ISetupPackageReferenceVtbl
converter toISetupConfiguration*(x: ptr ISetupPackageReference): ptr IUnknown =
  cast[ptr IUnknown](x)

whenUseWindowsSdk:
  {.importc: "IID_ISetupHelper".}
  const iid_ISetupHelper*: Iid = Iid(data1: 0x42b21b78'u32, data2: 0x6192, data3: 0x463e, data4: [0x87'u8, 0xbf'u8, 0xd5'u8, 0x77'u8, 0x83'u8, 0x8f'u8, 0x1d'u8, 0x5c'u8])
type
  ISetupHelperVtbl = object
    vtbl_IUnknown: IUnknownVtbl
  ISetupHelper* = object
    lpVtbl: ptr ISetupHelperVtbl
converter toISetupConfiguration*(x: ptr ISetupHelper): ptr IUnknown =
  cast[ptr IUnknown](x)

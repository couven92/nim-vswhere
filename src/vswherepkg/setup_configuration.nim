import windowssdk / importc_windowssdk
import windowssdk / shared / guiddef
import windowssdk / shared / winerror
import windowssdk / um / unknwn
import windowssdk / um / winnt

import os, dynlib

type InstanceState* {.size: sizeof(int32).} = enum
  ## The state of an instance.
  eNone = 0             ## The instance state has not been determined.
  eLocal = 1            ## The instance installation path exists.
  eRegistered = 2       ## A product is registered to the instance.
  eNoRebootRequired = 4 ## No reboot is required for the instance.
  eNoErrors = 8         ## No errors were reported for the instance.
  eComplete = 0xffff    ## The instance represents a complete install.

const
  iid_ISetupInstance* = newIid("B41463C3-8866-43B5-BC33-2B0676F7F42E")
  iid_ISetupInstance2* = newIid("89143C9A-05AF-49B0-B717-72E218A2185C")
  iid_ISetupInstanceCatalog* = newIid("9AD8E40F-39A2-40F1-BF64-0A6C50DD9EEB")
  iid_ISetupLocalizedProperties* = newIid("F4BD7382-FE27-4AB4-B974-9905B2A148B0")
  iid_IEnumSetupInstances* = newIid("6380BCFF-41D3-4B2E-8B2E-BF8A6810C848")
  iid_ISetupConfiguration* = newIid("42843719-DB4C-46C2-8E7C-64F1816EFD5B")
  iid_ISetupConfiguration2* = newIid("26AAB78C-4A60-49D6-AF3B-3C35BC93365D")
  iid_ISetupPackageReference* = newIid("da8d8a16-b2b6-4487-a2f1-594ccccd6bf5")
  iid_ISetupHelper* = newIid("42b21b78-6192-463e-87bf-d577838f1d5c")
  iid_ISetupErrorState* = newIid("46DCCD94-A287-476A-851E-DFBC2FFDBC20")
  iid_ISetupErrorState2* = newIid("9871385B-CA69-48F2-BC1F-7A37CBF0B1EF")
  iid_ISetupFailedPackageReference* = newIid("E73559CD-7003-4022-B134-27DC650B280F")
  iid_ISetupFailedPackageReference2* = newIid("0FAD873E-E874-42E3-B268-4FE2F096B9CA")
  iid_ISetupPropertyStore* = newIid("C601C175-A3BE-44BC-91F6-4568D230FC83")
  iid_ISetupLocalizedPropertyStore* = newIid("5BB53126-E0D5-43DF-80F1-6B161E5C6F6C")

  clsid_SetupConfiguration* = newClsId("177F0C4A-1CD3-4DE7-A32C-71DBBB9FA36D")

type
  ISetupInstanceVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getInstanceId: proc(pbstrInstanceId: pointer): HResult {.stdcall.}
    getInstallDate: proc(pInstallDate: var uint64): HResult {.stdcall.}
    getInstallationName: proc(pbstrInstallationName: var pointer): HResult {.stdcall.}
    getInstallationPath: proc(pbstrInstallationPath: var pointer): HResult {.stdcall.}
    getInstallationVersion: proc(pbstrInstallationVersion: var pointer): HResult {.stdcall.}
    getDisplayName: proc(lcid: uint32, pbstrDisplayName: var pointer): HResult {.stdcall.}
    getDescription: proc(lcid: uint32, pbstrDescription: var pointer): HResult {.stdcall.}
    resolvePath: proc(pwszRelativePath: pointer, pbstrAbsolutePath: var pointer): HResult {.stdcall.}
  ISetupInstance* = object
    lpVtbl: ptr ISetupInstanceVtbl

  ISetupInstance2Vtbl = object
    vtbl_ISetupInstance: ISetupInstanceVtbl
    getState: proc(pState: var InstanceState): HResult {.stdcall.}
    getPackages: proc(ppsaPackages: var pointer): HResult {.stdcall.}
    getProduct: proc(ppPackage: var ptr ISetupPackageReference): HResult {.stdcall.}
    getProductPath: proc(pbstrProductPath: var pointer): HResult {.stdcall.}
    getErrors: proc(ppErrorState: var ptr ISetupErrorState): HResult {.stdcall.}
    isLaunchable: proc(pfIsLaunchable: var int16): HResult {.stdcall.}
    isComplete: proc(pfIsComplete: var int16): HResult {.stdcall.}
    getProperties: proc(ppProperties: var ptr ISetupPropertyStore): HResult {.stdcall.}
    getEnginePath: proc(pbstrEnginePath: var pointer): HResult {.stdcall.}
  ISetupInstance2* = object
    lpVtbl: ptr ISetupInstance2Vtbl

  ISetupInstanceCatalogVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getCatalogInfo: proc(ppCatalogInfo: var ptr ISetupPropertyStore): HResult {.stdcall.}
    isPrerelease: proc(pfIsPrerelease: var int16): HResult {.stdcall.}
  ISetupInstanceCatalog* = object
    lpVtbl: ptr ISetupInstanceCatalogVtbl

  ISetupLocalizedPropertiesVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getLocalizedProperties: proc(ppLocalizedProperties: var ptr ISetupLocalizedPropertyStore): HResult {.stdcall.}
    getLocalizedChannelProperties: proc(ppLocalizedChannelProperties: var ptr ISetupLocalizedPropertyStore): HResult {.stdcall.}
  ISetupLocalizedProperties* = object
    lpVtbl: ptr ISetupLocalizedPropertiesVtbl

  IEnumSetupInstancesVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    next: proc(celt: uint32, rgelt: ptr ptr ISetupInstance, pceltFetched: var uint32): HResult {.stdcall.}
    skip: proc(celt: uint32): HResult {.stdcall.}
    reset: proc(): HResult {.stdcall.}
    clone: proc(ppenum: var ptr IEnumSetupInstances): HResult {.stdcall.}
  IEnumSetupInstances* = object
    lpVtbl: ptr IEnumSetupInstancesVtbl
  
  ISetupConfigurationVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    enumInstances: proc(ppEnumInstances: var ptr IEnumSetupInstances): HResult {.stdcall.}
    getInstanceForCurrentProcess: proc(ppInstance: var ptr ISetupInstance): HResult {.stdcall.}
    getInstanceForPath: proc(wzPath: WideCString, ppInstance: var ptr ISetupInstance): HResult {.stdcall.}
  ISetupConfiguration* = object
    lpVtbl: ptr ISetupConfigurationVtbl

  ISetupConfiguration2Vtbl = object
    vtbl_ISetupConfiguration: ISetupConfigurationVtbl
    enumAllInstances: proc(ppEnumInstances: var ptr IEnumSetupInstances): HResult {.stdcall.}
  ISetupConfiguration2* = object
    lpVtbl: ptr ISetupConfiguration2Vtbl

  ISetupPackageReferenceVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getId: proc(pbstrId: var pointer): HResult {.stdcall.}
    getVersion: proc(pbstrVersion: var pointer): HResult {.stdcall.}
    getChip: proc(pbstrChip: var pointer): HResult {.stdcall.}
    getLanguage: proc(pbstrLanguage: var pointer): HResult {.stdcall.}
    getBranch: proc(pbstrBranch: var pointer): HResult {.stdcall.}
    getType: proc(pbstrType: var pointer): HResult {.stdcall.}
    getUniqueId: proc(pbstrUniqueId: var pointer): HResult {.stdcall.}
    getIsExtension: proc(pbstrIsExtension: var int16): HResult {.stdcall.}
  ISetupPackageReference* = object
    lpVtbl: ptr ISetupPackageReferenceVtbl
    
  ISetupHelperVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    parseVersion: proc(pwszVersion: pointer, pullVersion: var uint64): HResult {.stdcall.}
    parseVersionRange: proc(pwszVersionRange: pointer, pullMinVersion, pullMaxVersion: var uint64): HResult {.stdcall.}
  ISetupHelper* = object
    lpVtbl: ptr ISetupHelperVtbl

  ISetupErrorStateVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getFailedPackages: proc(ppsaFailedPackages: var pointer): HResult {.stdcall.}
    getSkippedPackages: proc(ppsaSkippedPackages: var pointer): HResult {.stdcall.}
  ISetupErrorState* = object
    lpVtbl: ptr ISetupErrorStateVtbl

  ISetupErrorState2Vtbl = object
    vtbl_ISetupErrorState: ISetupErrorStateVtbl
    getErrorLogFilePath: proc(pbstrErrorLogFilePath: var pointer): HResult {.stdcall.}
    getLogFilePath: proc(pbstrLogFilePath: var pointer): HResult {.stdcall.}
  ISetupErrorState2* = object
    lpVtbl: ptr ISetupErrorState2Vtbl

  ISetupFailedPackageReferenceVtbl = object
    vtbl_ISetupPackageReference: ISetupPackageReferenceVtbl
  ISetupFailedPackageReference* = object
    lpVtbl: ptr ISetupFailedPackageReferenceVtbl

  ISetupFailedPackageReference2Vtbl = object
    vtbl_ISetupFailedPackageReference: ISetupFailedPackageReferenceVtbl
    getLogFilePath: proc(pbstrLogFilePath: var pointer): HResult {.stdcall.}
    getDescription: proc(pbstrDescription: var pointer): HResult {.stdcall.}
    getSignature: proc(pbstrSignature: var pointer): HResult {.stdcall.}
    getDetails: proc(ppsaDetails: var pointer): HResult {.stdcall.}
    getAffectedPackages: proc(ppsaAffectedPackages: var pointer): HResult {.stdcall.}
  ISetupFailedPackageReference2* = object
    lpVtbl: ptr ISetupFailedPackageReference2Vtbl

  ISetupPropertyStoreVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getNames: proc(ppsaNames: var pointer): HResult {.stdcall.}
    getValue: proc(pwszName: pointer, pvtValue: var pointer): HResult {.stdcall.}
  ISetupPropertyStore* = object
    lpVtbl: ptr ISetupPropertyStoreVtbl
  
  ISetupLocalizedPropertyStoreVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getNames: proc(lcid: uint32, ppsaNames: var pointer): HResult {.stdcall.}
    getValue: proc(pwszName: pointer, lcid: uint32, pvtValue: var pointer): HResult {.stdcall.}
  ISetupLocalizedPropertyStore* = object
    lpVtbl: ptr ISetupLocalizedPropertyStoreVtbl

converter toIUnknown*(x: ptr ISetupInstance): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toISetupInstance*(x: ptr ISetupInstance2): ptr ISetupInstance =
  cast[ptr ISetupInstance](x)
converter toIUnknown*(x: ptr IEnumSetupInstances): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toIUnknown*(x: ptr ISetupConfiguration): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toISetupConfiguration*(x: ptr ISetupConfiguration2): ptr ISetupConfiguration =
  cast[ptr ISetupConfiguration](x)
converter toIUnknown*(x: ptr ISetupConfiguration2): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toISetupConfiguration*(x: ptr ISetupPackageReference): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toISetupConfiguration*(x: ptr ISetupHelper): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toIUnknown*(x: ptr ISetupErrorState): ptr IUnknown =
  cast[ptr IUnknown](x)
converter toISetupPackageReference*(x: ptr ISetupFailedPackageReference): ptr ISetupPackageReference =
  cast[ptr ISetupPackageReference](x)
converter toIUnknown*(x: ptr ISetupPropertyStore): ptr IUnknown =
  cast[ptr IUnknown](x)

proc next*(this: ptr IEnumSetupInstances, rgelt: var openarray[ptr ISetupInstance], pceltFetched: var uint32): HResult =
  this.lpVtbl.next(len(rgelt).uint32, addr(rgelt[0]), pceltFetched)
proc next*(this: ptr IEnumSetupInstances, pSetupInstance: var ptr ISetupInstance): HResult =
  var
    rgelt: array[1, ptr ISetupInstance]
    celtFetched: uint32
  result = next(this, rgelt, celtFetched)
  pSetupInstance = rgelt[0]
proc next*(this: ptr IEnumSetupInstances): ptr ISetupInstance =
  let hr = next(this, result)
  if hr == s_false: result = nil
  elif hr.failed: raiseOSError(hr)
proc skip*(this: ptr IEnumSetupInstances, count: uint32): HResult =
  this.lpVtbl.skip(count)
proc reset_HResult*(this: ptr IEnumSetupInstances): HResult =
  this.lpVtbl.reset()
proc reset*(this: ptr IEnumSetupInstances) =
  let hr = reset_HResult(this)
  if hr.failed: raiseOSError(hr)
proc clone*(this: ptr IEnumSetupInstances, ppenum: var ptr IEnumSetupInstances): HResult =
  this.lpVtbl.clone(ppenum)
proc clone*(this: ptr IEnumSetupInstances): ptr IEnumSetupInstances =
  let hr = clone(this, result)
  if hr.failed: raiseOSError(hr)
iterator items*(this: ptr IEnumSetupInstances): ptr ISetupInstance =
  var
    value: ptr ISetupInstance
  while true:
    let hr = next(this, value)
    if hr == s_false: break
    elif hr.failed: raiseOSError(hr)
    yield value

proc enumInstances*(this: ptr ISetupConfiguration, ppEnumInstances: var ptr IEnumSetupInstances): HResult =
  this.lpVtbl.enumInstances(ppEnumInstances)
proc enumInstances*(this: ptr ISetupConfiguration): ptr IEnumSetupInstances =
  let hr = enumInstances(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstanceForCurrentProcess*(this: ptr ISetupConfiguration, ppInstance: var ptr ISetupInstance): HResult =
  this.lpVtbl.getInstanceForCurrentProcess(ppInstance)
proc getInstanceForCurrentProcess*(this: ptr ISetupConfiguration): ptr ISetupInstance =
  let hr = getInstanceForCurrentProcess(this, result)
  if hr.failed: raiseOSError(hr)

proc enumAllInstances*(this: ptr ISetupConfiguration2, ppEnumInstances: var ptr IEnumSetupInstances): HResult =
  this.lpVtbl.enumAllInstances(ppEnumInstances)
proc enumAllInstances*(this: ptr ISetupConfiguration2): ptr IEnumSetupInstances =
  let hr = enumAllInstances(this, result)
  if hr.failed: raiseOSError(hr)

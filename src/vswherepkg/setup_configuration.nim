import windowssdk / importc_windowssdk
import windowssdk / shared / guiddef
import windowssdk / shared / winerror
import windowssdk / shared / wtypes
import windowssdk / shared / wtypesbase
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
    getInstanceId: proc(this: ptr ISetupInstance, pbstrInstanceId: var WideCString): HResult {.stdcall.}
    getInstallDate: proc(this: ptr ISetupInstance, pInstallDate: var Filetime): HResult {.stdcall.}
    getInstallationName: proc(this: ptr ISetupInstance, pbstrInstallationName: var WideCString): HResult {.stdcall.}
    getInstallationPath: proc(this: ptr ISetupInstance, pbstrInstallationPath: var WideCString): HResult {.stdcall.}
    getInstallationVersion: proc(this: ptr ISetupInstance, pbstrInstallationVersion: var WideCString): HResult {.stdcall.}
    getDisplayName: proc(this: ptr ISetupInstance, lcid: Lcid, pbstrDisplayName: var WideCString): HResult {.stdcall.}
    getDescription: proc(this: ptr ISetupInstance, lcid: Lcid, pbstrDescription: var WideCString): HResult {.stdcall.}
    resolvePath: proc(this: ptr ISetupInstance, pwszRelativePath: WideCString, pbstrAbsolutePath: var WideCString): HResult {.stdcall.}
  ISetupInstance* = object
    lpVtbl: ptr ISetupInstanceVtbl

  ISetupInstance2Vtbl = object
    vtbl_ISetupInstance: ISetupInstanceVtbl
    getState: proc(this: ptr ISetupInstance2, pState: var InstanceState): HResult {.stdcall.}
    getPackages: proc(this: ptr ISetupInstance2, ppsaPackages: var pointer): HResult {.stdcall.}
    getProduct: proc(this: ptr ISetupInstance2, ppPackage: var ptr ISetupPackageReference): HResult {.stdcall.}
    getProductPath: proc(this: ptr ISetupInstance2, pbstrProductPath: var WideCString): HResult {.stdcall.}
    getErrors: proc(this: ptr ISetupInstance2, ppErrorState: var ptr ISetupErrorState): HResult {.stdcall.}
    isLaunchable: proc(this: ptr ISetupInstance2, pfIsLaunchable: var Variant_Bool): HResult {.stdcall.}
    isComplete: proc(this: ptr ISetupInstance2, pfIsComplete: var Variant_Bool): HResult {.stdcall.}
    getProperties: proc(this: ptr ISetupInstance2, ppProperties: var ptr ISetupPropertyStore): HResult {.stdcall.}
    getEnginePath: proc(this: ptr ISetupInstance2, pbstrEnginePath: var WideCString): HResult {.stdcall.}
  ISetupInstance2* = object
    lpVtbl: ptr ISetupInstance2Vtbl

  ISetupInstanceCatalogVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getCatalogInfo: proc(this: ptr ISetupInstanceCatalog, ppCatalogInfo: var ptr ISetupPropertyStore): HResult {.stdcall.}
    isPrerelease: proc(this: ptr ISetupInstanceCatalog, pfIsPrerelease: var Variant_Bool): HResult {.stdcall.}
  ISetupInstanceCatalog* = object
    lpVtbl: ptr ISetupInstanceCatalogVtbl

  ISetupLocalizedPropertiesVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getLocalizedProperties: proc(this: ptr ISetupLocalizedProperties, ppLocalizedProperties: var ptr ISetupLocalizedPropertyStore): HResult {.stdcall.}
    getLocalizedChannelProperties: proc(this: ptr ISetupLocalizedProperties, ppLocalizedChannelProperties: var ptr ISetupLocalizedPropertyStore): HResult {.stdcall.}
  ISetupLocalizedProperties* = object
    lpVtbl: ptr ISetupLocalizedPropertiesVtbl

  IEnumSetupInstancesVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    next: proc(this: ptr IEnumSetupInstances, celt: uint32, rgelt: ptr ptr ISetupInstance, pceltFetched: var uint32): HResult {.stdcall.}
    skip: proc(this: ptr IEnumSetupInstances, celt: uint32): HResult {.stdcall.}
    reset: proc(this: ptr IEnumSetupInstances): HResult {.stdcall.}
    clone: proc(this: ptr IEnumSetupInstances, ppenum: var ptr IEnumSetupInstances): HResult {.stdcall.}
  IEnumSetupInstances* = object
    lpVtbl: ptr IEnumSetupInstancesVtbl
  
  ISetupConfigurationVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    enumInstances: proc(this: ptr ISetupConfiguration, ppEnumInstances: var ptr IEnumSetupInstances): HResult {.stdcall.}
    getInstanceForCurrentProcess: proc(this: ptr ISetupConfiguration, ppInstance: var ptr ISetupInstance): HResult {.stdcall.}
    getInstanceForPath: proc(this: ptr ISetupConfiguration, wzPath: WideCString, ppInstance: var ptr ISetupInstance): HResult {.stdcall.}
  ISetupConfiguration* = object
    lpVtbl: ptr ISetupConfigurationVtbl

  ISetupConfiguration2Vtbl = object
    vtbl_ISetupConfiguration: ISetupConfigurationVtbl
    enumAllInstances: proc(this: ptr ISetupConfiguration2, ppEnumInstances: var ptr IEnumSetupInstances): HResult {.stdcall.}
  ISetupConfiguration2* = object
    lpVtbl: ptr ISetupConfiguration2Vtbl

  ISetupPackageReferenceVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getId: proc(this: ptr ISetupPackageReference, pbstrId: var WideCString): HResult {.stdcall.}
    getVersion: proc(this: ptr ISetupPackageReference, pbstrVersion: var WideCString): HResult {.stdcall.}
    getChip: proc(this: ptr ISetupPackageReference, pbstrChip: var WideCString): HResult {.stdcall.}
    getLanguage: proc(this: ptr ISetupPackageReference, pbstrLanguage: var WideCString): HResult {.stdcall.}
    getBranch: proc(this: ptr ISetupPackageReference, pbstrBranch: var WideCString): HResult {.stdcall.}
    getType: proc(this: ptr ISetupPackageReference, pbstrType: var WideCString): HResult {.stdcall.}
    getUniqueId: proc(this: ptr ISetupPackageReference, pbstrUniqueId: var WideCString): HResult {.stdcall.}
    getIsExtension: proc(this: ptr ISetupPackageReference, pbstrIsExtension: var Variant_Bool): HResult {.stdcall.}
  ISetupPackageReference* = object
    lpVtbl: ptr ISetupPackageReferenceVtbl
    
  ISetupHelperVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    parseVersion: proc(this: ptr ISetupHelper, pwszVersion: pointer, pullVersion: var uint64): HResult {.stdcall.}
    parseVersionRange: proc(this: ptr ISetupHelper, pwszVersionRange: pointer, pullMinVersion, pullMaxVersion: var uint64): HResult {.stdcall.}
  ISetupHelper* = object
    lpVtbl: ptr ISetupHelperVtbl

  ISetupErrorStateVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getFailedPackages: proc(this: ptr ISetupErrorState, ppsaFailedPackages: var pointer): HResult {.stdcall.}
    getSkippedPackages: proc(this: ptr ISetupErrorState, ppsaSkippedPackages: var pointer): HResult {.stdcall.}
  ISetupErrorState* = object
    lpVtbl: ptr ISetupErrorStateVtbl

  ISetupErrorState2Vtbl = object
    vtbl_ISetupErrorState: ISetupErrorStateVtbl
    getErrorLogFilePath: proc(this: ptr ISetupErrorState2, pbstrErrorLogFilePath: var pointer): HResult {.stdcall.}
    getLogFilePath: proc(this: ptr ISetupErrorState2, pbstrLogFilePath: var pointer): HResult {.stdcall.}
  ISetupErrorState2* = object
    lpVtbl: ptr ISetupErrorState2Vtbl

  ISetupFailedPackageReferenceVtbl = object
    vtbl_ISetupPackageReference: ISetupPackageReferenceVtbl
  ISetupFailedPackageReference* = object
    lpVtbl: ptr ISetupFailedPackageReferenceVtbl

  ISetupFailedPackageReference2Vtbl = object
    vtbl_ISetupFailedPackageReference: ISetupFailedPackageReferenceVtbl
    getLogFilePath: proc(this: ptr ISetupFailedPackageReference2, pbstrLogFilePath: var pointer): HResult {.stdcall.}
    getDescription: proc(this: ptr ISetupFailedPackageReference2, pbstrDescription: var pointer): HResult {.stdcall.}
    getSignature: proc(this: ptr ISetupFailedPackageReference2, pbstrSignature: var pointer): HResult {.stdcall.}
    getDetails: proc(this: ptr ISetupFailedPackageReference2, ppsaDetails: var pointer): HResult {.stdcall.}
    getAffectedPackages: proc(this: ptr ISetupFailedPackageReference2, ppsaAffectedPackages: var pointer): HResult {.stdcall.}
  ISetupFailedPackageReference2* = object
    lpVtbl: ptr ISetupFailedPackageReference2Vtbl

  ISetupPropertyStoreVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getNames: proc(this: ptr ISetupPropertyStore, ppsaNames: var pointer): HResult {.stdcall.}
    getValue: proc(this: ptr ISetupPropertyStore, pwszName: pointer, pvtValue: var pointer): HResult {.stdcall.}
  ISetupPropertyStore* = object
    lpVtbl: ptr ISetupPropertyStoreVtbl
  
  ISetupLocalizedPropertyStoreVtbl = object
    vtbl_IUnknown: IUnknownVtbl
    getNames: proc(this: ptr ISetupLocalizedPropertyStore, lcid: uint32, ppsaNames: var pointer): HResult {.stdcall.}
    getValue: proc(this: ptr ISetupLocalizedPropertyStore, pwszName: pointer, lcid: uint32, pvtValue: var pointer): HResult {.stdcall.}
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

proc getInstanceId*(this: ptr ISetupInstance, pbstrInstanceId: var WideCString): HResult =
  this.lpVtbl.getInstanceId(this, pbstrInstanceId)
proc getInstanceId*(this: ptr ISetupInstance): WideCString =
  let hr = getInstanceId(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstallDate*(this: ptr ISetupInstance, pInstallDate: var Filetime): HResult =
  this.lpVtbl.getInstallDate(this, pInstallDate)
proc getInstallDate*(this: ptr ISetupInstance): Filetime =
  let hr = getInstallDate(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstallationName*(this: ptr ISetupInstance, pbstrInstallationName: var WideCString): HResult =
  this.lpVtbl.getInstallationName(this, pbstrInstallationName)
proc getInstallationName*(this: ptr ISetupInstance): WideCString =
  let hr = getInstallationName(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstallationPath*(this: ptr ISetupInstance, pbstrInstallationPath: var WideCString): HResult =
  this.lpVtbl.getInstallationPath(this, pbstrInstallationPath)
proc getInstallationPath*(this: ptr ISetupInstance): WideCString =
  let hr = getInstallationPath(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstallationVersion*(this: ptr ISetupInstance, pbstrInstallationVersion: var WideCString): HResult =
  this.lpVtbl.getInstallationVersion(this, pbstrInstallationVersion)
proc getInstallationVersion*(this: ptr ISetupInstance): WideCString =
  let hr = getInstallationVersion(this, result)
  if hr.failed: raiseOSError(hr)
proc getDisplayName*(this: ptr ISetupInstance, lcid: Lcid, pbstrDisplayName: var WideCString): HResult =
  this.lpVtbl.getDisplayName(this, lcid, pbstrDisplayName)
proc getDisplayName*(this: ptr ISetupInstance, lcid: Lcid): WideCString =
  let hr = getDisplayName(this, lcid, result)
  if hr.failed: raiseOSError(hr)
proc getDescription*(this: ptr ISetupInstance, lcid: Lcid, pbstrDescription: var WideCString): HResult =
  this.lpVtbl.getDescription(this, lcid, pbstrDescription)
proc getDescription*(this: ptr ISetupInstance, lcid: Lcid): WideCString =
  let hr = getDescription(this, lcid, result)
  if hr.failed: raiseOSError(hr)
proc resolvePath*(this: ptr ISetupInstance, pwszRelativePath: WideCString, pbstrAbsolutePath: var WideCString): HResult =
  this.lpVtbl.resolvePath(this, pwszRelativePath, pbstrAbsolutePath)
proc resolvePath*(this: ptr ISetupInstance, pwszRelativePath: WideCString): WideCString =
  let hr = resolvePath(this, pwszRelativePath, result)
  if hr.failed: raiseOSError(hr)

proc getState*(this: ptr ISetupInstance2, pState: var InstanceState): HResult =
  this.lpVtbl.getState(this, pState)
proc getState*(this: ptr ISetupInstance2): InstanceState =
  let hr = getState(this, result)
  if hr.failed: raiseOSError(hr)
proc getPackages*(this: ptr ISetupInstance2, ppsaPackages: var pointer): HResult =
  this.lpVtbl.getPackages(this, ppsaPackages)
proc getPackages*(this: ptr ISetupInstance2): pointer =
  let hr = getPackages(this, result)
  if hr.failed: raiseOSError(hr)
proc getProduct*(this: ptr ISetupInstance2, ppPackage: var ptr ISetupPackageReference): HResult =
  this.lpVtbl.getProduct(this, ppPackage)
proc getProduct*(this: ptr ISetupInstance2): ptr ISetupPackageReference =
  let hr = getProduct(this, result)
  if hr.failed: raiseOSError(hr)
proc getProductPath*(this: ptr ISetupInstance2, pbstrProductPath: var WideCString): HResult =
  this.lpVtbl.getProductPath(this, pbstrProductPath)
proc getProductPath*(this: ptr ISetupInstance2): WideCString =
  let hr = getProductPath(this, result)
  if hr.failed: raiseOSError(hr)
proc getErrors*(this: ptr ISetupInstance2, ppErrorState: var ptr ISetupErrorState): HResult =
  this.lpVtbl.getErrors(this, ppErrorState)
proc getErrors*(this: ptr ISetupInstance2): ptr ISetupErrorState =
  let hr = getErrors(this, result)
  if hr.failed: raiseOSError(hr)
proc isLaunchable*(this: ptr ISetupInstance2, pfIsLaunchable: var Variant_Bool): HResult =
  this.lpVtbl.isLaunchable(this, pfIsLaunchable)
proc isLaunchable*(this: ptr ISetupInstance2, pfIsLaunchable: var bool): HResult =
  var vb: Variant_Bool
  result = isLaunchable(this, vb)
  pfIsLaunchable = vb
proc isLaunchable*(this: ptr ISetupInstance2): bool =
  let hr = isLaunchable(this, result)
  if hr.failed: raiseOSError(hr)
proc isComplete*(this: ptr ISetupInstance2, pfIsComplete: var Variant_Bool): HResult = 
  this.lpVtbl.isComplete(this, pfIsComplete)
proc isComplete*(this: ptr ISetupInstance2, pfIsComplete: var bool): HResult =
  var vb: Variant_Bool
  result = isComplete(this, vb)
  pfIsComplete = vb
proc isComplete*(this: ptr ISetupInstance2): bool =
  let hr = isComplete(this, result)
  if hr.failed: raiseOSError(hr)
proc getProperties*(this: ptr ISetupInstance2, ppProperties: var ptr ISetupPropertyStore): HResult =
  this.lpVtbl.getProperties(this, ppProperties)
proc getProperties*(this: ptr ISetupInstance2): ptr ISetupPropertyStore =
  let hr = getProperties(this, result)
  if hr.failed: raiseOSError(hr)
proc getEnginePath*(this: ptr ISetupInstance2, pbstrEnginePath: var WideCString): HResult =
  this.lpVtbl.getEnginePath(this, pbstrEnginePath)
proc getEnginePath*(this: ptr ISetupInstance2): WideCString =
  let hr = getEnginePath(this, result)
  if hr.failed: raiseOSError(hr)

proc getCatalogInfo*(this: ptr ISetupInstanceCatalog, ppCatalogInfo: var ptr ISetupPropertyStore): HResult =
  this.lpVtbl.getCatalogInfo(this, ppCatalogInfo)
proc getCatalogInfo*(this: ptr ISetupInstanceCatalog): ptr ISetupPropertyStore =
  let hr = getCatalogInfo(this, result)
  if hr.failed: raiseOSError(hr)
proc isPrerelease*(this: ptr ISetupInstanceCatalog, pfIsPrerelease: var Variant_Bool): HResult =
  this.lpVtbl.isPrerelease(this, pfIsPrerelease)
proc isPrerelease*(this: ptr ISetupInstanceCatalog, pfIsPrerelease: var bool): HResult =
  var vb: Variant_Bool
  result = isPrerelease(this, vb)
  pfIsPrerelease = vb
proc isPrerelease*(this: ptr ISetupInstanceCatalog): bool =
  let hr = isPrerelease(this, result)
  if hr.failed: raiseOSError(hr)

proc getLocalizedProperties*(this: ptr ISetupLocalizedProperties, ppLocalizedProperties: var ptr ISetupLocalizedPropertyStore): HResult =
  this.lpVtbl.getLocalizedProperties(this, ppLocalizedProperties)
proc getLocalizedProperties*(this: ptr ISetupLocalizedProperties): ptr ISetupLocalizedPropertyStore =
  let hr = getLocalizedProperties(this, result)
  if hr.failed: raiseOSError(hr)
proc getLocalizedChannelProperties*(this: ptr ISetupLocalizedProperties, ppLocalizedChannelProperties: var ptr ISetupLocalizedPropertyStore): HResult =
  this.lpVtbl.getLocalizedChannelProperties(this, ppLocalizedChannelProperties)
proc getLocalizedChannelProperties*(this: ptr ISetupLocalizedProperties): ptr ISetupLocalizedPropertyStore =
  let hr = getLocalizedChannelProperties(this, result)
  if hr.failed: raiseOSError(hr)

proc next*(this: ptr IEnumSetupInstances, rgelt: var openarray[ptr ISetupInstance], pceltFetched: var uint32): HResult =
  this.lpVtbl.next(this, len(rgelt).uint32, addr(rgelt[0]), pceltFetched)
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
  this.lpVtbl.skip(this, count)
proc reset_HResult*(this: ptr IEnumSetupInstances): HResult =
  this.lpVtbl.reset(this)
proc reset*(this: ptr IEnumSetupInstances) =
  let hr = reset_HResult(this)
  if hr.failed: raiseOSError(hr)
proc clone*(this: ptr IEnumSetupInstances, ppenum: var ptr IEnumSetupInstances): HResult =
  this.lpVtbl.clone(this, ppenum)
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
  this.lpVtbl.enumInstances(this, ppEnumInstances)
proc enumInstances*(this: ptr ISetupConfiguration): ptr IEnumSetupInstances =
  let hr = enumInstances(this, result)
  if hr.failed: raiseOSError(hr)
proc getInstanceForCurrentProcess*(this: ptr ISetupConfiguration, ppInstance: var ptr ISetupInstance): HResult =
  this.lpVtbl.getInstanceForCurrentProcess(this, ppInstance)
proc getInstanceForCurrentProcess*(this: ptr ISetupConfiguration): ptr ISetupInstance =
  let hr = getInstanceForCurrentProcess(this, result)
  if hr.failed: raiseOSError(hr)

proc enumAllInstances*(this: ptr ISetupConfiguration2, ppEnumInstances: var ptr IEnumSetupInstances): HResult =
  this.lpVtbl.enumAllInstances(this, ppEnumInstances)
proc enumAllInstances*(this: ptr ISetupConfiguration2): ptr IEnumSetupInstances =
  let hr = enumAllInstances(this, result)
  if hr.failed: raiseOSError(hr)

proc getId*(this: ptr ISetupPackageReference, pbstrId: var WideCString): HResult =
  this.lpVtbl.getId(this, pbstrId)
proc getId*(this: ptr ISetupPackageReference): WideCString =
  let hr = getId(this, result)
  if hr.failed: raiseOSError(hr)
proc getVersion*(this: ptr ISetupPackageReference, pbstrVersion: var WideCString): HResult =
  this.lpVtbl.getVersion(this, pbstrVersion)
proc getVersion*(this: ptr ISetupPackageReference): WideCString =
  let hr = getVersion(this, result)
  if hr.failed: raiseOSError(hr)
proc getChip*(this: ptr ISetupPackageReference, pbstrChip: var WideCString): HResult =
  this.lpVtbl.getChip(this, pbstrChip)
proc getChip*(this: ptr ISetupPackageReference): WideCString =
  let hr = getChip(this, result)
  if hr.failed: raiseOSError(hr)
proc getLanguage*(this: ptr ISetupPackageReference, pbstrLanguage: var WideCString): HResult =
  this.lpVtbl.getLanguage(this, pbstrLanguage)
proc getLanguage*(this: ptr ISetupPackageReference): WideCString =
  let hr = getLanguage(this, result)
  if hr.failed: raiseOSError(hr)
proc getBranch*(this: ptr ISetupPackageReference, pbstrBranch: var WideCString): HResult =
  this.lpVtbl.getBranch(this, pbstrBranch)
proc getBranch*(this: ptr ISetupPackageReference): WideCString =
  let hr = getBranch(this, result)
  if hr.failed: raiseOSError(hr)
proc getType*(this: ptr ISetupPackageReference, pbstrType: var WideCString): HResult =
  this.lpVtbl.getType(this, pbstrType)
proc getType*(this: ptr ISetupPackageReference): WideCString =
  let hr = getType(this, result)
  if hr.failed: raiseOSError(hr)
proc getUniqueId*(this: ptr ISetupPackageReference, pbstrUniqueId: var WideCString): HResult =
  this.lpVtbl.getUniqueId(this, pbstrUniqueId)
proc getUniqueId*(this: ptr ISetupPackageReference): WideCString =
  let hr = getUniqueId(this, result)
  if hr.failed: raiseOSError(hr)
proc isExtension*(this: ptr ISetupPackageReference, pfIsExtension: var Variant_Bool): HResult =
  this.lpVtbl.getIsExtension(this, pfIsExtension)
proc isExtension*(this: ptr ISetupPackageReference, pfIsExtension: var bool): HResult =
  var vb: Variant_Bool
  result = isExtension(this, vb)
  pfIsExtension = vb
proc isExtension*(this: ptr ISetupPackageReference): bool =
  let hr = isExtension(this, result)
  if hr.failed: raiseOSError(hr)

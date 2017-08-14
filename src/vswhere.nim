import windowssdk / um / winnt
import windowssdk / um / combaseapi
import windowssdk / um / objbase
import windowssdk / shared / wtypesbase
import vswherepkg / setup_configuration

import os

when isMainModule:
  var hr: HResult
  var setupConfigPtr: pointer
  var clsContext: ClsCtx

  hr = comInitialize()
  if hr.int32 != 0:
    raiseOsError(hr.OSErrorCode)
  
  hr = newComInstance(clsid_SetupConfiguration.addr, nil, clsContext, iid_ISetupConfiguration.addr, setupConfigPtr)
  let setupConfig = cast[ptr ISetupConfiguration](setupConfigPtr)

  echo hr.repr()
  echo setupConfig.repr()
  if hr.int32 != 0:
    raiseOsError(hr.OSErrorCode)

import windowssdk / um / winnt
import windowssdk / um / combaseapi
import windowssdk / um / objbase
import windowssdk / um / unknwn
import windowssdk / shared / wtypesbase
import windowssdk / shared / winerror
import vswherepkg / setup_configuration

import os

when isMainModule:
  var hr: HResult
  var setupConfig: ptr ISetupConfiguration
  hr = coInitialize()
  if hr.failed:
    raiseOSError(cast[OSErrorCode](hr))
  hr = coCreateInstance(clsid_SetupConfiguration, clsctx_Inproc_Server, iid_ISetupConfiguration, setupConfig)
  if hr.failed:
    raiseOSError(cast[OSErrorCode](hr))
  echo repr(setupConfig)
  var setupConfig2: ptr ISetupConfiguration2
  hr = queryInterface(setupConfig, iid_ISetupConfiguration2, setupConfig2)
  if hr.failed:
    raiseOSError(cast[OSErrorCode](hr))
  echo repr(setupConfig2)

  hr = setupConfig.release()
  if hr.failed:
    raiseOSError(cast[OSErrorCode](hr))
  setupConfig = nil
  hr = setupConfig2.release()
  if hr.failed:
    raiseOSError(cast[OSErrorCode](hr))
  setupConfig2 = nil

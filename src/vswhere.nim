import windowssdk / um / winnt
import windowssdk / um / combaseapi
import windowssdk / um / objbase
import windowssdk / um / unknwn
import windowssdk / shared / wtypesbase
import windowssdk / shared / winerror
import vswherepkg / setup_configuration

import os

when isMainModule:
  coInitialize()
  let unknown = coCreateInstance[IUnknown](clsid_SetupConfiguration, clsctx_inproc_server, iid_IUnknown)
  echo repr(unknown)
  let
    setupConfig = queryInterface[ISetupConfiguration](unknown, iid_ISetupConfiguration)
    setupConfig2 = queryInterface[ISetupConfiguration2](unknown, iid_ISetupConfiguration2)
    setupHelper = queryInterface[ISetupHelper](unknown, iid_ISetupHelper)

  echo repr(setupConfig)
  echo repr(setupConfig2)
  echo repr(setupHelper)

  let enumSetupInstances = queryInterface[IEnumSetupInstances](setupConfig2.enumAllInstances(), iid_IEnumSetupInstances)
  echo repr(enumSetupInstances)
  for setupInstance in enumSetupInstances.items:
    echo repr(setupInstance)
    setupInstance.release()
  
  enumSetupInstances.release()
  setupConfig.release()
  setupConfig2.release()
  setupHelper.release()
  unknown.release()
  
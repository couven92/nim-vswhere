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
  hr = getSetupConfiguration(setupConfig, nil)
  if hr.failed:
    echo hr
    raiseOSError(cast[OSErrorCode](hr))
  echo setupConfig.repr()
  var psetupConfig2: pointer
  hr = queryInterface(setupConfig, iid_ISetupConfiguration2.addr, psetupConfig2)
  if hr.failed:
    echo hr
    raiseOSError(cast[OSErrorCode](hr))
  let setupConfig2 = cast[ptr ISetupConfiguration2](psetupConfig2)
  echo setupConfig2.repr()

import windowssdk / um / winnt
import windowssdk / um / combaseapi
import windowssdk / um / objbase
import windowssdk / shared / wtypesbase
import windowssdk / shared / winerror
import vswherepkg / setup_configuration

import os

when isMainModule:
  var hr: HResult
  var setupConfig: ptr ISetupConfiguration
  echo "Hello World"

  hr = getSetupConfiguration(setupConfig, nil)
  if hr.failed:
    echo hr
    raiseOSError(cast[OSErrorCode](hr))
  echo "Hello World"
  echo setupConfig.repr()
    
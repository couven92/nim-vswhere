import windowssdk / um / winnt
import vswherepkg / setup_configuration

when isMainModule:
  var hr: HResult
  var setupConfig: ptr ISetupConfiguration

  echo hr.repr()
  echo setupConfig.repr()

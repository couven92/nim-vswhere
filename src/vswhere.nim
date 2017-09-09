import windowssdk / um / winnt
import windowssdk / um / combaseapi
import windowssdk / um / objbase
import windowssdk / um / unknwn
import windowssdk / shared / wtypes
import windowssdk / shared / wtypesbase
import windowssdk / shared / winerror
import vswherepkg / setup_configuration

import os

when isMainModule:
  coInitialize()
  let unknown = coCreateInstance[IUnknown](clsid_SetupConfiguration, clsctx_inproc_server, iid_IUnknown)
  echo "IUnknown: " & repr(unknown)
  let
    setupConfig = queryInterface[ISetupConfiguration](unknown, iid_ISetupConfiguration)
    setupConfig2 = queryInterface[ISetupConfiguration2](unknown, iid_ISetupConfiguration2)
    setupHelper = queryInterface[ISetupHelper](unknown, iid_ISetupHelper)

  echo "ISetupConfiguration: " & repr(setupConfig)
  echo "ISetupConfiguration2: " & repr(setupConfig2)
  echo "ISetupHelper: " & repr(setupHelper)

  let enumSetupInstances = setupConfig2.enumAllInstances()
  echo "IEnumSetupInstances: " & repr(enumSetupInstances)
  for setupInstance in enumSetupInstances.items:
    echo "ISetupInstance: " & repr(setupInstance)

    echo "InstanceId: " & $(setupInstance.getInstanceId())
    echo "InstallDate: " & repr(setupInstance.getInstallDate())
    echo "InstallationName: " & $(setupInstance.getInstallationName())
    echo "InstallationPath: " & $(setupInstance.getInstallationPath())
    echo "InstallationVersion: " & $(setupInstance.getInstallationVersion())
    echo "DisplayName: " & $(setupInstance.getDisplayName(0.Lcid))
    echo "Description: " & $(setupInstance.getDescription(0.Lcid))
    echo "resolvePath: " & $(setupInstance.resolvePath(newWideCString("VC" / "Auxiliary" / "Build" / "vcvarsall")))

    let setupInstance2 = queryInterface[ISetupInstance2](setupInstance, iid_ISetupInstance2)
    echo "ISetupInstance2: " & repr(setupInstance2)

    echo "State: " & $(setupInstance2.getState())
    let setupPackageRef = setupInstance2.getProduct()
    echo "Product: " & repr(setupPackageRef)
    if not setupPackageRef.isNil:
      echo "Id: " & $(setupPackageRef.getId())
      echo "Version: " & $(setupPackageRef.getVersion())
      let chip = setupPackageRef.getChip()
      echo "Chip: " & (if chip.isNil: "" else: $(chip))
      let language = setupPackageRef.getLanguage()
      echo "Language: " & (if language.isNil: "" else: $(language))
      let branch = setupPackageRef.getBranch()
      echo "Branch: " & (if branch.isNil: "" else: $(branch))
      echo "Type: " & $(setupPackageRef.getType())
      echo "UniqueId: " & $(setupPackageRef.getUniqueId())
      echo "IsExtension: " & $(setupPackageRef.isExtension())
    echo "ProductPath: " & $(setupInstance2.getProductPath())
    let setupErrorState = setupInstance2.getErrors()
    echo "Errors: " & repr(setupErrorState)
    echo "IsLaunchable: " & $(setupInstance2.isLaunchable())
    echo "IsComplete: " & $(setupInstance2.isComplete())
    let setupPropertyStore = setupInstance2.getProperties()
    echo "Properties: " & repr(setupPropertyStore)
    echo "EnginePath: " & $(setupInstance2.getEnginePath())

    if not setupPackageRef.isNil: setupPackageRef.release()
    if not setupErrorState.isNil: setupErrorState.release()
    setupInstance.release()
  
  enumSetupInstances.release()
  setupConfig.release()
  setupConfig2.release()
  setupHelper.release()
  unknown.release()
  
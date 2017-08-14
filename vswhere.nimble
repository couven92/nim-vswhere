# Package

packageName   = "vswhere"
version       = "2.1.3"
author        = "Fredrik H\x9Bis\x91ther Rasch"
description   = "Visual Studio discovery tool for Nim"
license       = "MIT"
bin           = @["vswhere"]
binDir        = "bin"
srcDir        = "src"

# Dependencies

requires "nim >= 0.17.0"
requires "windowssdk >= 10.0"

import strutils, ospaths

before test:
  mkDir "bin"

before docall:
  mkDir "doc"

task docall, "Document srcDir recursively":
  proc recurseDir(srcDir, docDir: string, nimOpts: string = "") =
    for srcFile in listFiles(srcDir):
      if not srcFile.endsWith(".nim"):
        echo "skipping non nim file: $#" % [srcFile]
      const htmlExt = ".html"
      let docFile = docDir & srcFile[srcDir.len ..^ htmlExt.len] & htmlExt
      echo "file: $# -> $#" % [srcFile, docFile]
      exec "nim doc2 $# -o:\"$#\" \"$#\"" % [nimOpts, docFile, srcFile]
    for srcSubDir in listDirs(srcDir):
      let docSubDir = docDir & srcSubDir[srcDir.len ..^ 1]
      # echo "dir: $# -> $#" % [srcSubDir, docSubDir]
      mkDir docSubDir
      recurseDir(srcSubDir, docSubDir)

  let docDir = "doc"
  recurseDir(srcDir, docDir)

task test, "Test runs the package":
  exec "nim compile --run -o:" & ("bin" / packageName) & " " & (srcDir / packageName)

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
requires "windowssdk >= 0.1.12"

import strutils, ospaths

before test:
  mkDir "bin"

before cref:
  mkDir "obj"
  mkDir "bin"

before docall:
  mkDir "doc"

task docall, "Document srcDir recursively":
  proc recurseDir(srcDir, docDir: string, nimOpts: string = "") =
    for srcFile in listFiles(srcDir):
      if not srcFile.endsWith(".nim"):
        echo "skipping non nim file: $#" % [srcFile]
        continue
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
  exec "nim compile --run -o:\"" & ("bin" / packageName) & "\" \"" & (srcDir / packageName) & "\""

task cref, "Build C reference source":
  var vccopts: seq[string] = @[] 
  vccopts.add("--command:cl.exe")
  vccopts.add(get("vcc.options.always"))
  when not defined(release) or defined(debug):
    vccopts.add get("vcc.options.debug")
  let vccopts_string = vccopts.join(" ")
  var cmd_parts: seq[string] = @[]
  cmd_parts.add "vccexe.exe"
  cmd_parts.add vccopts_string
  cmd_parts.add "/Fo:\"" & ("obj" / "cref.obj") & "\""
  cmd_parts.add "/Fd:\"" & ("bin" / "cref.pdb") & "\""
  cmd_parts.add "/Fe:\"" & ("bin" / "cref") & "\""
  cmd_parts.add "\"" & ("cref" / "main.c") & "\""
  cmd_parts.add "Secur32.lib"
  cmd_parts.add "ole32.lib"
  let cmd = cmd_parts.join(" ")
  echo cmd
  exec cmd


import Lake.CLI.Main

open Lake

def loadLakeWorkspace : IO Workspace := do 
  let (elanInstall?, leanInstall?, lakeInstall?) ← findInstall?
  let config ← MonadError.runEIO <| mkLoadConfig { elanInstall?, leanInstall?, lakeInstall? }
  let workspace ← MonadError.runEIO <| MainM.runLogIO (loadWorkspace config)
  return workspace

def leanLibs : IO (List Name) := do
  return (← loadLakeWorkspace).root.leanLibs.map (·.name) |>.toList

/-- Returns the root modules of `lean_exe` or `lean_lib` default targets in the Lake workspace. -/
def resolveDefaultRootModules : IO (Array Name) := do
  -- load the Lake workspace
  let workspace ← loadLakeWorkspace

  -- resolve the default build specs from the Lake workspace (based on `lake build`)
  let defaultBuildSpecs ← match resolveDefaultPackageTarget workspace workspace.root with
    | Except.error e => IO.eprintln s!"Error getting default package target: {e}" *> IO.Process.exit 1
    | Except.ok targets => pure targets

  -- build an array of all root modules of `lean_exe` and `lean_lib` build targets
  let defaultTargetModules := defaultBuildSpecs.concatMap <|
    fun target => match target.info with
      | BuildInfo.libraryFacet lib _ => lib.roots
      | BuildInfo.leanExe exe => #[exe.config.root]
      | _ => #[]

  return defaultTargetModules


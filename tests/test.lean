import LakeInternalApiExample

def main : IO Unit := do
  IO.println s!"{← leanLibs}"
  IO.println s!"{← resolveDefaultRootModules}"

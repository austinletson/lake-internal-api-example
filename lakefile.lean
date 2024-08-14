import Lake
open Lake DSL

package "lake-internal-api-example" where
  -- add package configuration options here

lean_lib «LakeInternalApiExample» where
  -- add library configuration options here

@[default_target]
lean_exe "lake-internal-api-example" where
  root := `Main


@[test_driver]
lean_exe test where
  srcDir := "tests"
  supportInterpreter := true
  

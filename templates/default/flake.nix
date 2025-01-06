{
  inputs = {};
  outputs = {
    self,
    # Include explicitly used inputs here
    # nixpkgs,
    ...
  } @ inputs: let
    # Expose outputs explicitly
    inherit (self) outputs;
  in {
  };
}

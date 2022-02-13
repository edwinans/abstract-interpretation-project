(* to use int32 with zarith like functions *)

module Z32 = struct
  include Int32

  let lt x y = compare x y < 0

  let gt x y = compare x y > 0

  let leq x y = compare x y <= 0

  let geq x y = compare x y >= 0
end

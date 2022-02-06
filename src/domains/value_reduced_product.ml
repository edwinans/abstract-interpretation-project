open Value_reduction
open Value_domain
open Abstract_syntax_tree

module ReducedProduct (R : VALUE_REDUCTION) = 
(struct

  module A = R.A
  module B = R.B

  type t = R.t (* A.t * B.t *)

  let top = A.top, B.top
  let bottom = A.bottom, B.bottom
  let const c = A.const c, B.const c
  let rand x y = A.rand x y, B.rand x y

  let lift f g ((x1,y1):t) ((x2,y2):t) =
     R.reduce (f x1 x2, g y1 y2)

  let join = lift A.join B.join
  let meet = lift A.meet B.meet 

  let subset ((x1,y1):t) ((x2,y2):t) = A.subset x1 x2 && B.subset y1 y2 

  let is_bottom = (=) bottom 
  let print fmt ((x,y):t) =
    begin
      A.print fmt x;
      Format.fprintf fmt " ∧ ";
      B.print fmt y 
    end

  let unary ((a, b) : t) (op : int_unary_op) : t = 
    R.reduce (A.unary a op, B.unary b op)

  let binary ((x1,y1):t) ((x2,y2):t) (op : int_binary_op) : t = 
    R.reduce (A.binary x1 x2 op, B.binary y1 y2 op)

  let widen ((x1,y1):t) ((x2,y2):t) = (A.widen x1 x2, B.widen y1 y2)

  let compare ((x1,y1):t) ((x2,y2):t) (op : compare_op) : t * t = 
    let a1, a2 = A.compare x1 x2 op
    and b1, b2 = B.compare y1 y2 op in 
    (R.reduce (a1,b1), R.reduce (a2,b2))

  let bwd_unary ((x1,y1):t) (op : int_unary_op) ((x2,y2):t) : t = 
    R.reduce (A.bwd_unary x1 op x2, B.bwd_unary y1 op y2)

  let bwd_binary ((x1,y1):t) ((x2,y2):t) (op : int_binary_op) ((r1,r2):t): t * t = 
    let a1, a2 = A.bwd_binary x1 x2 op r1
    and b1, b2 = B.bwd_binary y1 y2 op r2 in 
    (R.reduce (a1,b1), R.reduce (a2,b2))


end : VALUE_DOMAIN)

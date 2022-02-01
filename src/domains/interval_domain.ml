(* 
   The interval domain
 *)

open Abstract_syntax_tree
open Value_domain

module Intervals : VALUE_DOMAIN = struct
  (* types *)
  (* ***** *)

  (* type of abstract values *)

  type value = Val of Z.t | NInf | PInf

  type t =
    | Interval of value * value (* set of an integer interval, possibly [-inf, +inf]*)
    | BOT

  (* the set is empty (not reachable) *)

  (* utilities *)
  (* ********* *)

  (* lift unary arithmetic operations, from integers to t *)
  let lift1 f x =
    match x with BOT -> BOT | Interval (a, b) -> Interval (f a, f b)

  (* lift binary arithmetic operations *)
  let lift2 f x y =
    match (x, y) with
    | BOT, _ | _, BOT ->
        BOT
    | Interval (a1, b1), Interval (a2, b2) ->
        Interval (f a1 a2, f b1 b2)

  (* interface implementation *)
  (* ************************ *)

  (* unrestricted value *)
  let top = Interval (NInf, PInf)

  (* bottom value *)
  let bottom = BOT

  (* constant *)
  let const c = Interval (Val c, Val c)

  (* interval *)
  let rand x y = if x <= y then Interval (Val x, Val y) else BOT

  
  (* arithmetic operations for values *)

  let neg_value = function
    | PInf -> NInf
    | NInf -> PInf
    | Val x -> Val (Z.neg x)

  let add_value x y = match x,y with 
    | PInf, NInf | NInf, PInf -> Val (Z.zero)
    | NInf, _ | _, NInf -> NInf
    | PInf, _ | _, PInf -> PInf
    | Val v1, Val v2 -> Val (Z.add v1 v2)

  let sub_value x y = add_value x (neg_value y)

  let mul_value x y = match x,y with 
    | NInf, PInf | PInf, NInf -> NInf
    | NInf, NInf | PInf, PInf -> PInf 
    | NInf, Val v | Val v, NInf -> 
        if Z.lt v Z.zero then PInf else
        if v = Z.zero then Val Z.zero else 
        NInf
    | PInf, Val v | Val v, PInf -> 
        if Z.lt v Z.zero then NInf else
        if v = Z.zero then Val Z.zero else 
        PInf
    | Val v1, Val v2 -> Val (Z.mul v1 v2)

    let div_value x y = match x,y with 
    | _, _ when y = Val Z.zero -> failwith "division by zero"
    | NInf, PInf | PInf, NInf -> NInf
    | NInf, NInf | PInf, PInf -> PInf 
    | NInf, Val v -> if Z.lt v Z.zero then PInf else NInf
    | PInf, Val v -> if Z.lt v Z.zero then NInf else PInf
    | Val v, NInf | Val v, PInf -> Val Z.zero
    | Val v1, Val v2 -> Val (Z.div v1 v2)

  let increment_value x = add_value x (Val (Z.one))
  let decrement_value x = sub_value x (Val (Z.one))

  (* ordering for values *)
  let min_value x y = match x,y with
    | PInf, t | t, PInf -> t 
    | NInf, _ | _, NInf -> NInf 
    | Val v1, Val v2 -> Val (Z.min v1 v2)

  let max_value x y = match x,y with
    | NInf, t | t, NInf -> t 
    | PInf, _ | _, PInf -> PInf 
    | Val v1, Val v2 -> Val (Z.max v1 v2)

  (* comparison for values *)
  let gt_value x y = match x,y with
   | NInf, _ | _, PInf -> false
   | PInf, _ | _, NInf -> true 
   | Val v1, Val v2 -> Z.gt v1 v2

  (* ordering for intervals*)
  let is_val itvl v = (itvl = Interval (v, v))
  let is_int itvl c = (itvl = const c)

  (* returns true when both intervals are const i.e interval(c,c) and equal*)
  let cst_interval_eq x y = match x y with 
    | Interval (a1, b1), Interval (a2, b2) -> a1 = b1 && a2 = b2 && a1 = a2 
    | _, _ -> false

  (* arithmetic operations for intervals *)

  let neg = function 
    | BOT -> BOT 
    | Interval (a, b) -> Interval (neg_value b, neg_value a)

  let add = lift2 add_value

  let sub x y = add x (neg y)

  let mul x y = match x,y with 
    | BOT, _ | _, BOT -> BOT 
    | Interval (a1, b1), Interval (a2, b2) ->
        let t1 = mul_value a1 a2 and t2 = mul_value a1 b2 
        and t3 = mul_value b1 a2 and t4 = mul_value b1 b2 in 
        let a = min_value (min_value t1 t2) (min_value t3 t4)
        and b = max_value (max_value t1 t2) (max_value t3 t4) in 
        Interval (a, b)

  (* let div a b = if b = Cst Z.zero then BOT else lift2 Z.div a b *)

  let remove_zero = function
    | Interval (a,b) when a = Val (Z.zero) -> Interval(increment_value a, b)
    | Interval (a,b) when b = Val (Z.zero) -> Interval(a, decrement_value b)
    | x -> x 


  let div x y = match x,y with 
    | BOT, _ | _, BOT -> BOT
    | _, _ when is_int y Z.zero  -> BOT 
    | Interval (a1,b1), _ -> match remove_zero y with
      | Interval(a2,b2) ->( 
        let t1 = div_value a1 a2 and t2 = div_value a1 b2 
        and t3 = div_value b1 a2 and t4 = div_value b1 b2 in 
        let a = min_value (min_value t1 t2) (min_value t3 t4)
        and b = max_value (max_value t1 t2) (max_value t3 t4) in 
        Interval (a, b))
      | _ -> BOT
      

  (* set-theoretic operations *)

  let join x y = match x,y with 
      | BOT, _ | _, BOT -> BOT 
      | Interval (a1, b1), Interval (a2, b2) ->
          Interval (min_value a1 a2, max_value b1 b2)

  let meet x y =  match x,y with 
  | BOT, _ | _, BOT -> BOT 
  | Interval (a1, b1), Interval (a2, b2) ->
      if a2 > b1 || a1 > b2 then BOT 
      else Interval (max_value a1 a2, min_value b1 b2)

  (* no need for a widening as the domain has finite height; we use the join *)
  let widen = join


  (* comparison operations (filters) *)

  let eq x y =
    let m = meet x y in (m, m)

  let rec neq x y = match x,y with
    | BOT, _ | _, BOT -> BOT, BOT
    | Interval (a1,_) , Interval (a2,_) when (is_val x a1) && (is_val y a2) ->
        if x = y then BOT, BOT 
        else x, y 
    | Interval (a1,_) , Interval (a2,b2) when is_val x a1 ->
        if a1 = a2 then (x, Interval (increment_value a2, b2))
        else if a1 = b2 then (x, Interval (a2, decrement_value b2))
        else x, y
    | _ , Interval (a, _) when is_val y a -> 
        let x', y' = neq y x in (y', x')
    | _, _ -> x,y  

  let gt x y = match x,y with
    | BOT, _ | _, BOT -> BOT, BOT
    | Interval (a1,_) , Interval (a2,_) when (is_val x a1) && (is_val y a2) ->
        if not (gt_value a2 a1) then x,y else BOT, BOT
    | Interval (a1,b1) , Interval (a2,b2) -> 
      let t1 = Interval (max_value (increment_value a2) a1, b1) in 
      let t2 = Interval (a2, min_value (decrement_value b1) b2) in
      if gt_value a2 b1 then BOT, BOT
      else if gt_value a1 b2 then x, y
      else (
        if is_val x a1 then x,t2
        else if is_val y a2 then t1,y 
        else t1,t2
      )

  let geq x y = match x,y with
    | BOT, _ | _, BOT -> BOT, BOT
    | Interval (a1,_) , Interval (a2,_) when (is_val x a1) && (is_val y a2) ->
        if gt_value a2 a1 then BOT, BOT else x,y
    | Interval (a1,b1) , Interval (a2,b2) -> 
      let t1 = Interval (max_value a2 a1, b1) in 
      let t2 = Interval (a2, min_value b1 b2) in
      if gt_value a2 b1 then BOT, BOT
      else if gt_value a1 b2 || a1 = b2 then x, y
      else (
        if is_val x a1 then x,t2
        else if is_val y a2 then t1,y 
        else t1,t2
      )
  (* subset inclusion of concretizations *)
  let subset a b = true

  (* check the emptiness of the concretization *)
  let is_bottom = (=) BOT
  

  (* check if unrestricted value*)
  let is_top = (=) top

  let val_to_string = function
  | Val x -> Z.to_string x
  | NInf -> "−∞"
  | PInf -> "+∞"

  (* print abstract element *)
  let print fmt x =
    match x with
    | BOT ->
        Format.fprintf fmt "⊥"
    | _ when is_top x ->
        Format.fprintf fmt "⊤"
    | Interval (a,b) ->
        Format.fprintf fmt "[%s;%s]" (val_to_string a) (val_to_string b)

  (* operator dispatch *)

  let unary x op =
    match op with AST_UNARY_PLUS -> x | AST_UNARY_MINUS -> neg x

  let binary x y op =
    match op with
    | AST_PLUS ->
        add x y
    | AST_MINUS ->
        sub x y
    | AST_MULTIPLY ->
        mul x y
    | AST_DIVIDE ->
        div x y

  let compare x y op =
    match op with
    | AST_EQUAL ->
        eq x y
    | AST_NOT_EQUAL ->
        neq x y
    | AST_GREATER_EQUAL ->
        geq x y
    | AST_GREATER ->
        gt x y
    | AST_LESS_EQUAL ->
        let y', x' = geq y x in
        (x', y')
    | AST_LESS ->
        let y', x' = gt y x in
        (x', y')

  let bwd_unary x op r =
    match op with
    | AST_UNARY_PLUS ->
        meet x r
    | AST_UNARY_MINUS ->
        meet x (neg r)

  let bwd_binary x y op r =
    match op with
    | AST_PLUS ->
        (* r=x+y => x=r-y and y=r-x *)
        (meet x (sub r y), meet y (sub r x))
    | AST_MINUS ->
        (* r=x-y => x=y+r and y=x-r *)
        (meet x (add y r), meet y (sub x r))
    | AST_MULTIPLY ->
        (* r=x*y => (x=r/y or y=r=0) and (y=r/x or x=r=0)  *)
        let contains_zero o = subset (const Z.zero) o in
        ( (if contains_zero y && contains_zero r then x else meet x (div r y))
        , if contains_zero x && contains_zero r then y else meet y (div r x) )
    | AST_DIVIDE ->
        (* this is sound, but not precise *)
        (x, y)
end

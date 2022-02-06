(*
  Cours "Typage et Analyse Statique" - Master STL
  Sorbonne Université
  Antoine Miné 2015-2018
*)

(* 
   The constant domain
 *)

 open Abstract_syntax_tree
 open Value_domain
 
 
 module Parity = (struct
 
   
   (* types *)
   (* ***** *)
 
 
   (* type of abstract values *)
   type t =
    | BOT
    | Even
    | Odd
    | TOP
 
 
   (* utilities *)
   (* ********* *)
 
 
   (* lift unary arithmetic operations, from integers to t *)
   let lift1 f x = x
 
   (* lift binary arithmetic operations *)
   let lift2 f x y =
     match x,y with
     | BOT,_ | _,BOT -> BOT
     | x, y -> f x y
           
 
 
   (* interface implementation *)
   (* ************************ *)
 
 
   (* unrestricted value *)
   let top = TOP
 
   (* bottom value *)
   let bottom = BOT
 
   (* constant *)
   let const c = if Z.is_even c then Even else Odd
 
   (* interval *)
   let rand x y =
     if x=y then const x
     else if x<y then TOP
     else BOT
 
 
   (* arithmetic operations *)
 
   let neg = lift1 Z.neg
 
   let add x y = match x,y with 
     | BOT, _ | _, BOT -> BOT 
     | TOP, _ | _, TOP -> TOP
     | Even, Even | Odd, Odd -> Even
     | _ , _ -> Odd
 
   let sub = add
 
   let mul x y = match x,y with 
    | BOT, _ | _, BOT -> BOT 
    | Even, _ | _, Even -> Even
    | TOP, _ | _, TOP -> TOP
    | _ -> Odd

 
   let div = lift2 (fun _ _ -> TOP)
 
 
   (* set-theoretic operations *)
   
   let join a b = match a,b with
    | BOT, x | x, BOT -> x
    | Even, Even -> Even
    | Odd, Odd -> Odd 
    | _, _ -> TOP
 
   let meet a b = match a,b with
    | TOP, x | x, TOP -> x
    | Even, Even -> Even
    | Odd, Odd -> Odd 
    | _ -> BOT  
 
   (* no need for a widening as the domain has finite height; we use the join *)
   let widen = join
 
 
   (* comparison operations (filters) *)
 
   let eq x y = match x,y with
    | BOT, _ | _, BOT -> BOT, BOT
    | TOP, a | a , TOP -> a, a
    | Even, Odd | Odd, Even -> BOT, BOT
    | _ -> x,y
 
   let neq x y = match x,y with
    | BOT, _ | _, BOT -> BOT, BOT
    | _ -> x,y
   
   let gt x y = match x,y with 
    | BOT, _ -> BOT, BOT
    | _ -> x,y
 
   let geq x y = match x,y with 
    | BOT, _ -> BOT, BOT
    | _ -> x,y
 
   (* subset inclusion of concretizations *)
   let subset x y = match x,y with
    | BOT,_ | _,TOP -> true
    | Even, Even | Odd, Odd -> true 
    | _ -> false 

   (* check the emptiness of the concretization *)
   let is_bottom a =
     a = BOT
 
   (* print abstract element *)
   let print fmt x = match x with
   | BOT -> Format.fprintf fmt "⊥"
   | Even -> Format.fprintf fmt "even"
   | Odd -> Format.fprintf fmt "odd"
   | TOP -> Format.fprintf fmt "⊤"
 
 
   (* operator dispatch *)
         
   let unary x op = match op with
   | AST_UNARY_PLUS  -> x
   | AST_UNARY_MINUS -> neg x
 
   let binary x y op = match op with
   | AST_PLUS     -> add x y
   | AST_MINUS    -> sub x y
   | AST_MULTIPLY -> mul x y
   | AST_DIVIDE   -> div x y
 
   let compare x y op = match op with
   | AST_EQUAL         -> eq x y
   | AST_NOT_EQUAL     -> neq x y
   | AST_GREATER_EQUAL -> geq x y
   | AST_GREATER       -> gt x y
   | AST_LESS_EQUAL    -> let y',x' = geq y x in x',y'
   | AST_LESS          -> let y',x' = gt y x in x',y'
         
 
 
   let bwd_unary x op r = match op with
   | AST_UNARY_PLUS  -> meet x r
   | AST_UNARY_MINUS -> meet x (neg r)
 
         
   let bwd_binary x y op r = match op with
 
   | AST_PLUS ->
       (* r=x+y => x=r-y and y=r-x *)      
       meet x (sub r y), meet y (sub r x)
 
   | AST_MINUS ->
       (* r=x-y => x=y+r and y=x-r *)
       meet x (add y r), meet y (sub x r)
         
   | AST_MULTIPLY ->
       (* r=x*y => (x=r/y or y=r=0) and (y=r/x or x=r=0)  *)
       let contains_zero o = subset (const Z.zero) o in
       (if contains_zero y && contains_zero r then x else meet x (div r y)),
       (if contains_zero x && contains_zero r then y else meet y (div r x))
         
   | AST_DIVIDE ->
       (* this is sound, but not precise *)
       x, y
         
       
 end : VALUE_DOMAIN)
 
     
 
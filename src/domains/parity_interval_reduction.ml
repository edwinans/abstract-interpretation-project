open Value_reduction
open Parity_domain
open Interval_domain

module ParityIntervalsReduction : VALUE_REDUCTION = 
struct
  module A = Parity
  module B = Intervals

  
  type t = A.t * B.t

  let bottom = A.bottom, B.bottom

  let parity (x :B.value) = match x with 
  | B.Val v -> A.const v 
  | _ -> A.top

  let reduce ((p, i) : t) : t =
    match i with
    | BOT -> bottom
    | Interval (a, b) ->
        let a' = if A.subset (parity a) p then a else B.increment_value a in
        let b' = if A.subset (parity b) p then b else B.decrement_value b in
        if B.gt_value a' b' then bottom
        else if a' = b' then (parity a', Interval (a', b'))
        else (p, Interval (a', b'))
end

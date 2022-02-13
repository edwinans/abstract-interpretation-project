(* 
  necessary signatures for Z or Z32 functions
  extracted from #show zarith
*)

module type Z_TYPE =
  sig
    type t
    (* exception Overflow *)
    val zero : t
    val one : t
    val minus_one : t
    (* external of_int : int -> t = "%identity" *)
    (* external of_int32 : int32 -> t = "ml_z_of_int32" *)
    (* external of_int64 : int64 -> t = "ml_z_of_int64" *)
    (* external of_nativeint : nativeint -> t = "ml_z_of_nativeint" *)
    (* external of_float : float -> t = "ml_z_of_float" *)
    val of_string : string -> t
    (* val of_substring : string -> pos:int -> len:int -> t
    val of_string_base : int -> string -> t
    external of_substring_base : int -> string -> pos:int -> len:int -> t
      = "ml_z_of_substring_base" *)
    val succ : t -> t
    val pred : t -> t
    val abs : t -> t
    val neg : t -> t
    val add : t -> t -> t
    val sub : t -> t -> t
    val mul : t -> t -> t
    val div : t -> t -> t
    val rem : t -> t -> t
    (* external div_rem : t -> t -> t * t = "ml_z_div_rem"
    external cdiv : t -> t -> t = "ml_z_cdiv"
    external fdiv : t -> t -> t = "ml_z_fdiv"
    val ediv_rem : t -> t -> t * t
    val ediv : t -> t -> t
    val erem : t -> t -> t
    val divexact : t -> t -> t
    external divisible : t -> t -> bool = "ml_z_divisible"
    external congruent : t -> t -> t -> bool = "ml_z_congruent" *)
    val logand : t -> t -> t
    val logor : t -> t -> t
    val logxor : t -> t -> t
    val lognot : t -> t
    val shift_left : t -> int -> t
    val shift_right : t -> int -> t
    (* val shift_right_trunc : t -> int -> t
    external numbits : t -> int = "ml_z_numbits" [@@noalloc]
    external trailing_zeros : t -> int = "ml_z_trailing_zeros" [@@noalloc]
    val testbit : t -> int -> bool
    external popcount : t -> int = "ml_z_popcount"
    external hamdist : t -> t -> int = "ml_z_hamdist" *)
    val to_int : t -> int
    (* external to_int32 : t -> int32 = "ml_z_to_int32"
    external to_int64 : t -> int64 = "ml_z_to_int64"
    external to_nativeint : t -> nativeint = "ml_z_to_nativeint" *)
    val to_float : t -> float
    val to_string : t -> string
    (* external format : string -> t -> string = "ml_z_format" *)
    (* external fits_int : t -> bool = "ml_z_fits_int" [@@noalloc]
    external fits_int32 : t -> bool = "ml_z_fits_int32" [@@noalloc]
    external fits_int64 : t -> bool = "ml_z_fits_int64" [@@noalloc]
    external fits_nativeint : t -> bool = "ml_z_fits_nativeint" [@@noalloc]
    val print : t -> unit
    val output : out_channel -> t -> unit
    val sprint : unit -> t -> string
    val bprint : Buffer.t -> t -> unit
    val pp_print : Format.formatter -> t -> unit *)
    (* external compare : t -> t -> int = "ml_z_compare" [@@noalloc]*)
    (* external equal : t -> t -> bool = "ml_z_equal" [@@noalloc]  *)
    val equal : t -> t -> bool
    val compare : t -> t -> int
    val leq : t -> t -> bool
    val geq : t -> t -> bool
    val lt : t -> t -> bool
    val gt : t -> t -> bool
    (* external sign : t -> int = "ml_z_sign" [@@noalloc]
    val min : t -> t -> t
    val max : t -> t -> t
    val is_even : t -> bool
    val is_odd : t -> bool
    external hash : t -> int = "ml_z_hash" [@@noalloc]
    external gcd : t -> t -> t = "ml_z_gcd"
    val gcdext : t -> t -> t * t * t
    val lcm : t -> t -> t
    external powm : t -> t -> t -> t = "ml_z_powm"
    external powm_sec : t -> t -> t -> t = "ml_z_powm_sec"
    external invert : t -> t -> t = "ml_z_invert"
    external probab_prime : t -> int -> int = "ml_z_probab_prime"
    external nextprime : t -> t = "ml_z_nextprime"
    external jacobi : t -> t -> int = "ml_z_jacobi"
    external legendre : t -> t -> int = "ml_z_legendre"
    external kronecker : t -> t -> int = "ml_z_kronecker"
    external remove : t -> t -> t * int = "ml_z_remove"
    external fac : int -> t = "ml_z_fac"
    external fac2 : int -> t = "ml_z_fac2"
    external facM : int -> int -> t = "ml_z_facM"
    external primorial : int -> t = "ml_z_primorial"
    external bin : t -> int -> t = "ml_z_bin"
    external fib : int -> t = "ml_z_fib"
    external lucnum : int -> t = "ml_z_lucnum"
    external pow : t -> int -> t = "ml_z_pow"
    external sqrt : t -> t = "ml_z_sqrt"
    external sqrt_rem : t -> t * t = "ml_z_sqrt_rem"
    external root : t -> int -> t = "ml_z_root"
    external rootrem : t -> int -> t * t = "ml_z_rootrem"
    external perfect_power : t -> bool = "ml_z_perfect_power"
    external perfect_square : t -> bool = "ml_z_perfect_square"
    val log2 : t -> int
    val log2up : t -> int
    external size : t -> int = "ml_z_size" [@@noalloc]
    external extract : t -> int -> int -> t = "ml_z_extract"
    val signed_extract : t -> int -> int -> t
    external to_bits : t -> string = "ml_z_to_bits"
    external of_bits : string -> t = "ml_z_of_bits"
    val ( ~- ) : t -> t
    val ( ~+ ) : t -> t
    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t
    val ( * ) : t -> t -> t
    val ( / ) : t -> t -> t
    external ( /> ) : t -> t -> t = "ml_z_cdiv"
    external ( /< ) : t -> t -> t = "ml_z_fdiv"
    val ( /| ) : t -> t -> t
    val ( mod ) : t -> t -> t
    val ( land ) : t -> t -> t
    val ( lor ) : t -> t -> t
    val ( lxor ) : t -> t -> t
    val ( ~! ) : t -> t
    val ( lsl ) : t -> int -> t
    val ( asr ) : t -> int -> t
    external ( ~$ ) : int -> t = "%identity"
    external ( ** ) : t -> int -> t = "ml_z_pow"
    module Compare : sig

      val (=): t -> t -> bool
      (** Same as [equal]. *)
  
      val (<): t -> t -> bool
      (** Same as [lt]. *)
  
      val (>): t -> t -> bool
      (** Same as [gt]. *)
  
      val (<=): t -> t -> bool
      (** Same as [leq]. *)
  
      val (>=): t -> t -> bool
      (** Same as [geq]. *)
  
      val (<>): t -> t -> bool
      (** [a <> b] is equivalent to [not (equal a b)]. *)
  
    end
    val version : string
    val round_to_float : t -> bool -> float *)
  end
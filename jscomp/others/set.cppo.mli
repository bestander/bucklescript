#ifdef TYPE_STRING
type elt = string
#elif defined TYPE_INT
type elt = int
#else 
[%error "unknown type"]
#endif 
(** The type of the set elements. *)


type t
(** The type of sets. *)

val empty: t


val isEmpty: t -> bool

val mem: t -> elt -> bool


val add:  t -> elt -> t
(** If [x] was already in [s], [s] is returned unchanged. *)

val singleton: elt -> t
(** [singleton x] returns the one-element set containing only [x]. *)

val remove:  t -> elt -> t
(**  If [x] was not in [s], [s] is returned unchanged. *)

val union: t -> t -> t

val inter: t -> t -> t

val diff: t -> t -> t


val cmp: t -> t -> int
(** Total ordering between sets. Can be used as the ordering function
   for doing sets of sets. *)

val eq: t -> t -> bool
(** [eq s1 s2] tests whether the sets [s1] and [s2] are
   equal, that is, contain equal elements. *)

val subset: t -> t -> bool
(** [subset s1 s2] tests whether the set [s1] is a subset of
   the set [s2]. *)

val iter: t -> (elt -> unit [@bs]) ->  unit
(** [iter f s] applies [f] in turn to all elements of [s].
   The elements of [s] are presented to [f] in increasing order
   with respect to the ordering over the type of the elements. *)

val fold: t -> 'a -> ('a -> elt ->  'a [@bs]) ->  'a
(** Iterate in increasing order. *)

val forAll: t -> (elt -> bool [@bs]) ->  bool
(** [for_all p s] checks if all elements of the set
   satisfy the predicate [p]. Order unspecified. *)

val exists: t -> (elt -> bool [@bs]) ->  bool
(** [exists p s] checks if at least one element of
   the set satisfies the predicate [p]. Oder unspecified. *)

val filter: t -> (elt -> bool [@bs]) ->  t
(** [filter p s] returns the set of all elements in [s]
   that satisfy predicate [p]. *)

val partition: t -> (elt -> bool [@bs]) ->  t * t
(** [partition p s] returns a pair of sets [(s1, s2)], where
   [s1] is the set of all the elements of [s] that satisfy the
   predicate [p], and [s2] is the set of all the elements of
   [s] that do not satisfy [p]. *)

val length: t -> int

val toList: t -> elt list
(** Return the list of all elements of the given set.
   The returned list is sorted in increasing order with respect
   to the ordering [Ord.compare], where [Ord] is the argument
   given to {!Set.Make}. *)

val toArray: t -> elt array  

val minOpt: t -> elt option
val minNull: t -> elt Js.null
val maxOpt: t -> elt option
val maxNull: t -> elt Js.null


val split: elt -> t -> t * bool * t
(** [split x s] returns a triple [(l, present, r)], where
      [l] is the set of elements of [s] that are
      strictly less than [x];
      [r] is the set of elements of [s] that are
      strictly greater than [x];
      [present] is [false] if [s] contains no element equal to [x],
      or [true] if [s] contains an element equal to [x]. *)

val findOpt: elt -> t -> elt option


val ofArray : elt array -> t     

val checkInvariant : t -> bool 

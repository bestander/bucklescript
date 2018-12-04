# 1 "x_typed_array.ml.cppo"
type array_buffer
type 'a array_like
    

# 60
 
  (* [elt] *) 
  type 'a typed_array 
  type t = int typed_array 
  external unsafe_get : t -> int -> int  = "" [@@bs.get_index] 
  external unsafe_set : t -> int -> int -> unit = "" [@@bs.set_index] 
  external buffer : t -> array_buffer = "" [@@bs.get] 
  external byteLength : t -> int = "" [@@bs.get] 
  external byteOffset : t -> int = "" [@@bs.get] 
  external setArray : int array -> unit = "set" [@@bs.send.pipe: t] 
  external setArrayOffset : int array -> int -> unit = "set" [@@bs.send.pipe: t] 
  (* There's also an overload for typed arrays, but don't know how to model that without subtyping *) 
  external length : t -> int = "" [@@bs.get] 
  (* Mutator functions  *) 
  external copyWithin : to_:int -> t = "" [@@bs.send.pipe: t] 
  external copyWithinFrom : to_:int -> from:int -> t = "copyWithin" [@@bs.send.pipe: t] 
  external copyWithinFromRange : to_:int -> start:int -> end_:int -> t = "copyWithin" [@@bs.send.pipe: t] 
  external fillInPlace : int -> t = "fill" [@@bs.send.pipe: t] 
  external fillFromInPlace : int -> from:int -> t = "fill" [@@bs.send.pipe: t] 
  external fillRangeInPlace : int -> start:int -> end_:int -> t = "fill" [@@bs.send.pipe: t] 
  external reverseInPlace : t = "reverse" [@@bs.send.pipe: t] 
  external sortInPlace : t = "sort" [@@bs.send.pipe: t] 
  external sortInPlaceWith : (int -> int -> int [@bs]) -> t = "sort" [@@bs.send.pipe: t] 
  (* Accessor functions  *) 
  external includes : int -> Js.boolean = "" [@@bs.send.pipe: t] (** ES2016 *) 
  external indexOf : int  -> int = "" [@@bs.send.pipe: t] 
  external indexOfFrom : int -> from:int -> int = "indexOf" [@@bs.send.pipe: t] 
  external join : string = "" [@@bs.send.pipe: t] 
  external joinWith : string -> string = "join" [@@bs.send.pipe: t] 
  external lastIndexOf : int -> int = "" [@@bs.send.pipe: t] 
  external lastIndexOfFrom : int -> from:int -> int = "lastIndexOf" [@@bs.send.pipe: t] 
  external slice : start:int -> end_:int -> t = "" [@@bs.send.pipe: t] 
  external copy : t = "slice" [@@bs.send.pipe: t] 
  external sliceFrom : int -> t = "slice" [@@bs.send.pipe: t] 
  external toString : string = "" [@@bs.send.pipe: t] 
  external toLocaleString : string = "" [@@bs.send.pipe: t] 
  external every : (int  -> Js.boolean [@bs]) -> Js.boolean = "" [@@bs.send.pipe: t] 
  external everyi : (int -> int -> Js.boolean [@bs]) -> Js.boolean = "every" [@@bs.send.pipe: t] 
  (** should we use [bool] or [boolan] seems they are intechangeable here *) 
  external filter : (int -> bool [@bs]) -> t = "" [@@bs.send.pipe: t] 
  external filteri : (int -> int  -> Js.boolean[@bs]) -> t = "filter" [@@bs.send.pipe: t] 
  external find : (int -> bool [@bs]) -> int Js.undefined = "" [@@bs.send.pipe: t] 
  external findi : (int -> int -> bool [@bs]) -> int Js.undefined  = "find" [@@bs.send.pipe: t] 
  external findIndex : (int -> bool [@bs]) -> int = "" [@@bs.send.pipe: t] 
  external findIndexi : (int -> int -> bool [@bs]) -> int = "findIndex" [@@bs.send.pipe: t] 
  external forEach : (int -> unit [@bs]) -> unit = "" [@@bs.send.pipe: t] 
  external forEachi : (int -> int -> unit [@bs]) -> unit  = "forEach" [@@bs.send.pipe: t] 
  external map : (int  -> 'b [@bs]) -> 'b typed_array = "" [@@bs.send.pipe: t] 
  external mapi : (int -> int ->  'b [@bs]) -> 'b typed_array = "map" [@@bs.send.pipe: t] 
  external reduce :  ('b -> int  -> 'b [@bs]) -> 'b -> 'b = "" [@@bs.send.pipe: t] 
  external reducei : ('b -> int -> int -> 'b [@bs]) -> 'b -> 'b = "reduce" [@@bs.send.pipe: t] 
  external reduceRight :  ('b -> int  -> 'b [@bs]) -> 'b -> 'b = "" [@@bs.send.pipe: t] 
  external reduceRighti : ('b -> int -> int -> 'b [@bs]) -> 'b -> 'b = "reduceRight" [@@bs.send.pipe: t] 
  external some : (int  -> Js.boolean [@bs]) -> Js.boolean = "" [@@bs.send.pipe: t] 
  external somei : (int  -> int -> Js.boolean [@bs]) -> Js.boolean = "some" [@@bs.send.pipe: t] 

  
# 62
  (* Iteration functions
  *)
  (* commented out until bs has a plan for iterators
  external entries : (int * elt) array_iter = "" [@@bs.send.pipe: t]
  *)

  (* commented out until bs has a plan for iterators
  external keys : int array_iter = "" [@@bs.send.pipe: t]
  *)

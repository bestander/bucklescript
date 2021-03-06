(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)
(** Adapted by authors of BuckleScript without using functors          *)


type ('k, + 'v) node  = {
  left : ('k,'v) node Js.null;
  key : 'k; 
  value : 'v; 
  right : ('k,'v) node Js.null;
  h : int 
} [@@bs.deriving abstract]

external toOpt : 'a Js.null -> 'a option = "#null_to_opt"
external return : 'a -> 'a Js.null = "%identity"
external empty : 'a Js.null = "#null" 

type ('key, 'a, 'id) t0 = ('key, 'a) node Js.null

type ('key, 'a, 'id) enumeration0 =
    End 
  | More of 'key * 'a * ('key, 'a, 'id) t0 * ('key, 'a, 'id) enumeration0

let height (n : _ t0) =
  match toOpt n with 
    None -> 0
  | Some n -> h n 

let create l x d r =
  let hl, hr  = height l,  height r in
  return @@ node ~left:l ~key:x ~value:d ~right:r ~h:(if hl >= hr then hl + 1 else hr + 1)

let singleton0 x d = 
  return @@ node ~left:empty ~key:x ~value:d ~right:empty ~h:1

let bal l x d r =
  let hl = match toOpt l with None -> 0 | Some n -> h n in
  let hr = match toOpt r with None -> 0 | Some n -> h n in
  if hl > hr + 2 then begin
    match toOpt l with
      None -> assert false
    | Some n (* Node(ll, lv, ld, lr, _) *) ->
      let ll,lv,ld,lr = left n, key n, value n, right n in  
      if height ll >= height lr then
        create ll lv ld (create lr x d r)
      else begin
        match toOpt lr with
          None -> assert false
        | Some n (* Node(lrl, lrv, lrd, lrr, _) *) ->
          let lrl, lrv, lrd,lrr = left n, key n, value n, right n in 
          create (create ll lv ld lrl) lrv lrd (create lrr x d r)
      end
  end else if hr > hl + 2 then begin
    match toOpt r with
      None -> assert false
    | Some n (* Node(rl, rv, rd, rr, _) *) ->
      let rl, rv, rd, rr = left n, key n, value n, right n in  
      if height rr >= height rl then
        create (create l x d rl) rv rd rr
      else begin
        match toOpt rl with
          None -> assert false
        | Some n (* Node(rll, rlv, rld, rlr, _) *)  ->
          let rll, rlv,rld,rlr = left n, key n, value n, right n in 
          create (create l x d rll) rlv rld (create rlr rv rd rr)
      end
  end else
    return @@ node ~left:l ~key:x ~value:d ~right:r ~h:(if hl >= hr then hl + 1 else hr + 1)

let empty0 = empty

let isEmpty0 x = match toOpt x with None -> true | Some _ -> false

let rec minBindingAux n =  
  match toOpt (left n) with 
  | None -> key n , value n 
  | Some n -> minBindingAux n 

let rec minBinding0 n = 
  match toOpt n with 
    None -> None
  | Some n -> Some (minBindingAux n)

let rec maxBindingAux n =   
  match toOpt (right n) with 
  | None -> key n, value n 
  | Some n -> maxBindingAux n 

let rec maxBinding0 n =
  match toOpt n with 
  | None -> None 
  | Some n -> Some (maxBindingAux n)

(* only internal use for a non empty map*)  
let rec removeMinAux n = 
  let ln, rn = left n , right n in 
  match toOpt ln with 
  | None -> rn
  | Some ln -> bal (removeMinAux ln) (key n) (value n) rn 


let merge t1 t2 =
  match (toOpt t1, toOpt t2) with
    (None, _) -> t2
  | (_, None) -> t1
  | (_, Some t2n) ->
    let (x, d) = minBindingAux t2n in
    bal t1 x d (removeMinAux t2n)

let rec iter0 f  n = 
  match toOpt n with 
  | None -> () 
  | Some n -> (* Node(l, v, d, r, _) *)
    let l, v, d, r = left n, key n, value n, right n in   
    iter0 f l; f v d [@bs]; iter0 f r

let rec map0 f n = 
  match toOpt n with
    None  ->
    empty
  | Some n (* Node(l, v, d, r, h) *) ->
    let l, v, d, r, h = left n,  key n, value n, right n, h n  in 
    let l' = map0 f l in
    let d' = f d [@bs] in
    let r' = map0 f r in
    return @@ node ~left:l' ~key:v ~value:d' ~right:r' ~h

let rec mapi0 f n =
  match toOpt n with 
    None ->
    empty
  | Some n (* Node(l, v, d, r, h) *) ->
    let l, v, d, r, h = left n,  key n, value n, right n, h n  in 
    let l' = mapi0 f l in
    let d' = f v d [@bs] in
    let r' = mapi0 f r in
    return @@ node ~left:l' ~key:v ~value:d' ~right:r' ~h

let rec fold0 f m accu =
  match toOpt m with
    None -> accu
  | Some n (* Node(l, v, d, r, _) *) ->
    let l, v, d, r = left n,  key n, value n, right n in 
    fold0 f r (f v d (fold0 f l accu) [@bs])

let rec forAll0 p n =
  match toOpt n with 
    None -> true
  | Some n (* Node(l, v, d, r, _) *) ->
    let l, v, d, r = left n,  key n, value n, right n in 
    p v d [@bs] && forAll0 p l && forAll0 p r

let rec exists0 p n = 
  match toOpt n with 
    None -> false
  | Some n (* Node(l, v, d, r, _) *) ->
    let l, v, d, r = left n,  key n, value n, right n  in 
    p v d [@bs] || exists0 p l || exists0 p r

(* Beware: those two functions assume that the added k is *strictly*
   smaller (or bigger) than all the present keys in the tree; it
   does not test for equality with the current min (or max) key.

   Indeed, they are only used during the "join" operation which
   respects this precondition.
*)

let rec add_minBinding k v n = 
  match toOpt n with
  | None -> singleton0 k v
  | Some n (* Node (l, x, d, r, h) *) ->
    let l, x, d, r = left n,  key n, value n, right n  in 
    bal (add_minBinding k v l) x d r

let rec add_maxBinding k v n = 
  match toOpt n with 
  | None -> singleton0 k v
  | Some n (* Node (l, x, d, r, h) *) ->
    let l, x, d, r = left n,  key n, value n, right n in 
    bal l x d (add_maxBinding k v r)

(* Same as create and bal, but no assumptions are made on the
   relative heights of l and r. *)

let rec join ln v d rn =
  match (toOpt ln, toOpt rn) with
    (None, _) -> add_minBinding v d rn (* could be inlined *)
  | (_, None) -> add_maxBinding v d ln (* could be inlined *)
  | Some l, Some r (* (Node(ll, lv, ld, lr, lh), Node(rl, rv, rd, rr, rh)) *) ->
    let (ll, lv, ld, lr, lh) = left l, key l, value l, right l, h l in 
    let (rl, rv, rd, rr, rh) = left r, key r, value r, right r, h r in  
    if lh > rh + 2 then bal ll lv ld (join lr v d rn) else
    if rh > lh + 2 then bal (join ln v d rl) rv rd rr else
      create ln v d rn

(* Merge two trees l and r into one.
   All elements of l must precede the elements of r.
   No assumption on the heights of l and r. *)

let concat t1 t2 =
  match (toOpt t1, toOpt t2) with
    (None, _) -> t2
  | (_, None) -> t1
  | (_, Some t2n) ->
    let (x, d) = minBindingAux t2n in
    join t1 x d (removeMinAux t2n)

let concat_or_join t1 v d t2 =
  match d with
  | Some d -> join t1 v d t2
  | None -> concat t1 t2    

let rec filter0 p n = 
  match toOpt n with 
    None -> n
  | Some n (* Node(l, v, d, r, _) *) ->
    (* call [p] in the expected left-to-right order *)
    let l, v, d, r = left n,  key n, value n, right n  in 
    let l' = filter0 p l in
    let pvd = p v d [@bs] in
    let r' = filter0 p r in
    if pvd then join l' v d r' else concat l' r'

let rec partition0 p n = 
  match toOpt n with   
    None -> (empty, empty)
  | Some n (* Node(l, v, d, r, _) *) ->
    let l, v, d, r = left n,  key n, value n, right n  in
    (* call [p] in the expected left-to-right order *)    
    let (lt, lf) = partition0 p l in
    let pvd = p v d [@bs] in
    let (rt, rf) = partition0 p r in
    if pvd
    then (join lt v d rt, concat lf rf)
    else (concat lt rt, join lf v d rf)  

let rec cons_enum m e =
  match toOpt m with
    None -> e
  | Some n (* Node(l, v, d, r, _) *) -> 
    let l, v, d, r = left n,  key n, value n, right n in 
    cons_enum l (More(v, d, r, e))

let rec cardinalAux n = 
  let l, r = left n, right n in  
  let sizeL = 
    match toOpt l with 
    | None -> 0
    | Some l -> 
      cardinalAux l  in 
  let sizeR = 
    match toOpt r with 
    | None -> 0
    | Some r -> cardinalAux r in 
  1 + sizeL + sizeR      

let rec cardinal0 n =
  match toOpt n with 
  | None -> 0
  | Some n  ->
    cardinalAux n   

let rec bindings_aux accu n = 
  match toOpt n with 
  | None -> accu
  | Some n (* Node(l, v, d, r, _) *) ->
    let l, v, d, r = left n,  key n, value n, right n in 
   bindings_aux ((v, d) :: bindings_aux accu r) l

let bindings0 s =
  bindings_aux [] s  


let rec checkInvariant (v : _ t0) = 
  match toOpt v with 
  | None -> true 
  | Some n -> 
    let l,r = left n , right n in 
    let diff = height l - height r  in 
    diff <=2 && diff >= -2 && checkInvariant l && checkInvariant r 

  
open Printf

type path_element = Cell | Field of string

let count_node counters path =
  try incr (Hashtbl.find counters path)
  with Not_found -> Hashtbl.add counters path (ref 1)

let rec count counters path json =
  match json with
      `List l ->
        count_node counters path;
        List.iter (count counters (Cell :: path)) l
    | `Assoc l ->
        count_node counters path;
        List.iter (fun (k, v) -> count counters (Field k :: path) v) l
    | `Null -> ()
    | atom ->
        count_node counters path

let string_of_key l =
  let buf = Buffer.create 100 in
  List.iter (
    function
        Cell -> Buffer.add_string buf "[]"
      | Field s -> bprintf buf ".%s" s
  ) (List.rev l);
  Buffer.contents buf

let output_counts oc counters =
  let l =
    Hashtbl.fold
      (fun k counter acc -> (string_of_key k, !counter) :: acc) counters []
  in
  let l = List.sort (fun (a, _) (b, _) -> String.compare a b) l in
  List.iter (fun (k, n) -> fprintf oc "%s %i\n" k n) l;
  flush oc

let init () = Hashtbl.create 1000

let main () =
  if Array.length Sys.argv <> 1 then (
    eprintf "\
Usage: jsoncount
reads JSON data from stdin and reports the number of occurrences
of each field.

The following rules are followed:

  * null values are not counted
  * array cells are counted regardless of the index
  * empty arrays and empty objects are counted
";
    exit 1
  )
  else
    let counters = init () in
    Stream.iter (count counters []) (Yojson.Basic.stream_from_channel stdin);
    output_counts stdout counters

let () = main ()

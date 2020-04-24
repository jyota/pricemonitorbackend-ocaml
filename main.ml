(*
open Lwt
open Cohttp
open Cohttp_lwt_unix

let body =
  let headers = Cohttp.Header.init_with "Accept-Encoding" "text/html" in
  Client.get ~headers (Uri.of_string "https://www.amazon.com/Shin-Megami-Tensei-Nocturne-playstation-2/dp/B00024W1U6") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let () =
  let body = Lwt_main.run body in
  print_endline body

*)

open Soup
open Str


let read_whole_file filename =
    let ch = open_in filename in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s;;

let sTarget = "19.45";;

let find_match str1 str2 =
  let re = Str.regexp_string str1 in
    try ignore (Str.search_forward re str2 0); true
    with Not_found -> false;;


let rec build_path (el:element node) (currstr:string) (hitstr:string) = 
  try
    let parent = R.parent el in 
    let path = (name el ^ "." ^ currstr) in
    if hitstr = "" then 
      if (has_attribute "class" el) && find_match "pric" (R.attribute "class" el) 
      then build_path parent path path 
      else build_path parent path ""
    else 
      build_path parent path hitstr
  with Failure _ -> (currstr, hitstr)
;;

let print_two =
  function
  | (a, b) ->
    Printf.printf "Path: %s, Hit: %s\n" a b
;;

let soup = read_whole_file "test_input.html" 
|> parse in 
  soup $ "html" |> descendants |> filter (fun e -> no_children e) |> filter (fun e -> find_match sTarget (R.leaf_text e))
  |> iter (fun e -> print_two (build_path (R.parent e) "" "")
    )
;;


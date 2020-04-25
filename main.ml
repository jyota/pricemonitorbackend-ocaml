open Opium.Std


let test_pgocaml =
  get "/admin_user" (fun _req ->
      let dbh = PGOCaml.connect() in
        let get_email = [%pgsql dbh "select email from public.users where first_name = 'Admin'"] in 
            let email = get_email 
            |> List.hd 
            |> function
                | Some(x) -> x
                | None -> raise(Failure "Db query didn't work")
            in
            `Json Ezjsonm.(dict [("email", string email)]) |> respond')

let default =
  not_found (fun _req ->
      `Json Ezjsonm.(dict [("message", string "Route not found")]) |> respond')

let _ =
  App.empty |> test_pgocaml |> default
  |> App.run_command

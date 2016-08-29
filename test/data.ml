let evaluation : unit -> Ojs.t =
  fun () ->
    let format_month = function
      | "janvier" -> "01"
      | "février" -> "02"
      | "mars" -> "03"
      | "avril" -> "04"
      | "mai" -> "05"
      | "juin" -> "06"
      | "juillet" -> "07"
      | "août" -> "08"
      | "septembre" -> "09"
      | "octobre" -> "10"
      | "novembre" -> "11"
      | "décembre" -> "12"
      | s -> s
    in
    let document = Js_dom.document in
    let team1_name = document#query_selector ".club_dom .club" in
    let team1_name = team1_name#inner_text in
    let team2_name = document#query_selector ".club_ext .club" in
    let team2_name = team2_name#inner_text in
    let buts = document#query_selector_all ".buts" in
    let score =
      match buts with
      | [elt1; elt2] -> (elt1#inner_text)^" - "^(elt2#inner_text)
      | _ -> "" in
    let query = ".contenu_box.match_stats p" in
    let date_stadium = document#query_selector_all query in
    let date_stadium =
      match date_stadium with
      | _::elt::_ -> elt#inner_text
      | _ -> " - " in
    let date_stadium =
      let expr = Re.str " - " in
      let expr = Re.compile expr in
      Re.split expr date_stadium
    in
    let date,stadium =
      match date_stadium with
      | [elt1;elt2] -> elt1, Some(elt2)
      | _ -> "", None in
    let day,month,year =
      let expr = Re.str " " in
      let expr = Re.compile expr in
      match Re.split expr date with
      | [_;elt1;elt2;elt3] -> elt1,elt2,elt3
      | _ -> assert false
    in
    let month = format_month month in
    let date = Some(Printf.sprintf "%s-%s-%s" year month day) in
    Fixture.(
      let team1 = {name=team1_name;
                   number=1;
                   avatar="blop";
                   goals=[];
                   cards=[];
                   holders=[];
                   substitutes=[];
                   coach=None} in
      let team2 = {name=team2_name;
                   number=2;
                   avatar="blip";
                   goals=[];
                   cards=[];
                   holders=[];
                   substitutes=[];
                   coach=None} in
      let fixtu = Some(score),
                  date,
                  stadium,
                  team1, team2 in
      Fixture_js.t_to_js fixtu)

(*
let _ = Js.Unsafe.global##.ocaml_nightmare_evaluation := (Js.Unsafe.callback evaluation)
*)

let () = Node_nightmare.set_evaluation_fn evaluation

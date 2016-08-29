let json = Node.require "jsonfile";;
let n = Node_nightmare.create true;;
Node_nightmare.goto n "http://www.lfp.fr/ligue2/feuille_match/80313";;
Node_nightmare.inject_js n "data.js";;
(*Node_nightmare.evaluate n (Js.Unsafe.js_expr
                        "function test(){
                           return ocaml_nightmare_evaluation();
                         }");;*)
Node_nightmare.evaluate_implicit n;;
Node_nightmare.end_ n ();;
(*Node_nightmare.catch n (fun s -> Jsoo_lib.console_log (Ojs.string_of_js s));;*)
Node_nightmare.then_ n (fun s ->
    Node_jsonfile.write_file_sync json "file.json" s
  );;

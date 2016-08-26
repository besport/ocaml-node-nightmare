#OCaml Nightmare

**WARNING:** This binding is partial.

## What is ocaml-node-nightmare?

ocaml-node-nightmare is a binding to the node module nightmare in OCaml using gen_js_api. It will let you use nightmare directly in OCaml

## How to install?

You need to switch to OCaml >= **4.03.0** (due to gen_js_api):

`opam switch 4.03.0`

First, you need to install [ocaml-node](https://github.com/besport/ocaml-node.git) if you haven't already installed it

To install this package use the command:

`opam pin add ocaml-node-nightmare https://github.com/besport/ocaml-node-nightmare.git`

## How to use?

When using Nightmare JS binding with OCaml, you need to have two different ml files:
- One containing the function evaluating the webpage
- One containing the instructions to be executed by nodejs (once compiled in js)

 Here is an example:

```JavaScript
var Nightmare = require("nightmare");
var nightmare = Nightmare({show : true});

nightmare.goto("https://www.google.com/?q=github#safe=off&q=github")
         .evaluate(function (){
           var first_result = document.querySelector(".r");
           if(first_result != null)
             return first_result.innerText;
           else
             return "No result";
         })
         .end()
         .then(function(result){
             console.log(result);
         })
         .catch(function(err){
            console.log("Error: "+err);
         });
```

Equivalent in OCaml using [gen_js_api](https://github.com/lexifi/gen_js_api) (for Ojs.t type) and [ocaml-js-stdlib](https://github.com/dannywillems/ocaml-js-stdlib) (for Js_dom and Js_core):

* In our `data.ml`:
```OCaml
let evaluation : unit -> Ojs.t =
    fun () ->
        let document = Js_dom.document in
        let first_result = document#query_selector ".r" in
        match first_result with
        | None      -> Ojs.string_to_js "No result"
        | Some(elt) -> Ojs.string_to_js (elt#inner_text)

(** This code will register the previous function for being evaluted when node calls nightmare.evaluate **)
let _ = set_evaluation_fn evaluation
```

* In our `test.ml`:
```OCaml
let n = Node_nightmare.create true in
let n = Node_nightmare.goto n "https://www.google.com/?q=github#safe=off&q=github" in
let () = Node_nightmare.inject_js "data.js" in
let n = Node_nightmare.evaluate_implicit n in
let n = Node_nightmare.end_ n () in
let n = Node_nightmare.then_ n
    (fun res ->
         let str = Ojs.string_of_js res in
         Js_core.log_string str) in
let n = Node_nightmare.catch n
    (fun err ->
         let str = Ojs.string_of_js err in
         Js_core.log_string ("Error: "^str)) in
()
```

## What about the full documentation?

You can find the full documentation of `nightmare` on the github repo: 
https://github.com/segmentio/nightmare.git

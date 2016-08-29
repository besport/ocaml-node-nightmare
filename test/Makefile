js:
	ocamlfind ocamlc -o test.byte -package gen_js_api,js_of_ocaml,js_of_ocaml.ppx,jsoo_lib,ocaml-node,ocaml-node-nightmare,ocaml-node-jsonfile -linkpkg -no-check-prims test.ml
	js_of_ocaml -o test.js +gen_js_api/ojs_runtime.js test.byte


data:
	ocamlfind ocamlc -o data.byte -package js_of_ocaml,js_of_ocaml.ppx,gen_js_api,ocaml-js-stdlib,str,bs-import-js,re,ocaml-node,ocaml-node-nightmare -no-check-prims -linkpkg data.ml
	js_of_ocaml +gen_js_api/ojs_runtime.js data.byte -o data.js

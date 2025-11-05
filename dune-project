(lang dune 3.20)

(name advent-of-code-cli)

(generate_opam_files true)

(source
 (github possessedc0bra/advent-of-code-cli))

(authors "Yannick Koller")

(maintainers "Yannick Koller")

(license MIT)

(package
 (name advent-of-code-cli)
 (synopsis "A CLI tool to help with Advent of Code")
 (description "A CLI tool to help with Advent of Code")
 (depends
  (ocaml
   (>= 5.3))
  (ocaml-lsp-server :with-dev-setup)
  (ocamlformat :with-dev-setup)
  dune-build-info
  dotenv
  cmdliner
  ezcurl
  ptime)
 (tags ("advent-of-code cli")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html

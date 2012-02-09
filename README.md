jsoncount
=========

jsoncount is a command-line tool that counts the number of occurrences of
nodes in a JSON file containing one or multiple JSON values.

The rules for counting are the following:

  * null values are not counted
  * array cells are counted regardless of the index
  * empty arrays and empty objects are counted


Installation
------------

Requires a standard installation of [OCaml](http://caml.inria.fr),
[ocamlfind](http://www.camlcity.org/archive/programming/findlib.html) and
[yojson](http://martin.jambon.free.fr/yojson).

```
$ make
$ make install  # Installation directory defaults to $HOME/bin.
```

PREFIX and BINDIR are supported, so if you want to install wcl in /usr/local,
just do:

```
$ sudo make PREFIX=/usr/local install
```

Uninstallation
--------------

```
$ make uninstall
```

# SLD-Tree-Generator

--------------------------------------------------------------------------------
HOW TO RUN THE SLD-TREE GENERATOR:
--------------------------------------------------------------------------------

The following steps show how to run the sld-tree generator as web-application
on your localhost.

--------------------------------------------------------------------------------
Setup:
--------------------------------------------------------------------------------

(0) Install SWI-Prolog, if it's not allready installed.

See http://www.swi-prolog.org/ for more information.

(1) Run the following to automatically download required modules/libraries.

$ cd extern/
$ swipl download.pl

If the download failes, you can also manually download the file processing.js
from http://processingjs.org/download/ and copy it to processing/processing.js.

--------------------------------------------------------------------------------
Run the SLD-Generator:
--------------------------------------------------------------------------------

(1) Load and compile the sld-tree generator.

$ swipl sld.pl

(2) Run SWI-Prologs built-in http-server.

?- start.

(3) Open http://localhost:5000/sld/ in your web-browser.

Note that all the files (html, js, pde and css) served by swi-prolog will be
available publicly, while requests for generating sld-trees will only work from
localhost.

--------------------------------------------------------------------------------

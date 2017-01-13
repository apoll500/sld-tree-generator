# SLD-Tree-Generator

    This program is aimed at calculation and display of sld-trees.
    
    Please note, that this is still work in progress. If you are looking for
    reusable code or a well developed software product, you might want to wait
    some time until development progresses. Nevertheless, your comments and
    feedback are very much appreciated.

--------------------------------------------------------------------------------
## How to run the sld-tree-generator:
--------------------------------------------------------------------------------

The following steps show how to run the sld-tree generator as web-application
on your localhost.

![alt text](http://www.andreaspollhammer.com/images/sh400/sld.png "Screenshot 400x215")

--------------------------------------------------------------------------------
### Setup:
--------------------------------------------------------------------------------

    0. Install SWI-Prolog, if it's not allready installed.
       See http://www.swi-prolog.org/ for more information.

    1. When you run sld-tree-generator for the first time,
       it will download processing.js. (See extern/readme.txt)

--------------------------------------------------------------------------------
### Run the SLD-Generator:
--------------------------------------------------------------------------------

    1. Load and compile the sld-tree generator.

       $ swipl sld.pl

    2. Run SWI-Prologs built-in http-server.

       ?- start.

    3. Open http://localhost:5000/sld/ in your web-browser.

Note that all the files (html, js, pde and css) served by swi-prolog will be
available publicly, while requests for generating sld-trees will only work from
localhost.

--------------------------------------------------------------------------------

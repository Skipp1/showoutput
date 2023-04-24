# showoutput 

Yet another LaTeX to text solution, similar to detex or pandoc. 
The difference with this solution is that it makes use of a little used LaTeX functionality.

LaTeX has a cool little command called `\showoutput`, when this command is run, any typeset information is outputted to the log file in a (almost) declarative form. 

For example this is what a sample hello world is given at the end of the document.

Other solutions to the TeX to text problem require parsing the TeX code itself, and having to try and understand what `\randomcmd` and `\begin{randomenv}` actually do.
We don't have to deal with that problem, as TeX has already handled all of the macro stuff.

## Usage

In your `.tex` file add the command `\showoutput` into your preamble.
Then run my program on the resulting `.log` file.

## Example showoutput

``` LaTeX 
\vbox(584.60443+0.0)x469.75499
.\glue 0.0
.\vbox(584.60443+0.0)x469.75499
..\vbox(0.0+0.0)x469.75499
...\glue 0.0 plus 1.0fil
...\hbox(0.0+0.0)x469.75499
....\hbox(0.0+0.0)x469.75499
..\glue 0.0
..\glue(\lineskip) 0.0
..\vbox(578.15999+0.0)x469.75499, glue set 568.15999fil
...\glue(\topskip) 3.05556
...\hbox(6.94444+0.0)x469.75499, glue set 397.22711fil
....\hbox(0.0+0.0)x20.0
....\OT1/cmr/m/n/10 H
....\OT1/cmr/m/n/10 e
....\OT1/cmr/m/n/10 l
....\OT1/cmr/m/n/10 l
....\OT1/cmr/m/n/10 o
....\glue 3.33333 plus 1.66666 minus 1.11111
....\OT1/cmr/m/n/10 W
....\kern-0.83334
....\OT1/cmr/m/n/10 o
....\OT1/cmr/m/n/10 r
....\OT1/cmr/m/n/10 l
....\OT1/cmr/m/n/10 d
....\penalty 10000
....\glue(\parfillskip) 0.0 plus 1.0fil
....\glue(\rightskip) 0.0
...\glue 0.0 plus 1.0fil
...\glue 0.0
..\glue(\lineskip) 0.0
..\hbox(6.44444+0.0)x469.75499
...\hbox(6.44444+0.0)x469.75499, glue set 232.37749fil
....\glue 0.0 plus 1.0fil
....\OT1/cmr/m/n/10 1
....\glue 0.0 plus 1.0fil
```

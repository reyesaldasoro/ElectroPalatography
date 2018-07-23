# ElectroPalatography
A repository of useful routines that can be used in Phonetics and Electropalatography

<h1>Convert LAB format to TextGrid Format</h1>


<p>In experiments of phonetics, there are different formats in which the phonemes can be segmented. This is typically done on a small phrase such as "the chalk, the soup, the sugar". There are different formats in which these are recorded, one of them is a file with extension .lab (for labels) which has a simple format with start time-stop time-phoneme:</p>

<pre class="codeinput">
0 0.25 sil

0.25 0.28 breath

0.28 0.35 sil

0.35 0.42 dh

0.42 0.5 i

</pre>

<p>See for instance the data base of MOCHA TIMIT (<a href="http://www.cstr.ed.ac.uk/research/projects/artic/mocha.html">http://www.cstr.ed.ac.uk/research/projects/artic/mocha.html</a>)</p>


<p>Another format is TextGrid, use by the popular software Praat (www.fon.hum.uva.nl/praat/). These files with extension .TextGrid have a more complicated format that allows to have words and phonemes. A file can look like this:</p>

<pre class="codeinput">
File type = "ooTextFile"

Object class = "TextGrid"

xmin = 0
xmax = 3.968

tiers? exists

size = 1 item []:

     item [1]:
              class = "IntervalTier"
              name = "phonemes"
              xmin = 0         
              xmax = 3.968         
              intervals: size = 51         
              intervals [1]:             
                   xmin = 0             
                   xmax = 0.7904913168586506             
                   text = ""         
                   intervals [2]:             
                   xmin = 0.7904913168586506             
                   xmax = 0.8708421929714597             
                   text = "g"
</pre>

<p>To convert from lab to textgrid you can use the following function:</p>
<pre class="codeinput">
TextGrid = Lab_to_TextGrid(dataIn);
</pre>


<p>dataIn can be two different options:

1) a single file name, the file will be read and converted to TextGrid and saved in the same folder where the .lab file is located

2) a folder, all the .lab files in the folder will be converted to TextGrid</p>


<p> The code requires one intermediate function to convert the lab file to a MATLAB Cell, this can be used separately to process phonemes in MATLAB. There is a parallel function to read TextGrid and convert to a MATLAB Cell.

</p>
<p class="footer"><br><a href="https://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2018a</a><br></p></div>

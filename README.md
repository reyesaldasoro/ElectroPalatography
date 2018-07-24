# ElectroPalatography
A repository of useful routines that can be used in Phonetics and Electropalatography

<h2>Convert LAB format to TextGrid Format</h2>


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

<h2>Convert LAB or TextGrid to a MATLAB Cell </h2>
<p> The function interpretLabelledPhonemes takes a file name as input and converts the phonemes, and words if available in TextGrid, to a MATLAB Cell. The function automatically detects the name of the file (it can end in "d" for TextGrid or "b" for lab), and calls the correct function, either convert_LAB_to_Phonemes.m or convert_TextGrid_to_Phonemes.

<pre class="codeinput">
[EPG_parameters] = interpretLabelledPhonemes(currentLAB_File,EPG_parameters);
</pre>

<p> For example:</p>

<pre class="codeinput">

>> currentLAB_File = 'MOCHA/fsew0_v1.1/fsew0_001.lab';
>> [EPG_parameters] = interpretLabelledPhonemes(currentLAB_File);
>> disp(EPG_parameters)
            LAB: {18×3 cell}
    numPhonemes: 18
          Words: []
       numWords: 0

>> disp(EPG_parameters.LAB)
    [     0]    [0.2500]    'sil'   
    [0.2500]    [0.2800]    'breath'
    [0.2800]    [0.3500]    'sil'   
    [0.3500]    [0.4200]    'dh'    
    [0.4200]    [0.5000]    'i'     
    [0.5000]    [0.6100]    's'     
    [0.6100]    [0.6400]    'w'     
    [0.6400]    [0.6800]    '@'     
    [0.6800]    [0.7500]    'z'     
    [0.7500]    [0.9200]    'ii'    
    [0.9200]    [0.9800]    'z'     
    [0.9800]    [1.1100]    'iy'    
    [1.1100]    [1.1800]    'f'     
    [1.1800]    [1.2500]    '@'     
    [1.2500]    [1.3500]    'r'     
    [1.3500]    [1.4200]    'uh'    
    [1.4200]    [1.6700]    's'     
    [1.6700]    [2.2000]    'sil'  
</pre>

<h2>Read the audio file </h2>
<p>The files for electropalatography are saved separately into several files:</p>

* .wav contains the audio file as a wave, in most cases the sample rate is also available from the same file

* .epg contains the electropalatography data, contacts with the electrodes of a palate

* .lab contains the labelled phonemes

* .TextGrid same as the  .lab, but with the format of PRAAT


<p> To read the audio file and automatically calculate some important parameters use the file readAudioFile like this:

<pre class="codeinput">
>> currentWAV_File = 'MOCHA/fsew0_v1.1/fsew0_001.wav';
>> [EPG_parameters]   = readAudioFile (currentLAB_File);
>> disp(EPG_parameters)
     audioWave: [35495×1 double]
    sampleRate: 16000
    numSamples: 35495
    timeVector: [1×35495 double]
     totalTime: 2.2184
     maxSignal: 0.4084
     minSignal: -0.4106

>> sound(EPG_parameters.audioWave,EPG_parameters.sampleRate)
</pre>

The last line will reproduce the sound.

<h2>Read the ElectroPalatography data  </h2>
<p>
The process of reading the ElectroPalatography data from an EPG file requires several files, readPalatogram.m, EPG_to_Palatogram.m, assymetry_projection.m and EPB_Boxes.mat. These are necessary as many things are calculated in this step. Among them the whole time frame of the palatograms and their asymmetry calculation, the asymmetry index (i.e. how asymmetric is every EPG recorded). It is recommended to read the audio file previously as the sample rate is necessary for some calculations.
</p>


<pre class="codeinput">
>> currentLAB_File = 'MOCHA/fsew0_v1.1/fsew0_001.wav';
>> currentEPG_File = 'MOCHA/fsew0_v1.1/fsew0_001.epg';
>> [EPG_parameters]   = readAudioFile (currentLAB_File);
>> EPG_parameters = readPalatogram(currentEPG_File,EPG_parameters);
>> disp(EPG_parameters)
                  audioWave: [35495×1 double]
                 sampleRate: 16000
                 numSamples: 35495
                 timeVector: [1×35495 double]
                  totalTime: 2.2184
                  maxSignal: 0.4084
                  minSignal: -0.4106
                  FrameRate: 200
                  numImages: 388
                       rows: 300
                       cols: 240
                       levs: 1
              EPGtimeVector: [1×388 double]
               EPGtotalTime: 1.9400
                   stepSamp: 80
                current_EPG: 'MOCHA/fsew0_v1.1/fsew0_001.epg'
                          v: []
                  asymIndex: [388×3 double]
                 Palatogram: [300×240×1×388 double]
             PalatogramAsym: [300×240×3×388 double]
        activeElectrodesCum: [300×240 double]
    asymmetricElectrodesCum: [300×240 double]

>>
</pre>

<h2>Short-Time Fourier Analysis  </h2>
<p>
To calculate the Short-Time Fourier Transform of the audio signal, together with a series of parameters, the function shortTimeFourierAnalysis is used in the following way:


<pre class="codeinput">

>> EPG_parameters=shortTimeFourierAnalysis(EPG_parameters);
>> disp(EPG_parameters)
                  audioWave: [35495×1 double]
                 sampleRate: 16000
                 numSamples: 35495
                 timeVector: [1×35495 double]
                  totalTime: 2.2184
                  maxSignal: 0.4084
                  minSignal: -0.4106
                  FrameRate: 200
                  numImages: 388
                       rows: 300
                       cols: 240
                       levs: 1
              EPGtimeVector: [1×388 double]
               EPGtotalTime: 1.9400
                   stepSamp: 80
                current_EPG: 'MOCHA/fsew0_v1.1/fsew0_001.epg'
                          v: []
                  asymIndex: [388×3 double]
                 Palatogram: [300×240×1×388 double]
             PalatogramAsym: [300×240×3×388 double]
        activeElectrodesCum: [300×240 double]
    asymmetricElectrodesCum: [300×240 double]
               lengthWindow: 0.0050
        timeTickVectorSound: [0 16000 32000]
       timeTickVectorSoundL: [0 1 2]
      timeTickVectorWindowL: [0 1 2 3 4 5]
       timeTickVectorWindow: [1 16.8000 32.6000 48.4000 64.2000 80]
     timeTickVectorSpectrum: [1 201]
    timeTickVectorSpectrumL: [0 1]
             freqTickVector: [8 16 24 32 40]
            freqTickVectorL: [1400 3000 4600 6200 7800]
                   maxSound: 0.3267
                   minSound: -0.3284
                maxSpectrum: 1.7651
                minSpectrum: 1.4185e-05
                  tempSound: [80×388 double]
               tempSpectrum: [40×388 double]
             tempTimeVector: [80×388 double]

>>

</pre>

<p> As you can see, all the parameters are saved in a single variable; EPG_parameters.</p>

<h1> Visualisation </h1>

<p>The variable EPG_parameters contains all that is required to perform a series of calculations and visualisations of the sound. The variables can be accessed directly, for instance:</p>

<pre class="codeinput">
plot(EPG_parameters.audioWave)
</pre>

![Audio wave](Figures/Manual_LabToTextGrid2_01.png)

<pre class="codeinput">
imagesc(EPG_parameters.PalatogramAsym(:,:,:,1))
</pre>

![Asymmetric Palatogram](Figures/Manual_LabToTextGrid2_02.png)

<pre class="codeinput">
montage(EPG_parameters.PalatogramAsym(:,:,:,1:130))
</pre>

![Montage of palatograms ](Figures/Manual_LabToTextGrid2_03.png)

<p>However, there are several specialised tools in this repository, which are described below.</p>





<h3> Display audio signal with Phonemes </h3>





<p class="footer"><br><a href="https://www.mathworks.com/products/matlab/">Published with MATLAB&reg; R2018a</a><br></p></div>

# Compare Phonemes

Comparison of the Palatograms of different Phonemes  in a series of phrases.

<img src="Figures/msak_d3.png" width="500" height="300" />


<h2>Reference</h2>

If you find these routines useful, please cite as:

<h3>
Verhoeven, J., Miller, N. R.,  & Reyes-Aldasoro, C. C. (2018). Analysis of the symmetry of electrodes for Electropalatography with Cone Beam CT Scanning. In Medical Image Understanding and Analysis, Southampton, UK, 09-11 July 2018.
</h3>


<a name="LabTextGrid"/>
<h2>Description of ComparePhonemes.m</h2>
</a>

<p>This file takes as input a folder where there are a number of phrases and calculates the palatograms 
     for each occurrence.
</p>


<h3> Select the speaker </h3>
<p> In our example there are 2 cases, msak and fsew, this will select the folder where
 each is stored
</p>
<pre class="codeinput">
 speaker     = 'msak';
%speaker     = 'fsew';
</pre>
<br/>


<h3>Select the base folder where the files (a number of files) is stored</h3>
<pre class="codeinput">
if strcmp(filesep,'\')
    baseDir     = strcat('D:\OneDrive - City, University of London\Acad\City_Research\JoVerhoeven\MOCHA_Relabelled\',speaker,'0_v1.1',filesep);
else
    baseDir     = strcat('/Users/ccr22/OneDrive - City, University of London/Acad/Research/JoVerhoeven/MOCHA_Relabelled/',speaker,'0_v1.1',filesep);
end
</pre>
<img src="Figures/FolderWithPhrases.png" width="500" height="300" />


<br/>


<h3>  </h3>
<p> Read the folder and determine the number of phrases (i.e. files)
</p>
<pre class="codeinput">
 dir0        = dir(strcat(baseDir,'*.mat'));
numPhrases  = size(dir0,1);

</pre>
<br/>


<h3>  define phonemes of interest in a list</h3>
<p> This is a list of the phonemes of interest, more or less can be defined by changing
% this line
</p>
<pre class="codeinput">
 listPhonemes    = {'n','d','t','r','ng','g','k','w','z','s','zh','sh','l','jh','ch'};
numPhonemes     = size(listPhonemes,2);


</pre>
<br/>


<h3> initialise the cell where results will be stored </h3>
<p>  All results will be stored in a cell, phoneme names on the first column, the
 palatograms for each phoneme per occurrence in the second, then the measurements of
 asymmetry in the columns 3-8. Notice that the size of the palatograms will be
 different depending on how many times and how long each time occurs.

</p>
<pre class="codeinput">
avPhoneme_tot{numPhonemes,8}=[];
for count_phoneme = 1:numPhonemes
    avPhoneme_tot{count_phoneme,1} = listPhonemes{count_phoneme};
end
</pre>
<br/>

<img src="Figures/avPhoneme_tot.png" width="500" height="300" />


calculate all the occurrences per phrase / per phoneme

<h3>  calculate all the occurrences per phrase / per phoneme</h3>
<p> 
</p>
<pre class="codeinput">
 for k=1:numPhrases
    % iterate over the phrases, it is assumed that the files were previously
    % calculated and save as MATLAB, but these can also be calculated from .wav,
    % .epg, .TextGrid/lab
    disp(dir0(k).name)
    load(strcat(baseDir,dir0(k).name));
    for count_phoneme = 1:size(listPhonemes,2)
        % Iterate now over the phonemes, this is very quick as the slow part is the
        % calculation of EPG_parameters
        avPhoneme_tot{count_phoneme,2} = extract_Phoneme_EPG(EPG_parameters,listPhonemes{count_phoneme},avPhoneme_tot{count_phoneme,2});
    end
end
</pre>
<br/>


<h3> Calculate asymmetries </h3>
<p> 
</p>
<pre class="codeinput">
 for k = 1:numPhonemes
    totalActivation     = sum(avPhoneme_tot{k,2}(:));
    frontActivation     = sum(sum(sum(avPhoneme_tot{k,2}(1:150,:,:))));
    backActivation      = sum(sum(sum(avPhoneme_tot{k,2}(151:300,:,:))));
    totalAsymmetry      = sum([sum(sum(avPhoneme_tot{k,2}(:,1:120,:)))          sum(sum(avPhoneme_tot{k,2}(:,121:240,:)))],3)/totalActivation;
    frontAsymmetry      = sum([sum(sum(avPhoneme_tot{k,2}(1:150,1:120,:)))      sum(sum(avPhoneme_tot{k,2}(1:150,121:240,:)))],3)/frontActivation;
    backAsymmetry       = sum([sum(sum(avPhoneme_tot{k,2}(151:300,1:120,:)))    sum(sum(avPhoneme_tot{k,2}(151:300,121:240,:)))],3)/backActivation;
    avPhoneme_tot{k,3}  = totalAsymmetry(1);
    avPhoneme_tot{k,4}  = totalAsymmetry(2);
    avPhoneme_tot{k,5}  = frontAsymmetry(1);
    avPhoneme_tot{k,6}  = frontAsymmetry(2);
    avPhoneme_tot{k,7}  = backAsymmetry(1);
    avPhoneme_tot{k,8}  = backAsymmetry(2);
end
</pre>
<br/>


<h3> Display </h3>
<p>  Basic display can be done in three ways:
 1) Displaying one of the occurrences of the phoneme:
</p>
<pre class="codeinput">
figure(1)
     imagesc(avPhoneme_tot{1,2}(:,:,1))
</pre>

<img src="Figures/One_occurrence.png" width="500" height="300" />



<p> 
 2)a projection of all the occurrences of the phoneme and this is done by adding them, 
</p>
<pre class="codeinput">
figure(2)
     imagesc(sum(avPhoneme_tot{1,2},3))
</pre>


<img src="Figures/Accummulated_occurrences.png" width="500" height="300" />


<p> 
 3) The other is a montage of all the cases:
</p>
<pre class="codeinput">
figure(3)
      montage(avPhoneme_tot{1,2}./(repmat(max(max(avPhoneme_tot{1,2})),[300 240 1])))

</pre>
<p> 
Since there may be longer or shorter occurrences, the number in each occurence
 needs to be 
</p>

<img src="Figures/Montage_occurrences.png" width="500" height="300" />

<h3> Batch Display </h3>
<p>
     To create figures for ALL the files in the folder, you can iterate over the number of Phonemes, and at 
     the same time, calculate the measurements of asymmetry:
     </p>
<pre class="codeinput">
jet2=jet;
jet2(1,:) =0;
for k = 1:numPhonemes
 
    figure(1)
    imagesc(sum(avPhoneme_tot{k,2},3));colorbar
    colormap(jet2)
    %  title(strcat('msak: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    combinedTitle{1}    = strcat(speaker,': [',32,avPhoneme_tot{k,1},32,']');
    combinedTitle{2}    = strcat('Total Asym:',32,num2str(avPhoneme_tot{k,3}),32,'/',32,num2str(avPhoneme_tot{k,4}));
    combinedTitle{3}    = strcat('Front Asym:',32,num2str(avPhoneme_tot{k,5}),32,'/',32,num2str(avPhoneme_tot{k,6}));
    combinedTitle{4}    = strcat('Back  Asym:',32,num2str(avPhoneme_tot{k,7}),32,'/',32,num2str(avPhoneme_tot{k,8}));
    
    title(combinedTitle,'fontsize',12)
    %  title(strcat('fsew: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    axis off
    
    %  filename=strcat('msak_sum_',avPhoneme_tot{k,1});
    filename=strcat(speaker,'_sum_',avPhoneme_tot{k,1});
    set(gcf,'color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    print('-djpeg','-r100',filename)
    
    
    figure(2)
    montage(avPhoneme_tot{k,2}./(repmat(max(max(avPhoneme_tot{k,2})),[300 240 1])))
    colormap(jet2)
    %  title(strcat('msak: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    title(strcat(speaker,': [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(avPhoneme_tot{k,3}),'/',num2str(avPhoneme_tot{k,4})),'fontsize',15)
    drawnow
    pause(0.5)
    
    %  filename=strcat('msak_montage_',avPhoneme_tot{k,1});
    filename=strcat(speaker,'_montage_',avPhoneme_tot{k,1});
    set(gcf,'color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    print('-djpeg','-r100',filename)
    
    %sum([sum(sum(avPhoneme_d(:,1:120,:))) sum(sum(avPhoneme_d(:,121:240,:)))],3)/sum(avPhoneme_d(:))
end

</pre>
<br/>







<img src="Figures/fsew_n4.png" width="500" height="300" />




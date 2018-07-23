function TextGrid = Lab_to_TextGrid(dataIn)
%
% ----------------------------------------------------------------------------------
% This is a function to convert from LAB files to TextGrid files
% ----------------------------------------------------------------------------------
% Input     (dataIn) can be a file, and the 
% LAB has a very simple format with start time-stop time-phoneme
%
% 0 0.25 sil
% 0.25 0.28 breath
% 0.28 0.35 sil
% 0.35 0.42 dh
% 0.42 0.5 i
%
% TextGrid is a bit more complicated with some header, and posibility of several
% "tiers" that have words and phonemes. As an initial effort, this fuction converts
% only PHONEMES in one tier.
%

if isdir(dataIn)
    %%
    % all files in a folder will be converted
    dir0                        = dir(strcat(dataIn,'/*.lab'));
    numFiles                    = size(dir0,1);
    for counterFile = 1:numFiles
        disp(counterFile)
        Lab_to_TextGrid(strcat(dataIn,'/',dir0(counterFile).name));
    end
    %%
else
    % single file to be converted, data is read and stored in a cell
    %

    LAB                         = importdata(dataIn,' ');
    [Phonemes,numPhonemes]      = convert_LAB_to_Phonemes(LAB);
    
    % Start the conversion process, follow this syntax for the  header
       TextGrid{1,1}    = 'File type = "ooTextFile"';
       TextGrid{2,1}    = 'Object class = "TextGrid"';
       TextGrid{3,1}    = '';
       TextGrid{4,1}    = strcat('xmin = ',32,num2str(Phonemes{1,1})); 
       TextGrid{5,1}    = strcat('xmax = ',32,num2str(Phonemes{end,2})); 
       TextGrid{6,1}    = 'tiers? <exists>'; 
       TextGrid{7,1}    = 'size = 1 ';
       TextGrid{8,1}    = 'item []: ';
       TextGrid{9,1}    = '   item [1]:';
       TextGrid{10,1}   = '         class = "IntervalTier"'; 
       TextGrid{11,1}   = '         name = "phonemes" ';
       TextGrid{12,1}   = strcat('         xmin = ',32,num2str(Phonemes{1,1})); 
       TextGrid{13,1}   = strcat('         xmax = ',32,num2str(Phonemes{1,1})); 
       TextGrid{14,1}   = strcat('         intervals: size = ',32,num2str(numPhonemes));
       % header complete, now write all the phonemes
       for counterPhoneme = 1:numPhonemes          
           TextGrid{14+4*(counterPhoneme-1)+1,1}   = strcat('        intervals [',num2str(counterPhoneme),']');
           TextGrid{14+4*(counterPhoneme-1)+2,1}   = strcat('            xmin = ',32,num2str(Phonemes{counterPhoneme,1}));
           TextGrid{14+4*(counterPhoneme-1)+3,1}   = strcat('            xmax = ',32,num2str(Phonemes{counterPhoneme,2}));
           TextGrid{14+4*(counterPhoneme-1)+4,1}   = strcat('            text = "',(Phonemes{counterPhoneme,3}),'"');
       end
    
    % Save as a text file
    
    dataOutName         = strcat(dataIn(1:end-3),'TextGrid');
    writetable(cell2table(TextGrid),dataOutName,'FileType','text','WriteVariableNames',0)

    
    
end
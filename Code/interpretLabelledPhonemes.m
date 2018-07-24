function [EPG_parameters] = interpretLabelledPhonemes(currentLAB_File,EPG_parameters)

if strcmp(currentLAB_File(end),'b')
    % File is lab format

    LAB                         = importdata(currentLAB_File,' ');
    
    %% Interpret Labelled Phonemes
    [Phonemes,numPhonemes]      = convert_LAB_to_Phonemes(LAB);
    % Read the numLines
%     numPhonemes             = size(LAB,1);
%     Phonemes{numPhonemes,3}     = '';
%     for k=1:numPhonemes
%         % Each line is a {start end phoneme}
%         currLine            = LAB{k};
%         placesSpace         = strfind(currLine,' ');
%         Phonemes{k,1}           = str2double(currLine(1:placesSpace(1)-1));
%         Phonemes{k,2}           = str2double(currLine(placesSpace(1)+1:placesSpace(2)-1));
%         Phonemes{k,3}           = (currLine(placesSpace(2)+1:end));
%     end
    %%
    % No words are extracted from a LAB file
    Words=[];
    numWords = 0;
elseif strcmp(currentLAB_File(end),'d')
    [Phonemes,numPhonemes] = convert_TextGrid_to_Phonemes(currentLAB_File);
%     % File is TextGrid Format, it can have multiple IntervalTiers for words,
%     % phonemes, etc. 
%  
%     %% First, Read line by line and store local
%     fid                             = fopen(currentLAB_File);
%     numLines                        = 1;
%     LAB{numLines,1}                 = fgetl(fid);
%     while ischar(LAB{numLines})
%         numLines                    = numLines+1;
%         LAB{numLines,1}             = fgetl(fid);
%     end    
%     fclose(fid);
%     
%     %% Locate IntervalTiers
%     IntervalTierLocations                   = [];
%     for counterLines                        = 1:numLines
%         if ~isempty(strfind(LAB{counterLines},'IntervalTier'))
%             IntervalTierLocations           = [IntervalTierLocations counterLines];
%             limits_quote                    = strfind(LAB{counterLines+1},'"');
%             IntervalTierNames{numel(IntervalTierLocations)} = LAB{(counterLines)+1}(limits_quote(1)+1:limits_quote(2)-1);
%         end
%     end
%     %%
%     PositionPhonemes    = find((contains(IntervalTierNames,'phoneme')));
%     PositionWords       = find((contains(IntervalTierNames,'word')));
%     StartPhonemes       = IntervalTierLocations(PositionPhonemes);
%     StartWords          = IntervalTierLocations(PositionWords);
%     %%
%     IntervalTierLocations = [IntervalTierLocations counterLines+1];
%     EndPhonemes         = IntervalTierLocations(PositionPhonemes+1)-1; 
%     EndWords            = IntervalTierLocations(PositionWords+1)-1; 
%     
%     %% all lines are in the cell, find 'intervals: size'
% %     for counterLines = 1:numLines
% %         if ~isempty(strfind(LAB{counterLines},'intervals: size'))
% %             StartLine = counterLines+1;
% %         end
% %     end
%     %% Phonemes
%     for counterLines=StartPhonemes+5:4:EndPhonemes-1
%         %
%         currentInterval             = LAB{counterLines}(1+strfind(LAB{counterLines},'['):...
%                                                        -1+strfind(LAB{counterLines},']'));
%         Phonemes{str2num(currentInterval),1} = str2num(LAB{counterLines+1,1}(19:end));
%         Phonemes{str2num(currentInterval),2} = str2num(LAB{counterLines+2,1}(19:end));
%         currPhoneme                      = LAB{counterLines+3,1}(21:end-2);
%         if isempty(currPhoneme)
%         Phonemes{str2num(currentInterval),3} = 'sil';
%         else
%         Phonemes{str2num(currentInterval),3} = currPhoneme;
%             
%         end
%     end
%     
%     %% Words
%     for counterLines=StartWords+5:4:EndWords-1
%         %
%         currentInterval             = LAB{counterLines}(1+strfind(LAB{counterLines},'['):...
%                                                        -1+strfind(LAB{counterLines},']'));
%         Words{str2num(currentInterval),1} = str2num(LAB{counterLines+1,1}(19:end));
%         Words{str2num(currentInterval),2} = str2num(LAB{counterLines+2,1}(19:end));
%         currWord                      = LAB{counterLines+3,1}(21:end-2);
%         if isempty(currWord)
%         Words{str2num(currentInterval),3} = 'sil';
%         else
%         Words{str2num(currentInterval),3} = currWord;
%             
%         end
%     end
    
    
    %%
else
    % File not known
    disp('File name does not finish with "b" for .lab nor "d" for TextGrid.')
    disp('Please try again')
    EPG_parameters =[];
    return;
    
    
    
end
%%

EPG_parameters.Phonemes     = Phonemes;
EPG_parameters.numPhonemes  = numPhonemes;
EPG_parameters.Words        = Words;
EPG_parameters.numWords     = numWords;
function     [Phonemes,numPhonemes,Words,numWords] = convert_TextGrid_to_Phonemes(dataIn)


% File is TextGrid Format, it can have multiple IntervalTiers for words,
% phonemes, etc.

%% First, Read line by line and store local
fid                             = fopen(dataIn);
numLines                        = 1;
LAB{numLines,1}                 = fgetl(fid);
while ischar(LAB{numLines})
    numLines                    = numLines+1;
    LAB{numLines,1}             = fgetl(fid);
end
fclose(fid);

%% Locate IntervalTiers
IntervalTierLocations                   = [];
for counterLines                        = 1:numLines
    if ~isempty(strfind(LAB{counterLines},'IntervalTier'))
        IntervalTierLocations           = [IntervalTierLocations counterLines];
        limits_quote                    = strfind(LAB{counterLines+1},'"');
        IntervalTierNames{numel(IntervalTierLocations)} = LAB{(counterLines)+1}(limits_quote(1)+1:limits_quote(2)-1);
    end
end
%%
PositionPhonemes    = find((contains(IntervalTierNames,'phoneme')));
PositionWords       = find((contains(IntervalTierNames,'word')));
StartPhonemes       = IntervalTierLocations(PositionPhonemes);
StartWords          = IntervalTierLocations(PositionWords);
%%
IntervalTierLocations = [IntervalTierLocations counterLines+1];
EndPhonemes         = IntervalTierLocations(PositionPhonemes+1)-1;
EndWords            = IntervalTierLocations(PositionWords+1)-1;

%% all lines are in the cell, find 'intervals: size'
%     for counterLines = 1:numLines
%         if ~isempty(strfind(LAB{counterLines},'intervals: size'))
%             StartLine = counterLines+1;
%         end
%     end
%% Phonemes
for counterLines=StartPhonemes+5:4:EndPhonemes-1
    %
    currentInterval             = LAB{counterLines}(1+strfind(LAB{counterLines},'['):...
        -1+strfind(LAB{counterLines},']'));
    Phonemes{str2num(currentInterval),1} = str2num(LAB{counterLines+1,1}(19:end));
    Phonemes{str2num(currentInterval),2} = str2num(LAB{counterLines+2,1}(19:end));
    currPhoneme                      = LAB{counterLines+3,1}(21:end-2);
    if isempty(currPhoneme)
        Phonemes{str2num(currentInterval),3} = 'sil';
    else
        Phonemes{str2num(currentInterval),3} = currPhoneme;
        
    end
end
numPhonemes = size(Phonemes,1);
%% Words
for counterLines=StartWords+5:4:EndWords-1
    %
    currentInterval             = LAB{counterLines}(1+strfind(LAB{counterLines},'['):...
        -1+strfind(LAB{counterLines},']'));
    Words{str2num(currentInterval),1} = str2num(LAB{counterLines+1,1}(19:end));
    Words{str2num(currentInterval),2} = str2num(LAB{counterLines+2,1}(19:end));
    currWord                      = LAB{counterLines+3,1}(21:end-2);
    if isempty(currWord)
        Words{str2num(currentInterval),3} = 'sil';
    else
        Words{str2num(currentInterval),3} = currWord;
        
    end
end



if exist('PositionWords','var')
    if ~isempty(PositionWords)
        numWords                = size(Words,1);
    else
        numWords                = 0;
        Words                   = {''};
    end
else
    numWords                = 0;
    Words                   = {''};
end

if ~isempty(PositionPhonemes)
    numPhonemes             = size(Phonemes,1);
else
    numPhonemes             = 0;
    Phonemes                = {''};
end


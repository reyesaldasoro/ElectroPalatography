function [Phonemes,numPhonemes] = convert_LAB_to_Phonemes(LAB)

% Input may be a cell with the labelled phonemes or just the file from which these
% must be read
if ~isa(LAB,'cell')
    LAB = importdata(LAB,' ');
end
    %% Interpret Labelled Phonemes
    % Read the numLines    
    numPhonemes             = size(LAB,1);
    Phonemes{numPhonemes,3}     = '';
    for k=1:numPhonemes
        % Each line is a {start end phoneme}
        currLine            = LAB{k};
        placesSpace         = strfind(currLine,' ');
        Phonemes{k,1}           = str2double(currLine(1:placesSpace(1)-1));
        Phonemes{k,2}           = str2double(currLine(placesSpace(1)+1:placesSpace(2)-1));
        Phonemes{k,3}           = (currLine(placesSpace(2)+1:end));
    end
    
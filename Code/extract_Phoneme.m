function avPhoneme = extract_Phoneme_EPG(dataIn,desiredPhoneme,avPhoneme)
% A function that extracts the Palatogram corresponding to one phoneme in a
% sentence. If the phoneme occurs more than once, each occurrence is stored
% in one level of a 3D Matrix.
% ---------------------------------------------------------------------
% dataIn can be:
% 1) a struct of the form EPG_Parameters
% 2) a file location
%    2.a) where there is one .mat file with everything calculated
%    2.b) where there are 3 files .epg, .wav, .TextGrid
% 3) a folder location with a series of files as above
%
% desiredPhoneme is the phoneme from which the EPG will be extracted
%
% avPhoneme is the matrix where the output will be stored, and can be
% passed as an input parameter in cases where you want to read several
% files
% ---------------------------------------------------------------------

% A phoneme is required, if not, then exit
if ~exist('desiredPhoneme','var')
    disp('You should provide a phoneme to be extracted')
    avPhoneme =[];
    return;
end

% In case there is no variable for the avPhoneme, it is created with zeros
% numEventsPhoneme is used to store the next phoneme that is extracted
if ~exist('avPhoneme','var')
    avPhoneme = zeros(300,240);
    numEventsPhoneme =0;
else
    numEventsPhoneme = size(avPhoneme,3);
end

    
%%
if isa(dataIn,'struct')
    % 1) a struct of the form EPG_Parameters
    % This is useful when the EPG_parameters have been previously
    % calculated, so it is possible to extract many phonemes without having
    % to read every time
    EPG_parameters = dataIn;
    % find locations of a given phoneme.
    placePhoneme            = find(sum(strcmp(EPG_parameters.Phonemes,desiredPhoneme),2));
    if ~isempty(placePhoneme)
        %avPhoneme = zeros(300,240);
        for k3 = 1:numel(placePhoneme)
            initTime                = EPG_parameters.Phonemes{placePhoneme(k3),1};
            finTime                 = EPG_parameters.Phonemes{placePhoneme(k3),2};
            timePhoneme             = find((EPG_parameters.EPGtimeVector>initTime).*(EPG_parameters.EPGtimeVector<finTime));            
            % As a phoneme can occur several times in a phrase, the sum
            % will depend on how many times it occurs plus how long each
            % occurrence is
            avPhoneme2               = sum(EPG_parameters.Palatogram(:,:,:,timePhoneme),4);
            avPhoneme(:,:,numEventsPhoneme+k3) = avPhoneme2;            
        end
    end
    
elseif isfile(dataIn)
    if strcmp(dataIn(end-2:end),'mat')
        % 2.a) where there is one .mat file with everything calculated load
        % the file and call again with the EPG_parameters, it will go
        % directly to 1)
        load (dataIn,'EPG_parameters');
        avPhoneme               = extract_Phoneme_EPG(EPG_parameters,desiredPhoneme,avPhoneme);
    else
        % 2.b) a file location where there are 3 files .epg, .wav,
        % .TextGrid It will CALCULATE the EPG_parameters and then call
        % again with the EPG_parameters, it will go directly to 1) Notice
        % that this is slower than reading a previously calculated
        % EPG_parameters
        
        
        % find the last . to determine the extensions
        findStops               = strfind(dataIn,'.');
        baseName                = dataIn(1:findStops(end));
        % calculate all the names of the three required files
        currentWAV_File         = strcat(baseName,'wav');
        currentTEXTGRID_File    = strcat(baseName,'TextGrid');
        currentEPG_File         = strcat(baseName,'epg');
        % read the files and calculate the parameters
        EPG_parameters          = readAudioFile (currentWAV_File);
        EPG_parameters          = interpretLabelledPhonemes(currentTEXTGRID_File,EPG_parameters);
        EPG_parameters          = readPalatogram(currentEPG_File,EPG_parameters);
        % optionally you phonation, but for the time being it is not
        % necessary
        %EPG_parameters.Phonemes = add_Phonation_to_Phonemes(EPG_parameters.Phonemes);
        % Call the function again
        avPhoneme               = extract_Phoneme_EPG(EPG_parameters,desiredPhoneme,avPhoneme);
    end
    
elseif isfolder(dataIn)
    % 3) a folder location with a series of files as above
    % Will iterate over all the files    
    dir4_EPG            = dir(strcat(dataIn,filesep,'*.epg'));
    dir4_WAV            = dir(strcat(dataIn,filesep,'*.wav'));
    dir4_TextGrid       = dir(strcat(dataIn,filesep,'*.TextGrid'));
    
    numFiles            = size(dir4_EPG);
    
    %%
    % iterate over all the relabelled files
    for k2=1:numFiles
        % number of actual relabelled file
        numRelab        = str2double(dir4_EPG(k2).name(7:9));
        disp(strcat(' -----', num2str(numRelab) ,' ------'))
        
%%
        currentWAV_File         = strcat(dataIn,filesep,dir4_WAV(k2).name);
        currentTEXTGRID_File    = strcat(dataIn,filesep,dir4_TextGrid(k2).name);
        currentEPG_File         = strcat(dataIn,filesep,dir4_EPG(k2).name);        
        currentMAT_File         = strcat(dataIn,filesep,dir4_EPG(k2).name(1:end-3),'mat');
        
        if exist(currentMAT_File,'file')
            load (currentMAT_File,'EPG_parameters');
        else          
            EPG_parameters          = readAudioFile (currentWAV_File);
            EPG_parameters          = interpretLabelledPhonemes(currentTEXTGRID_File,EPG_parameters);
            EPG_parameters          = readPalatogram(currentEPG_File,EPG_parameters);
        end
        
        % optional to save the EPG_parameters as a *.mat file, useful later
        % on
        %save(currentMAT_File,'EPG_parameters')
        avPhoneme               = extract_Phoneme_EPG(EPG_parameters,desiredPhoneme,avPhoneme);        
    end
end

% Remove any level of avPhonemes with just zeros. It may have come from the
% initialisation
avPhoneme(:,:,find(sum(sum(avPhoneme))==0))=[];

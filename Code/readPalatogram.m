function EPG_parameters = readPalatogram(currentEPG_File,EPG_parameters)



%% ---------------- Palatograms  ------------
%Load the EPG file that contains the palatogram information in a coded way
currentEPG_Handle           = fopen(currentEPG_File);
EPG_data                    = fread(currentEPG_Handle);
fclose(currentEPG_Handle);
% %%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This assumes that the EPG data has 8 bytes of information that correspond to the
% rows of the palatogram and 4 extra bytes, if the format changes, then the number 12
% must be modified.
EPG_data2                   = reshape(EPG_data,12,numel(EPG_data)/12)';


%% -------------- Handles  ------------------
% Start allocating data into a single handles, called EPG_parameters (may not be the best
% name, possible to change later on)



% Calculate frame rate and other image parameters %SEE BELOW
EPG_parameters.FrameRate       = 200;
EPG_parameters.numImages       = size(EPG_data2,1);
EPG_parameters.rows            = 300;
EPG_parameters.cols            = 240;
EPG_parameters.levs            = 1;
EPG_parameters.EPGtimeVector   = (1:EPG_parameters.numImages)/EPG_parameters.FrameRate;
EPG_parameters.EPGtotalTime    = (EPG_parameters.numImages)/EPG_parameters.FrameRate;

% For the short window analysis, the windows will be determined by the ratio of the
% sampling frequency for the audio (e.g. 25660) and the frames per second of the video
% (e.g. 25.660) thus in this case it is 1000

%stepSamp                   = 1000;
EPG_parameters.stepSamp         = (EPG_parameters.sampleRate / EPG_parameters.FrameRate);

% Keep the name, 
EPG_parameters.current_EPG     = currentEPG_File;

% When the data was read from a video, this would hold the container for the video
% itself
EPG_parameters.v                = [];


%% Loop to create Images
% EPG_parameters will hold Palatogram and PalatogramAsym which are 4D variables with the
% palatograms in time [rows,columns, levels (1/3), time]

[EPG_parameters]                 = EPG_to_Palatogram (EPG_data2,EPG_parameters);


%%
%         62bit padded to 64bit, Raw binary WITH 4 EXTRA BYTES PREPENDED 
% 		TO THE START OF EACH FRAME. THIS MAKES 12 BYTES PER FRAME. (These 
% 		extra bytes are unused and will be deleted in future releases.)
% 		Frame rate of 200 frames per second. Each
% 		frame consists of 12x8bit words. Each bit of each word
% 		represents the on/off status of each contact in the
% 		palatogram. Ignore the first 4 words. The fifth word represents, 
% 		left to right, the front row of the palatogram (bits 0 and 7 are 
% 		unused), the last word represents the back row

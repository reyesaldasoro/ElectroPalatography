function [EPG_parameters]   = readAudioFile (currentWav)
% function [EPG_parameters]   = readAudioFile (currentWav)
%--------------------------------------------------------------------------
% Read the Audio File corresponding to a given phrase, this should be a
% file with the extension .wav.
% Output is saved into a single structure to which more data is later on
% attached.
% The files for electropalatography are saved separately into several files:
%       *.wav contains the audio file as a wave, in most cases the sample
%               rate is also available from the same file
%       *.epg contains the electropalatography data, contacts with the
%               electrodes of a palate
%       *.lab contains the labelled phonemes
%       *.TextGrid same as the *.lab, but with the format of PRAAT
%--------------------------------------------------------------------------


%% ---------------- AUDIO ------------------
% Read the audio signal from the video, the data will have n x 2 samples, one column
% for each channel
[audioWave,sampleRate]         = audioread(currentWav);
% The audio signal and Sample rate that have been read directly
EPG_parameters.audioWave       = audioWave;
EPG_parameters.sampleRate      = sampleRate;
% Calculate other Sound Parameters
EPG_parameters.numSamples      = numel(EPG_parameters.audioWave(:,1));
EPG_parameters.timeVector      = (1:EPG_parameters.numSamples)/EPG_parameters.sampleRate;
EPG_parameters.totalTime       = (EPG_parameters.numSamples)/EPG_parameters.sampleRate;
EPG_parameters.maxSignal       = max(EPG_parameters.audioWave(:,1));
EPG_parameters.minSignal       = min(EPG_parameters.audioWave(:,1));

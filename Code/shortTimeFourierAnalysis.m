function EPG_parameters=shortWindowAnalysis(EPG_parameters) 
%% Short window analysis
% Obtain the Fourier transform of a short period in time and display in different
% ways

%stepSamp = round(sampleRate/10);
% The windows will be determined by the ratio of the sampling frequency for the audio
% (25660) and the frames per second of the video (25.660) thus in this case it is
% 1000

%stepSamp                = 1000;
%stepSamp                = (sampleRate / FrameRate);

% The temporary Sound Signal and temporary Spectrum will be stored in a matrix with
% one column per time window and 1000/500 rows for the time/frequency components
%tempSpectrum=[];

tempSound                       = zeros(ceil(EPG_parameters.stepSamp),EPG_parameters.numImages);
tempSpectrum                    = zeros(ceil(EPG_parameters.stepSamp/2),EPG_parameters.numImages);
tempTimeVector                  = zeros(ceil(EPG_parameters.stepSamp),EPG_parameters.numImages);

% Loop over the sound vector, re-arrange windows of the sound and its FFT in rows 
%for k=1:stepSamp:numSamples-stepSamp
for currWindow=1:EPG_parameters.numImages
    windowSpan                  = round(1+(currWindow-1)*EPG_parameters.stepSamp):round((currWindow-1)*EPG_parameters.stepSamp+EPG_parameters.stepSamp);
    %currWindow                  = 1+floor(k/stepSamp);
    %currSound                   = audioWave(k:k+stepSamp-1);
    currSound                   = EPG_parameters.audioWave(windowSpan);
    currFrequency               = log(1+abs((fft(currSound))));
    currFrequency2              = currFrequency(1:floor(EPG_parameters.stepSamp/2));
    soundSamples                = numel(currSound);
    freqSamples                 = numel(currFrequency2);
    tempSound(1:soundSamples,currWindow)     = currSound;
    tempSpectrum(1:freqSamples,currWindow)  = currFrequency2;
    tempTimeVector(1:soundSamples,currWindow)     = EPG_parameters.timeVector(windowSpan);
end

numSubSamples   = size(tempSpectrum,1);

numSamples_currFrequency        = numel(currFrequency);
f_axis_currFrequency            = EPG_parameters.sampleRate*(-(numSamples_currFrequency/2):(numSamples_currFrequency/2))/numSamples_currFrequency;
f_axis_currFrequency(end)       = [];
f_axis_currFrequencyB           = round(f_axis_currFrequency(round(1+EPG_parameters.stepSamp/2):end));



EPG_parameters.lengthWindow         = EPG_parameters.stepSamp / EPG_parameters.sampleRate;          % in seconds

%These vectors are for the WHOLE Signal in seconds (depends on the samples from WAV)
EPG_parameters.timeTickVectorSound  = floor((0:EPG_parameters.sampleRate:EPG_parameters.numSamples));
EPG_parameters.timeTickVectorSoundL = floor(EPG_parameters.timeTickVectorSound/EPG_parameters.sampleRate);

%These vectors are for the WINDOW Signal in miliseconds (depends on the samples from WAV)
EPG_parameters.timeTickVectorWindowL  = floor((0:1000*EPG_parameters.lengthWindow));
EPG_parameters.timeTickVectorWindow  = linspace(1,EPG_parameters.stepSamp,numel(EPG_parameters.timeTickVectorWindowL));
%floor(EPG_parameters.timeTickVectorSound/EPG_parameters.sampleRate);

%These vectors are for the SPECTRUM Signal in miliseconds (depends on the samples from EPG)
EPG_parameters.timeTickVectorSpectrum  = floor((1:EPG_parameters.FrameRate:EPG_parameters.numImages));
EPG_parameters.timeTickVectorSpectrumL  = floor(EPG_parameters.timeTickVectorSpectrum/EPG_parameters.FrameRate);


%EPG_parameters.timeTickVector       = (0:EPG_parameters.sampleRate/EPG_parameters.stepSamp:floor(numSubSamples));
%EPG_parameters.timeTickVectorL      = (0:floor(numSubSamples/(EPG_parameters.sampleRate/EPG_parameters.stepSamp)));
%EPG_parameters.timeTickVectorL_S    = round(EPG_parameters.stepSamp*(0:100:EPG_parameters.stepSamp)/EPG_parameters.sampleRate);

%These vectors are for the WHOLE Signal
%EPG_parameters.timeTickVector       = EPG_parameters.timeVector(1:round(EPG_parameters.numSamples/10):end);
%EPG_parameters.timeTickVectorL      = 0.01*round(100*EPG_parameters.timeTickVector);
%These vectors are for the WHOLE Signal
%EPG_parameters.timeTickVector       = EPG_parameters.timeVector(1:round(EPG_parameters.numSamples/10):end);
%EPG_parameters.timeTickVectorL      = 0.01*round(100*EPG_parameters.timeTickVector);


%EPG_parameters.timeTickVectorL_S   = round(1000*(0:EPG_parameters.stepSamp/5:EPG_parameters.stepSamp)/EPG_parameters.sampleRate);
%EPG_parameters.timeTickVectorL_S    =  linspace(0,EPG_parameters.lengthWindow ,numel(EPG_parameters.timeTickVectorSoundL));



EPG_parameters.freqTickVector       = (EPG_parameters.stepSamp/10:EPG_parameters.stepSamp/10:EPG_parameters.stepSamp/2);
EPG_parameters.freqTickVectorL      = f_axis_currFrequencyB(EPG_parameters.freqTickVector);

% EPG_parameters.maxSignal       = max(EPG_parameters.audioWave(:,1));
% EPG_parameters.minSignal       = min(EPG_parameters.audioWave(:,1));

EPG_parameters.maxSound             = 0.8*max(tempSound(:));
EPG_parameters.minSound             = 0.8*min(tempSound(:));
EPG_parameters.maxSpectrum          = 0.8*max(tempSpectrum(:));
EPG_parameters.minSpectrum          = 0.8*min(tempSpectrum(:));

%EPG_parameters.stepSamp      = EPG_parameters.stepSamp;


EPG_parameters.tempSound            = tempSound;
EPG_parameters.tempSpectrum         = tempSpectrum;
EPG_parameters.tempTimeVector       = tempTimeVector;
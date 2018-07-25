function visualisePalatography (EPG_parameters,filename)

if isa(EPG_parameters.PalatogramAsym,'double')
    EPG_parameters.PalatogramAsym = uint8(EPG_parameters.PalatogramAsym);
end
% if ~exist('filename','var')
%     filename = 'CombinedVisualisation.avi';
% end

% All parameters have been previously calculated and stored in EPG_parameters

%% 1 Display of the spectrum and the palates below



handleFigure=figure(7);
clf
set(gcf,'position',[10   200   900   600])

% Display the whole time of the sound wave with a marker as time passes
handleSound = subplot(411);
hold off
hAllTime  = plot(EPG_parameters.timeVector,EPG_parameters.audioWave(:,1),'b');
hold on
hCurrTime = plot(EPG_parameters.tempTimeVector(:,1),EPG_parameters.tempSound(:,1),'r','linewidth',2);
xlabel('Time (s)','fontsize',14)
ylabel('Sound','fontsize',14)
handleSound.YLim             = [EPG_parameters.minSound EPG_parameters.maxSound ];
handleSound.Title.String     = EPG_parameters.Title;
handleSound.Title.FontSize   = 14;
%handleSound.XLim             = [0 EPG_parameters.numSamples ];
grid on
%set(handleSound,'xtick',EPG_parameters.timeTickVectorSound,'xticklabel',EPG_parameters.timeTickVectorSoundL)
addPhonemes;
handleSound.XLim = [0 EPG_parameters.totalTime];

% Display the Whole Spectrogram 
handleFFT = subplot(412);

spec2               = zeros(size(EPG_parameters.tempSpectrum));
max_tempSpectrum    = (max(EPG_parameters.tempSpectrum(:)));
spec2(1,1)          = max_tempSpectrum;
imagesc(log(1+spec2))
colormap (hot.^0.75)
handleFFT.XLim             = [0 EPG_parameters.totalTime*EPG_parameters.FrameRate ];
set(handleFFT,'xtick',EPG_parameters.timeTickVectorSpectrum,'xticklabel',EPG_parameters.timeTickVectorSpectrumL,'ytick',EPG_parameters.freqTickVector,'yticklabel',round(EPG_parameters.freqTickVectorL/100)/10);
axis xy
xlabel('Time (s)','fontsize',14)
ylabel('Freq (kHz)','fontsize',14)



% Display the sound of a small window
handleSoundWindow   = subplot(425);
plot(1000*EPG_parameters.tempTimeVector(:,1),EPG_parameters.tempSound(:,1))
%set(gca,'xticklabel',EPG_parameters.timeTickVectorL_S);
%set(h1,'xtick',EPG_parameters.timeTickVectorWindow,'xticklabel',EPG_parameters.timeTickVectorWindowL);
xlabel('Time (ms)','fontsize',12)


% Display local Fourier
handleFFTWindow     = subplot(427);
plot(EPG_parameters.tempSpectrum(:,1))

set(handleFFTWindow,'xtick',EPG_parameters.freqTickVector,'xticklabel',round(EPG_parameters.freqTickVectorL/100)/10);
axis xy
xlabel('Freq (kHz)','fontsize',12)

% Display Palatogram
handlePalatogram = subplot(224);
imagesc(EPG_parameters.PalatogramAsym(:,:,:,1))
handlePalatogram=gca;

axis ij
set(handlePalatogram,'xtick',[],'ytick',[]);

% Arrange positions
set(handleSound,'position'      ,[0.1    0.8     0.85    0.15])
set(handleFFT,'position'        ,[0.1    0.58    0.85    0.15])
set(handlePalatogram,'position' ,[0.62   0.06    0.3250    0.40])
set(handleSoundWindow,'position',[0.1    0.32    0.45    0.15])
set(handleFFTWindow,'position'  ,[0.1    0.06    0.45    0.15])

%% Prepare the generation of videos ONLY if a file name was provided

if exist('filename','var')
    clear F videoFWriter 
    videoFWriter = vision.VideoFileWriter(strcat(filename(1:end-4),'_1',filename(end-3:end)),'FrameRate',...
        EPG_parameters.FrameRate,'AudioInputPort',true);
end
%handleSound.XLim = [0 EPG_parameters.stepSamp ];
samplesTempSound = size(EPG_parameters.tempSound,1);

% Iterate over all the windows, for each move the cursor over the sound
% wave, display the current spectrogram, display current sound,  current
% Fourier Transform and current Palate

% Also, grab the frame to produce videos
for k=1:EPG_parameters.numImages

    hCurrTime.YData                     = EPG_parameters.tempSound(:,k);
    hCurrTime.XData                     = EPG_parameters.tempTimeVector(:,k);
    % hCurrTime.XData                   = round(1+(k-1)*EPG_parameters.stepSamp:(k-1)*EPG_parameters.stepSamp+samplesTempSound);
    handleSound.YLim                    = [EPG_parameters.minSound EPG_parameters.maxSound ];
    
    %addOnePhoneme;
    handleSoundWindow.Children.YData    = EPG_parameters.tempSound(:,k);
    handleSoundWindow.YLim              = [EPG_parameters.minSound	 EPG_parameters.maxSound ];
    set(handleSoundWindow,'xticklabel',round(((k-1)*EPG_parameters.lengthWindow*1000+ EPG_parameters.timeTickVectorWindowL)));

    handleFFTWindow.Children.YData    = EPG_parameters.tempSpectrum(:,k);
    handleFFTWindow.YLim              = [EPG_parameters.minSpectrum EPG_parameters.maxSpectrum ];

    spec2(:,1:k) = EPG_parameters.tempSpectrum(:,1:k);
    spec2(1,1) = max_tempSpectrum;
    handleFFT.Children.CData = (spec2);
    caxis([0 max_tempSpectrum]);
    axis xy
    
    handlePalatogram.Children.CData     = EPG_parameters.PalatogramAsym(:,:,:,k);
    axis ij
    addOnePhoneme;


    drawnow
    if exist('filename','var')
        % Grab frame, print current figure, and then read to save as a
        % video with sound.
        F(k)= getframe(handleFigure);
        % print whole figure and read later
        print('-djpeg','-r64','frame_video.jpg')
        currFrame = imread('frame_video.jpg');
        step(videoFWriter,currFrame,EPG_parameters.tempSound(:,k));
    end
end

%%

% Close the input and output files.
if exist('filename','var')
    % Finish the release of the video with sound
    release(videoFWriter);
    
    % Save as a video, without sound
    v = VideoWriter(strcat(filename(1:end-4),'_2',filename(end-3:end))); %,'Uncompressed AVI');
    v.FrameRate = EPG_parameters.FrameRate;
    
    open(v)
    writeVideo(v,F)
    close(v)
    % Save as an animated GIF
    
    %%
    [imGif,mapGif] = rgb2ind(F(end).cdata,256,'nodither');
    numFrames = size(F,2);

    imGif(1,1,1,numFrames) = 0;
    for k = 1:numFrames 
      imGif(:,:,1,k) = rgb2ind(F(k).cdata,mapGif,'nodither');
    end
  
    imwrite(imGif,mapGif,strcat(filename(1:end-4),'_3.gif'),...
            'DelayTime',0.05,'LoopCount',inf)
    
end
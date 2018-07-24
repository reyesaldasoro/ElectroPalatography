function handleAxis = displayAsymmetryIndex(EPG_parameters,handleAxis)

% The function can display the signal in a predefined axis (for multiple
% plots in a single figure) or in a new figure (default if no argument is
% passed)
if ~exist('handleAxis','var')
    handleFigure    = figure();
    handleAxis      = gca;
    set(gcf,'position',[20   600   800   200])
    
else
    axes(handleAxis)
end

spec2               = zeros(size(EPG_parameters.tempSpectrum));
max_tempSpectrum    = (max(EPG_parameters.tempSpectrum(:)));
spec2(1,1)          = max_tempSpectrum;

colormap (hot.^0.75)
imagesc(log(1+EPG_parameters.tempSpectrum))
set(handleAxis,'xtick',EPG_parameters.timeTickVectorSpectrum,'xticklabel',EPG_parameters.timeTickVectorSpectrumL,'ytick',EPG_parameters.freqTickVector,'yticklabel',round(EPG_parameters.freqTickVectorL/100)/10);
axis xy
xlabel('Time (s)','fontsize',14)
ylabel('Freq (kHz)','fontsize',14)
handleAxis.XLim             = [0 EPG_parameters.totalTime*EPG_parameters.FrameRate ];


function handleAxis = displaySoundWave(EPG_parameters,handleAxis)

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

plot(EPG_parameters.timeVector, EPG_parameters.audioWave(:,1));
ylabel('Sound','fontsize',14)
xlabel('Time (s)','fontsize',14)
handleAxis.YLim             = [EPG_parameters.minSound EPG_parameters.maxSound ];
grid on
addPhonemes;
handleAxis.XLim             = [0 EPG_parameters.totalTime ];

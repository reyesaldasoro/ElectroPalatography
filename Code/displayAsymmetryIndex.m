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

plot(EPG_parameters.EPGtimeVector,EPG_parameters.asymIndex(:,1:2),'-o')
grid on
axis tight
handleAxis.XLim             = [0 EPG_parameters.totalTime ];
%ylabel('Asymmetry','fontsize',14)
ylabel({'Num Asymmetries';'L(+) / R(-)'})
xlabel('Time (s)','fontsize',14)


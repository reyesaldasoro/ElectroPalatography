function handleAxis = displayAsymmetryIndex(EPG_parameters,displayOption,handleAxis)

% The function can display the signal in a predefined axis (for multiple
% plots in a single figure) or in a new figure (default if no argument is
% passed)
if ~exist('handleAxis','var')
    handleFigure    = figure();
    handleAxis      = gca;
    set(gcf,'position',[20   200   500   400])
else
    axes(handleAxis)
end

if ~exist('displayOption','var')
    displayOption = -1;
end

if displayOption<1
    jet2=jet;
    jet2(1,:) = 0;
    colormap (jet2.^0.8)
    if      displayOption==-2
        imagesc(EPG_parameters.activeElectrodesCum)
        xlabel('Cumulative Electrode Activation','fontsize',14)
        hc2=colorbar('Westoutside');
        hyl2=ylabel('Number of activations','fontsize',16);
        hyl2.Rotation=90;
    elseif  displayOption== -1
        imagesc(EPG_parameters.asymmetricElectrodesCum)
        xlabel('Cumulative Asymmetric Activation','fontsize',18)
        hc2=colorbar('Westoutside');
        hyl2=ylabel('Number of activations','fontsize',16);
        hyl2.Rotation=90;
    elseif  displayOption== -3

        for counterPalate=1:EPG_parameters.numImages
            displayPalatogram(EPG_parameters,counterPalate,handleAxis)
            pause(0.01)
            drawnow

        end

    end
    
else
    if displayOption>EPG_parameters.numImages
        displayOption=EPG_parameters.numImages;
    end
    imagesc(EPG_parameters.PalatogramAsym(:,:,:,displayOption))
    xlabel(strcat('Electrode Activation:',num2str(displayOption)),'fontsize',14)
end





handleAxis.XTick=[];
handleAxis.YTick=[];

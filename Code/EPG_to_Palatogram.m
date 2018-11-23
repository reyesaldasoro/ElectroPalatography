function [EPG_parameters,Palatogram]    = EPG_to_Palatogram (EPG_data,EPG_parameters,electrodes)

% Translate from the electrode information of EPG files to a palatogram

% Data is in the form of one line per time frame, and the data is one number per row
% of the palate

%%
[EPG_Samples,EPG_words]= size(EPG_data);

%%

electrodeKey = [...
     0     8    16    24    32    40    48     0 ;...
     1     9    17    25    33    41    49    56 ;...
     2    10    18    26    34    42    50    57 ;...
     3    11    19    27    35    43    51    58 ;...
     4    12    20    28    36    44    52    59 ;...
     5    13    21    29    37    45    53    60 ;...
     6    14    22    30    38    46    54    61 ;...
     7    15    23    31    39    47    55    62 ];

%%
if EPG_Samples ==1
    %%
    %just one timeFrame
    % Each word has to be translated decimal-binary, and then inverted left-right and
    % that corresponds to the electrode activation of each row from bottom to top
    CurrPalate(8,8)=0;
    for counterRow = 1:8
        % Always 8 rows, starting from bottom
        currWord                            = flip(dec2bin(EPG_data(1,counterRow),8));
        for counterPos = 1:8
        CurrPalate (9-counterRow,counterPos)=str2double(currWord(counterPos));
        end
    end
    
    %%
    currElectrodes                          = electrodeKey.*CurrPalate;
    currElectrodes(currElectrodes==0)       = [];
    Palatogram                              = ismember(electrodes,currElectrodes);
    
else
    %multiple time frames
    load EPB_Boxes
     biasCol     = 0;
    
    Palatogram(EPG_parameters.rows,EPG_parameters.cols-biasCol,EPG_parameters.levs,EPG_parameters.numImages)        = (0);
    PalatogramAsym(EPG_parameters.rows,EPG_parameters.cols-biasCol,3,EPG_parameters.numImages)    = (0);
    asymIndex(EPG_parameters.numImages,3)                                   = 0;
    activeElectrodesCum(EPG_parameters.rows,EPG_parameters.cols-biasCol)        = 0;
    asymmetricElectrodesCum(EPG_parameters.rows,EPG_parameters.cols-biasCol)    = 0;
    
    for counterFrames = 1:EPG_Samples
       [EPG_parameters,Palatogram(:,:,1,counterFrames)]     = EPG_to_Palatogram (EPG_data(counterFrames,:),EPG_parameters,electrodes);
        
        
        [PalatogramAsym(:,:,:,counterFrames), asymIndex(counterFrames,:),activeElectrodes,asymmetricElectrodes] = asymmetry_projection(Palatogram(:,:,1,counterFrames));
        
        activeElectrodesCum                 = activeElectrodesCum       + double(activeElectrodes);
        asymmetricElectrodesCum             = asymmetricElectrodesCum   + double(asymmetricElectrodes);

    end
    

EPG_parameters.asymIndex                        = asymIndex;
EPG_parameters.Palatogram                       = Palatogram;
EPG_parameters.PalatogramAsym                   = PalatogramAsym;
EPG_parameters.activeElectrodesCum              = activeElectrodesCum;
EPG_parameters.asymmetricElectrodesCum          = asymmetricElectrodesCum;
    
end












% 62bit padded to 64bit, Raw binary WITH 4 EXTRA BYTES PREPENDED 
% 		TO THE START OF EACH FRAME. THIS MAKES 12 BYTES PER FRAME. (These 
% 		extra bytes are unused and will be deleted in future releases.)
% 		Frame rate of 200 frames per second. Each
% 		frame consists of 12x8bit words. Each bit of each word
% 		represents the on/off status of each contact in the
% 		palatogram. Ignore the first 4 words. The fifth word represents, 
% 		left to right, the front row of the palatogram (bits 0 and 7 are 
% 		unused), the last word represents the back row
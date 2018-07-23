function [currImage_asym,asymIndex,activeElectrodes,asymmetricElectrodes] = asymmetry_projection(currImage)

%%
[rows,cols,levs]        = size(currImage);
currImage               = uint8(currImage);

if levs==1
    % Images from EPG generated directly
    LeftSide                = (currImage(:,2:cols/2,1)>0);
    RightSide               = (currImage(:,2+cols/2:end,1)>0);
    currImage_asym          = repmat(255*currImage,[1 1 3]);
 
    Electrodes_onlyLeft     = ( LeftSide > flip(RightSide,2) ) ;
    Electrodes_onlyRight    = ( flip(LeftSide,2) < (RightSide)  ) ;
    [Elect_onlyLeft_L,numL] = bwlabel(Electrodes_onlyLeft);
    [Elect_onlyRight_L,numR]= bwlabel(Electrodes_onlyRight);
    
    currImage_asym(:,2:cols/2,1)            =  uint8(currImage_asym(:,2:cols/2,1) )         - uint8(120*Electrodes_onlyLeft*100);
    currImage_asym(:,2+(cols/2):end,2)      =  uint8(currImage_asym(:,2+(cols/2):end,2))    - uint8(120*(Electrodes_onlyRight)*100);
   
    activeElectrodes        = currImage;
    asymmetricElectrodes    = max((repmat(255*currImage,[1 1 3])~=currImage_asym),[],3);
else
    % Images from video
    currImage_asym          = uint8(currImage);
    LeftSide                = (currImage(:,2:cols/2,1)>200);
    RightSide               = (currImage(:,2+cols/2:end,3)>200);
    %RightSide               = flip(currImage(:,2+cols/2:end,3)>200,2);
    
    Electrodes_onlyLeft     = bwmorph( LeftSide < flip(RightSide,2) ,'majority' ) ;
    Electrodes_onlyRight    = bwmorph( flip(LeftSide,2) > (RightSide) ,'majority' ) ;
    [Elect_onlyLeft_L,numL] = bwlabel(Electrodes_onlyLeft);
    [Elect_onlyRight_L,numR]= bwlabel(Electrodes_onlyRight);
    
    currImage_asym(:,2:cols/2,1)            =  uint8(currImage_asym(:,2:cols/2,1) )         + uint8(Electrodes_onlyLeft*100);
    currImage_asym(:,2+(cols/2):end,2)      =  uint8(currImage_asym(:,2+(cols/2):end,2))    + uint8((Electrodes_onlyRight)*100);
        
    activeElectrodes        = bwmorph((currImage(:,:,3)>30).*(currImage(:,:,3)<100),'majority' ) ;
    activeElectrodes        = imopen(activeElectrodes,ones(19));
    asymmetricElectrodes    = max((currImage~=currImage_asym),[],3);
end
    asymIndex               = [numL -numR numL-numR];




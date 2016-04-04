clc;
clear;
close all;

fSampling = 125 ; % sampling frequency of the data

for fileNo = 1:13
    
    [sig, bpm0 ] =  input_file(fileNo);
    
    ecgSignal  = sig(1,:); % original ecg signal
    ppgSignal1 = sig(2,:); % ppg signal 1
    ppgSignal2 = sig(3,:); % ppg signal 2
    
    % acceleration data of x,y,z
    accDataX = sig(4,:);
    accDataY = sig(5,:);
    accDataZ = sig(6,:);
    
    ppgSignalAverage = (ppgSignal1 + ppgSignal2) / 2;
    
    
    % rls filtering
    lParameterOfRls = 40; % rls filter parameter
    [~,ex] = filter(adaptfilt.rls(lParameterOfRls),accDataX,...
        ppgSignalAverage);
    [~,exy] = filter(adaptfilt.rls(lParameterOfRls),accDataY,ex);
    [~,exyz] = filter(adaptfilt.rls(lParameterOfRls),accDataZ,exy);
    
    rRaw = exyz;  % exyz can be regarded as a denoised signal rRaw(n)
    % which is assumed to have no correlation with the
    % acceleration.
    
    
    % filtering all data to frequency range for human HR
    rN       = myBandPass(rRaw,fSampling);
    accDataX = myBandPass(accDataX,fSampling);
    accDataY = myBandPass(accDataY,fSampling);
    accDataZ = myBandPass(accDataZ,fSampling);
    
    fPrev = initialize( rN(1:1000), sig(4:6,1:1000), fSampling ); % intial value of bpm
    
    
    % bandpassing all the data of signal
    filterObj = fdesign.bandpass( 70/(fSampling*60), 80/(fSampling*60),...
                400/(fSampling*60), 410/(fSampling*60), 80, 0.01, 80  );
    D = design(filterObj,'iir');
    for i=2:6
        sig(i,:)=filter(D,sig(i,:));
    end
    
    
    % now doing the emd portion 
    
    iStart = 1;
    iStep  = 250;
    iStop  = length(rN);
    
    for iSegment = iStart : iStep : iStop
       
        currentSegment = iSegment : ( iSegment + 1000 - 1 );
        
        [freqEstimates,peaks] = doEEMD(sig(:,currentSegment),fPrev);
        
    end
    
    
    
    
    
end
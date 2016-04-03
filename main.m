clc;
clear;
close all;

for fileNo = 1:13
   
   [sig, bpm0 ] =  input_file(fileNo);
   
   ecgSignal = sig(1,:); % original ecg signal
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
        % exyz can be regarded as a denoised signal rRaw(n)  
        % which is assumed to have no correlation with the 
        % acceleration.
         
   

   
end
function vpl_StopLibration(obj,event,handles)
global OutVoltage
disp(OutVoltage)

NumberOfDivisions=handles.DecTime/handles.UpdateRate;

SmoothingVoltage=linspace(OutVoltage,((handles.MeanRPM)*(handles.rpm2v)),NumberOfDivisions);
i=1;
b=tic;
while i<=length(SmoothingVoltage)
        if toc(b)>=handles.UpdateRate
    disp(SmoothingVoltage(i))
%handles.ljudObj.AddRequest(handles.ljhandle, LabJack.LabJackUD.IO.PUT_DAC, 0, SmoothingVoltage(i), 3, 0);
%handles.ljudObj.GoOne(handles.ljhandle);
handles.ljudObj.ePut(handles.ljhandle, LabJack.LabJackUD.IO.TDAC_COMMUNICATION, LabJack.LabJackUD.CHANNEL.TDAC_UPDATE_DACA, SmoothingVoltage(i), 0)

i=i+1;
    b=tic;
        end

end
disp('Stopping Libration');
function vpl_DecTable(handles)
disp('Decelerating')
NumberOfDivisions=handles.DecTime/handles.UpdateRate;
OutVoltage=linspace(handles.MeanRPM,0,NumberOfDivisions)*handles.rpm2v;
i=1;
b=tic;
while i<=length(OutVoltage)

    if toc(b)>=handles.UpdateRate
%handles.ljudObj.AddRequest(handles.ljhandle, LabJack.LabJackUD.IO.PUT_DAC, 0, OutVoltage(i), 3, 0);
%handles.ljudObj.GoOne(handles.ljhandle);
handles.ljudObj.ePut(handles.ljhandle, LabJack.LabJackUD.IO.TDAC_COMMUNICATION, LabJack.LabJackUD.CHANNEL.TDAC_UPDATE_DACA, OutVoltage(i), 0)

    disp(OutVoltage(i))
i=i+1;
    b=tic;
    end
end


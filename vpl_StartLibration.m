function vpl_StartLibration(obj,event,handles)
global OutVoltage
OutVoltage=(handles.MeanRPM+handles.LibrationAmplitude*sin(2*pi*toc/handles.LibrationPeriod))*handles.rpm2v
 %handles.ljudObj.AddRequest(handles.ljhandle, LabJack.LabJackUD.IO.PUT_DAC, 0, OutVoltage, 3, 0);
 %handles.ljudObj.GoOne(handles.ljhandle);
handles.ljudObj.ePut(handles.ljhandle, LabJack.LabJackUD.IO.TDAC_COMMUNICATION, LabJack.LabJackUD.CHANNEL.TDAC_UPDATE_DACA, OutVoltage, 0)





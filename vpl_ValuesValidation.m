function J=vpl_ValuesValidation(handles)
a=1;
b=1;
c=1;
d=1;
e=1;
f=1;
g=1;
h=1;
handles.AccTime=str2num(get(handles.ed_acctime,'String'));
if handles.AccTime<=0
    warndlg('Acceleration time must be higher than 0');
    a=0;
end

handles.DecTime=str2num(get(handles.ed_dectime,'String'));
if handles.DecTime<=0
    warndlg('Deceleration time must be higher than 0');
    b=0;
end

handles.MeanRPM=str2num(get(handles.ed_meanrpm,'String'));
if handles.MeanRPM<=0 || handles.MeanRPM>16
    warndlg('Mean RPM must be between 0 and 16');
    c=0;
end



handles.LibrationAmplitude=str2num(get(handles.ed_libamp,'String'));
if handles.LibrationAmplitude<0 || handles.LibrationAmplitude>=handles.MeanRPM
    warndlg('Libration must be higher than 0 lower than Mean RPM');
    d=0;
end
if (handles.LibrationAmplitude+handles.MeanRPM)>16
    warndlg('Libration Amplitude + MeanRPM shall be less than 16');
    d=0;
end


handles.LibrationPeriod=str2num(get(handles.ed_libper,'String'));
if handles.LibrationPeriod<=0
    warndlg('Libration period must be higher than 0');
    e=0;
end



handles.UpdateRate=str2num(get(handles.ed_updaterate,'String'));
if handles.UpdateRate<1 || handles.UpdateRate>150
    warndlg('Update Rate must be between 1 and 150');
    f=0;
else
    handles.UpdateRate=1/(str2num(get(handles.ed_updaterate,'String')));

end

handles.ValuesOK=a*b*c*d*e*f;

J=handles;

    

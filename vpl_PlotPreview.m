function vpl_PlotPreview(handles)

axes(handles.axes1)
NbUp=handles.AccTime/handles.UpdateRate;
upslope=linspace(0,handles.MeanRPM,NbUp);
contslope=linspace(handles.MeanRPM,handles.MeanRPM,6/handles.UpdateRate);
t=linspace(0,5*handles.LibrationPeriod,5*handles.LibrationPeriod/handles.UpdateRate);
libration=handles.MeanRPM+handles.LibrationAmplitude*sin((2*pi/handles.LibrationPeriod)*t);
NbDown=handles.DecTime/handles.UpdateRate;
decel=linspace(handles.MeanRPM,0,NbDown);
vecplot=[upslope,contslope,libration,contslope,decel];

tvec=(handles.AccTime+6+5*handles.LibrationPeriod+6+handles.DecTime);
tplot=linspace(0,tvec,length(vecplot));
plot(tplot,vecplot)
axis([0,tvec,0,16])
disp('ae')


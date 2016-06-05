function [Angle,Time]=vpl_ReadRPM(fn)
clc
clearvars -except fn
close all
%Get movie data

data=df_mov_info(fn);

%Ask center

PlotData.angle=[0,0];
res=0.001;
AngleOffset=pi/18;
n=0;


FirstFrame=df_mov_read(fn,1);
imshow(FirstFrame)
title('Select Center')
[center.x,center.y]=ginput(1);
title('Select point on object')
[rad.x,rad.y]=ginput(1);
close all
r=sqrt((rad.x-center.x)^2+(rad.y-center.y)^2);



%figure
%hold on

h = waitbar(0,'Processing...');
steps=data.nMovieFrames;
for i=1:1:data.nMovieFrames

    
FrameGS=df_mov_read(fn,i);
    %threshold

FrameGS(FrameGS>30)=255;
FrameGS(FrameGS~=255)=0;

x0=round(center.x+r*cos(0));
y0=round(center.y+r*sin(0));


if FrameGS(y0,x0)==0
    sweepstart=AngleOffset;
else
    sweepstart=0;
end
    

    for k=sweepstart:res:(2*pi)
        
        x=round(center.x+r*cos(k));
        y=round(center.y+r*sin(k));

        if FrameGS(y,x)==0
            for t=length(PlotData.angle):-1:1
                if PlotData.angle(t)>(k+(2*n*pi))
                    n=n+1;
                    break
                end
            end
            
            PlotData.angle(i)=k+(n*2*pi);
            PlotData.frame(i)=i;
           % plot(PlotData.frame(i)/data.iFrameRate,PlotData.angle(i),'*')
            %ttl=strcat('Frame :',num2str(i),'/',num2str(data.nMovieFrames));
            %title(ttl)
            %drawnow;
            break
           
        end
    end
 waitbar(i/steps)   
end
close(h)
disp('Correcting any mistakes');

for i=1:(length(PlotData.angle)-1)
    if PlotData.angle(i+1)-PlotData.angle(i)>6 %Rough aproximation for 2pi
        PlotData.angle((i+1):end)=PlotData.angle((i+1):end)-2*pi;
    end
end

Angle=PlotData.angle;
Time=PlotData.frame ./ data.iFrameRate;
diffangle=diff(Angle)./diff(Time);
difftime=Time(2:end);
Sdiffangle=fastsmooth(diffangle,8,1,1);
plot(Time,Angle)
drawnow
figure
hold on
plot(difftime,diffangle,'b')
plot(difftime,Sdiffangle,'r')
drawnow
waitfor(msgbox('Select Start and Endpoint of sample to be sinus fitted'));
start_end=ginput(2);
indexes=find(Time>=start_end(1,1) & Time<=start_end(2,1));
coefs=vpl_SinFit(difftime(indexes),Sdiffangle(indexes));
savename=strcat('dados_',fn,'.mat');
save(savename)


disp('END of analysis')
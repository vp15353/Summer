function vpl_ReadRPM(fn)

%Get movie data

data=df_mov_info(fn);


%Read Move File



%Ask center

PlotData.angle=[0,0]
res=0.001;
n=0;


FirstFrame=df_mov_read(fn,1);
imshow(FirstFrame)
[center.x,center.y]=ginput(1);
[rad.x,rad.y]=ginput(1);
close all
r=sqrt((rad.x-center.x)^2+(rad.y-center.y)^2);



figure
hold on


for i=1:1:data.nMovieFrames

    
FrameGS=df_mov_read(fn,i);
    %threshold

FrameGS(FrameGS>30)=255;
FrameGS(FrameGS~=255)=0;



    for k=0:res:(2*pi)
        
        x=round(center.x+r*cos(k));

        y=round(center.y+r*sin(k));

        x;
        y;
        if FrameGS(y,x)==0
            for t=length(PlotData.angle):-1:1
                if PlotData.angle(t)>(k+(2*n*pi))
                    n=n+1;
                    break
                end
            end
            
            PlotData.angle(i)=k+(n*2*pi);
            PlotData.frame(i)=i;
            plot(PlotData.frame(i)/data.iFrameRate,PlotData.angle(i),'*')
            drawnow;
            disp('veu')
            break
           
        end
    end
    i
    
end
save
disp('end')
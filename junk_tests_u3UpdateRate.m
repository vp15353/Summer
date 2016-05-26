%% Max UpdateRate U3 DAC Test

% Conclusions, for deltas of 0-3V I could get up to 30Hz signal ,
% going from a square wave to a triangular wave

ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
ljudObj = LabJack.LabJackUD.LJUD;
[ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);

Voltage=[0,3];
i=1;
b=tic;
period=1/40;

while true
       if toc(b)>=period

    ljudObj.AddRequest(ljhandle, LabJack.LabJackUD.IO.PUT_DAC, 0, Voltage(i), 3, 0);
    ljudObj.GoOne(ljhandle);
i=i+1
if i==3
    i=1;
end


    b=tic;
       end

end
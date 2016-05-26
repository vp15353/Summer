%% Max UpdateRate U3 DAC Test

% Conclusions, Achieved Rates of ~ 150 Hz with ease, definetly the best
% option

ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
ljudObj = LabJack.LabJackUD.LJUD;
[ljerror, ljhandle] = ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);
ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.TDAC_SCL_PIN_NUM, 4, 0)

Voltage=[0,3];
i=1;
b=tic;
period=1/150;

while true
       if toc(b)>=period

ljudObj.ePut(ljhandle, LabJack.LabJackUD.IO.TDAC_COMMUNICATION, LabJack.LabJackUD.CHANNEL.TDAC_UPDATE_DACA, Voltage(i), 0);

i=i+1;
if i==3
    i=1;
end


    b=tic;
       end

end
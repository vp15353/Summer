function coefs=vpl_SinFit(x,y)
yu = max(y);
yl = min(y);
yr = (yu-yl);                               % Range of ‘y’
yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(y);                               % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi/b(2)*x + b(3))) + b(4);    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);          % Least-Squares cost function
coefs = fminsearch(fcn, [yr;  per;  -1;  ym]);   % Minimise Least-Squares
xp = linspace(min(x),max(x));

SStot=sum((y-ym).^2);
SSres=sum((y-fit(coefs,x)).^2);
Rsqr=1-SSres/SStot;

figure
plot(x,y,'b',  xp,fit(coefs,xp), 'r')
grid
display(strcat('Amplitude:',num2str(coefs(1))))
display(strcat('Period:',num2str(coefs(2))))
display(strcat('Phase:',num2str(coefs(3))))
display(strcat('Mean:',num2str(coefs(4))))
display(strcat('Goodness of fit R square:',num2str(Rsqr)))




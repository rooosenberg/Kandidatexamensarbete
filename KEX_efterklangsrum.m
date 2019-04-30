%Datainput körs först för att importera data. Sedan körs "Reverberation"
%för att beräkna efterklangstiden. Dessa program användes på MWL
%labratoriet och mätningarma skedde i deras efterklangsrum. 

%% Datainput

 

% To import data and then convert to dB scale

clear all

fs=11025;

dt=1/fs;

T=5;

t=[dt:dt:T];

ydata=audiorecorder(fs,16,1); %channel 1 only

recordblocking(ydata, T);

y = getaudiodata(ydata);

% To get rms value with averaging time of about 20 ms.

% (averaging length=k*dt). 1 ms is about 11 samples when fs=11025.

k=100; % Number of samples to be averaged

sk=sqrt(k);

n=round(length(y)/k-0.5);

for nn=1:n

yy(nn)=norm(y((nn-1)*k+1:nn*k))/sk; % rms value

end

yy2=20*log10(yy)+120; % Sound pressure level

dt2=k*dt;

tt=[dt2/2:dt2:T-dt2/2];

plot(tt,yy2)

xlabel('Time, [s]');

ylabel('Sound Pressure Level, [dB]')

grid

 

 

 

%% Reverberation

 

% To calculate reverberation time

hold

[u,v]=ginput(2);

k = -abs((v(1)-v(2))/(u(1)-u(2)));

% To calculate reverberation time with linear regression

t1=round(u(1)/dt2);

t2=round(u(2)/dt2);

p=polyfit(tt(t1:t2),yy2(t1:t2),1);

yy3=p(2)+p(1)*tt(t1:t2);

plot(tt(t1:t2),yy3,'r')

T60=-60/p(1);

round(T60*100)/100

hold off
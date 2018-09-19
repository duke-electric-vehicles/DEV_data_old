clear; close all;

PATHNAME = '/Users/shomikverma/Documents1/Duke/EV/DEV_data/H2/';
FOLDER = 'fanData/';
FILENAME = '20DC_sept18_2';
FILENAME2 = '30DC_sept18';
FILENAME3 = '40DC_sept18';
EXT = '.txt';
data = importdata(strcat(PATHNAME,FOLDER,FILENAME,EXT));
data2 = importdata(strcat(PATHNAME,FOLDER,FILENAME2,EXT));
data3 = importdata(strcat(PATHNAME,FOLDER,FILENAME3,EXT));

% baseIVname = 'base_IV.txt';
% data_base = importdata(baseIVname);
% % data_base = data_base(1:3930, :);
% baseI = data_base(:,6);
% baseV = data_base(:,5);
% baseT = data_base(:,8);
% baseT = baseT - baseT(1);
% baseT = baseT/1000;

% IV curve data
p1 =    -0.0335;
p2 =     0.4112;
p3 =    -1.9282;
p4 =     4.3558;
p5 =    -5.3833;
p6 =    18.3366;
fit_V = @(I) p1.*I.^5 + p2.*I.^4 + p3.*I.^3 + p4.*I.^2 + p5.*I + p6;

% data = data(9228:26080, :); % middle school test
% data = data(3849:28000,:);
% vFC = data(:, 7);
% data = data(gradient(vFC)<0, :);
data = data(1:end-2000,:);
data2 = data2(1:end-1000,:);

c = 200;

vBMS = data(:, 1);
iBMS = data(:, 2);
velo = data(:,4);
eBMS = data(:, 5);
vFC = data(:, 7);
iFC = data(:, 8);
eFC = data(:, 9);
time = data(:, 10) ./ 1000;
time = time - time(1);
tempFC = data(:, 13);
pressFC = data(:, 14);
flow = data(:, 15);
instantH2 = smooth(flow*119.93,50);
instantn = iBMS.*vBMS./instantH2;
totalFlow = data(:, 16);
instantEff = data(:, 17);
if(exist('data2','var'))
    vBMS2 = data2(:, 1);
    iBMS2 = data2(:, 2);
    vFC2 = data2(:, 7);
    iFC2 = data2(:, 8);
    flow2 = data2(:, 15);
    instantH2_2 = smooth(flow2*119.93,50);
    instantn2 = iBMS2.*vBMS2./instantH2_2;
    time2 = data2(:, 10) ./ 1000;
    time2 = time2 - time2(1);
    tempFC2 = data2(:, 13);
end
if(exist('data3','var'))
    vBMS3 = data3(:, 1);
    iBMS3 = data3(:, 2);
    vFC3 = data3(:, 7);
    iFC3 = data3(:, 8);
    flow3 = data3(:, 15);
    instantH2_3 = smooth(flow3*119.93,50);
    instantn3 = iBMS3.*vBMS3./instantH2_3;
    time3 = data3(:, 10) ./ 1000;
    time3 = time3 - time3(1);
    tempFC3 = data3(:, 13);
end
% avgEff = data(:, 18);
avgEff = zeros(size(instantEff));

% IV curve data
p1 =    -0.0335;
p2 =     0.4112;
p3 =    -1.9282;
p4 =     4.3558;
p5 =    -5.3833;
p6 =    18.3366;
fit_V = @(I) p1.*I.^5 + p2.*I.^4 + p3.*I.^3 + p4.*I.^2 + p5.*I + p6;
minI = min(iFC);
maxI = max(iFC);
baseI = linspace(minI, maxI, 1000);
baseT = ones(size(baseI,2),1);

totalFlow = totalFlow - totalFlow(1);
eBMS = eBMS - eBMS(1);
eFC = eFC - eFC(1);
time = time - time(1);

h2Energy = totalFlow .* 1000 .* 119.93;

capEnergy = 0.5 .* c .* (vFC.^2 - vFC(1).^2);
totalFCEff = eBMS ./ h2Energy;
totalFCEffComp = (eBMS + capEnergy) ./ h2Energy;
plot(time, totalFCEffComp, '.'); hold on; grid on;
%plot(vFC);
plot(time, instantEff, '.');
plot(time, avgEff, '.');
ylim([.5, 0.65]);
legend('total','instant','avg')
title('efficiency vs. time')

figure(3); clf;
plot(time, vBMS); hold on;
plot(time, vFC);
title('voltage vs. time')

figure(4); clf;
scatter3(iFC, vFC, time,5,time); hold on;
% scatter3(baseI, baseV, baseT, 5, baseT);
scatter3(baseI, fit_V(baseI), baseT, 5, 'k');
xlim([ 0 5])
ylim([14 18])
view([0 90])
colorbar
title('IV curve')

figure(5); clf;
plot((eBMS + capEnergy) ./ eFC); hold on;

figure(6); clf;
plot(time, tempFC)
title('temp vs. time')

figure(7); clf;
plot(vFC, instantEff, '.');
title('efficiency vs. voltage')

figure(8); clf;
scatter(iFC, vFC,50,time,'.');
grid on
h = colorbar;
ylabel(h, 'Time (s)')
axis([0 7 12 19]);
title('Baseline FC IV curve');
xlabel('Current (A)');
ylabel('Voltage (V)');
filename = strcat(PATHNAME,'plots/',FILENAME,'IV');
print('-dpng', filename)

figure(9); clf;
scatter(iFC.*vFC, instantEff.*100,50,time,'.');
grid on
h = colorbar;
ylabel(h, 'Time (s)')
axis([ 0 90 40 65])
title('Baseline FC P\eta curve');
xlabel('Power (W)')
ylabel('Efficiency (%)')
filename = strcat(PATHNAME,'plots/',FILENAME,'Pn');
print('-dpng', filename)

figure(10); clf;
plot(time, instantn, '.');
hold on
if(exist('data2','var'))
    plot(time2, instantn2,'.');
end
if(exist('data3','var'))
    plot(time3, instantn3,'.');
end
ylim([.55,.6])
grid on
legend('20DC', '30DC','40DC')
title('Efficiency vs. time for various fan speeds')
xlabel('Time (s)');
ylabel('Efficiency');
filename = strcat(PATHNAME,'plots/',FILENAME,'fan_eff');
print('-dpng', filename)

figure(11); clf;
plot(time, tempFC, '.')
hold on
if(exist('data2','var'))
    plot(time2, tempFC2,'.')
end
if(exist('data3','var'))
    plot(time3, tempFC3,'.')
end
grid on
legend('20DC', '30DC','40DC','Location','SouthEast')
title('Temperature vs. time for various fan speeds')
xlabel('Time (s)');
ylabel('Temperature (F)');
filename = strcat(PATHNAME,'plots/',FILENAME,'fan_temp');
print('-dpng', filename)

% figure(12); clf;
% grid on
% plot(tempFC, instantn,'k.');
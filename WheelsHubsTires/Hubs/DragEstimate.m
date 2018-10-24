driverMass = 60;%kg
carMass = 30;%kg
tireCRR = 0.003;
frontBearingDragTorque = (2.09 + 4.87) / 1000;%N*m
rearBearingDragTorque = (1.32 * 2) / 1000;%N*m
freewheelPowerLoss = 1;%W
g = 9.8;%m/s
carVelocity = 6.7;%m/s
wheelDia = 0.4780;%m
frontalArea = 0.3;%m^2
densityAir = 1.225;%kg/m^3
dragForce15 = 1;%N
%dragCoeff = 0.093;

totalMass = carMass + driverMass;
wheelCirc = wheelDia * pi;
omega = carVelocity / wheelCirc * 2 * pi;

bearingPowerLoss = (frontBearingDragTorque * 2 + rearBearingDragTorque) * omega;
bearingForce = (frontBearingDragTorque * 2 + rearBearingDragTorque) * wheelDia / 2;

tireForce = tireCRR * totalMass * g;
tirePowerLoss = tireForce * carVelocity;

freewheelForce = freewheelPowerLoss / carVelocity;

labels = {'Bearings', 'Freewheel', 'Tires', 'Form Drag'};
data = [bearingForce, freewheelForce, tireForce, dragForce15];
clf; pie(data, labels);

totalForce = bearingForce + freewheelForce + tireForce + dragForce15;
energyMile = totalForce * 1609;
kWhMile = energyMile / (60 * 60 * 1000);
milesPerkWh = 1/kWhMile
F_0 = 30 * 9.8;     %Contact force in N
d_wrad = 0.2375;     %Radius of wheel in m
d_hub = 0.0615;     %Rough bearing separation
camber_deg = 8;      %Wheel camber in degrees

camber = camber_deg * pi / 180;

F_rad = F_0 * cos(camber);
F_T = F_0 * sin(camber);
theta_spoke = atan(0.5 * d_hub / d_wrad);

F_S = F_T / (2 * sin(theta_spoke));

F_radinner = F_rad - F_S * cos(theta_spoke)
F_radouter = F_rad + F_S * cos(theta_spoke)
F_axial = F_T / 2
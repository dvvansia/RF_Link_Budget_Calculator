%% Satellite RF Link Budget Test Scenarios
clear; clc;

% --- Scenario 1: 3U CubeSat UHF Telemetry Downlink (437 MHz, 600 km LEO, 15 deg elevation) ---
cubesat.freq_Hz         = 437e6;
cubesat.distance_km     = 1450;     % Slant range at 15 deg elevation angle
cubesat.tx_power_W      = 1.0;      % 1 W UHF transceiver
cubesat.tx_line_loss_dB = 0.8;
cubesat.tx_gain_dBi     = 2.15;     % Turnstile/dipole antenna
cubesat.rx_gain_dBi     = 14.0;     % Ground station Yagi array
cubesat.rx_line_loss_dB = 1.5;
cubesat.sys_temp_K      = 500;      % Sky + LNA noise temperature
cubesat.atm_loss_dB     = 0.5;
cubesat.pol_loss_dB     = 3.0;      % Linear-to-circular polarization mismatch
cubesat.data_rate_bps   = 9600;     % 9.6 kbps AX.25/GMSK-equivalent telemetry
cubesat.modulation      = 'BPSK';
cubesat.req_ber         = 1e-5;

res_cube = link_budget_calculator(cubesat);

% --- Scenario 2: LEO S-Band High-Rate Payload Downlink (2.2 GHz, 550 km orbit) ---
leo.freq_Hz         = 2.2e9;
leo.distance_km     = 1200;
leo.tx_power_W      = 5.0;
leo.tx_line_loss_dB = 1.0;
leo.tx_gain_dBi     = 6.0;          % Patch antenna
leo.rx_gain_dBi     = 32.0;         % 3.7m S-band parabolic dish
leo.rx_line_loss_dB = 1.2;
leo.sys_temp_K      = 290;
leo.atm_loss_dB     = 1.2;
leo.pol_loss_dB     = 0.5;
leo.data_rate_bps   = 2e6;          % 2 Mbps payload downlink
leo.modulation      = 'QPSK';
leo.req_ber         = 1e-6;

res_leo = link_budget_calculator(leo);

% --- Scenario 3: GEO Ku-Band Downlink (12 GHz, 35,786 km altitude) ---
geo.freq_Hz         = 12e9;
geo.distance_km     = 38500;
geo.tx_power_W      = 40.0;         % TWTA transponder
geo.tx_line_loss_dB = 1.5;
geo.tx_gain_dBi     = 30.0;         % Spot beam antenna
geo.rx_gain_dBi     = 42.0;         % 1.2m VSAT dish
geo.rx_line_loss_dB = 1.0;
geo.sys_temp_K      = 150;
geo.atm_loss_dB     = 3.5;          % Includes rain fade margin
geo.pol_loss_dB     = 0.4;
geo.data_rate_bps   = 10e6;         % 10 Mbps
geo.modulation      = 'QPSK';
geo.req_ber         = 1e-7;

res_geo = link_budget_calculator(geo);

% Display Comparison Table
scenarios = {'CubeSat UHF'; 'LEO S-Band'; 'GEO Ku-Band'};
EIRP_dBW    = [res_cube.eirp_dBW; res_leo.eirp_dBW; res_geo.eirp_dBW];
FSPL_dB     = [res_cube.fspl_dB; res_leo.fspl_dB; res_geo.fspl_dB];
EbN0_dB     = [res_cube.eb_n0_dB; res_leo.eb_n0_dB; res_geo.eb_n0_dB];
BER         = [res_cube.ber; res_leo.ber; res_geo.ber];
Margin_dB   = [res_cube.link_margin_dB; res_leo.link_margin_dB; res_geo.link_margin_dB];
Status      = {res_cube.status; res_leo.status; res_geo.status};

SummaryTable = table(scenarios, EIRP_dBW, FSPL_dB, EbN0_dB, BER, Margin_dB, Status);
disp(SummaryTable);

% Plot BER operating point for the CubeSat scenario
ber_curves(res_cube.eb_n0_dB, res_cube.ber, cubesat.modulation);
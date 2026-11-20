function results = link_budget_calculator(params)
% LINK_BUDGET_CALCULATOR Computes satellite RF downlink/uplink performance.
%
% Input struct 'params' fields:
%   freq_Hz         - Carrier frequency [Hz] (e.g., 2.2e9 for S-band)
%   distance_km     - Slant range distance [km]
%   tx_power_W      - Transmitter output power [W]
%   tx_line_loss_dB - Transmitter feeder/cable loss [dB]
%   tx_gain_dBi     - Transmitter antenna gain [dBi]
%   rx_gain_dBi     - Receiver antenna gain [dBi]
%   rx_line_loss_dB - Receiver feeder/cable loss [dB]
%   sys_temp_K      - Receiver system noise temperature [K]
%   atm_loss_dB     - Atmospheric + rain attenuation [dB]
%   pol_loss_dB     - Polarization + pointing loss [dB]
%   data_rate_bps   - Information bit rate [bps]
%   modulation      - 'BPSK' or 'QPSK'
%   req_ber         - Target Bit Error Rate (e.g., 1e-6)

    c = 2.99792458e8;       % Speed of light [m/s]
    k_dBW = -228.6;         % Boltzmann constant [dBW/(K*Hz)]

    % 1. Transmitter EIRP [dBW]
    tx_power_dBW = 10 * log10(params.tx_power_W);
    eirp_dBW = tx_power_dBW - params.tx_line_loss_dB + params.tx_gain_dBi;

    % 2. Free-Space Path Loss (FSPL) [dB]
    dist_m = params.distance_km * 1e3;
    lambda = c / params.freq_Hz;
    fspl_dB = 20 * log10(4 * pi * dist_m / lambda);

    % 3. Total Propagation & Implementation Losses [dB]
    total_loss_dB = fspl_dB + params.atm_loss_dB + params.pol_loss_dB + params.rx_line_loss_dB;

    % 4. Received Isotropic Power & Signal Power [dBW]
    rx_power_dBW = eirp_dBW - total_loss_dB + params.rx_gain_dBi;

    % 5. Receiver Figure of Merit (G/T) [dB/K]
    g_over_t_dBK = params.rx_gain_dBi - params.rx_line_loss_dB - 10 * log10(params.sys_temp_K);

    % 6. Carrier-to-Noise Spectral Density Ratio (C/N0) [dB-Hz]
    c_n0_dBHz = eirp_dBW - fspl_dB - params.atm_loss_dB - params.pol_loss_dB + g_over_t_dBK - k_dBW;

    % 7. Received Eb/N0 [dB]
    eb_n0_dB = c_n0_dBHz - 10 * log10(params.data_rate_bps);
    eb_n0_lin = 10^(eb_n0_dB / 10);

    % 8. Theoretical BER & Required Eb/N0 (Coherent BPSK & QPSK share identical Pb vs Eb/N0)
    switch upper(params.modulation)
        case {'BPSK', 'QPSK'}
            ber = 0.5 * erfc(sqrt(eb_n0_lin));
            req_eb_n0_lin = (erfcinv(2 * params.req_ber))^2;
            req_eb_n0_dB = 10 * log10(req_eb_n0_lin);
        otherwise
            error('Unsupported modulation. Choose ''BPSK'' or ''QPSK''.');
    end

    % 9. Link Margin [dB] (Target >= 3 dB for reliable satellite operations)
    link_margin_dB = eb_n0_dB - req_eb_n0_dB;

    % Package outputs
    results.eirp_dBW       = eirp_dBW;
    results.fspl_dB        = fspl_dB;
    results.rx_power_dBW   = rx_power_dBW;
    results.g_over_t_dBK   = g_over_t_dBK;
    results.c_n0_dBHz      = c_n0_dBHz;
    results.eb_n0_dB       = eb_n0_dB;
    results.req_eb_n0_dB   = req_eb_n0_dB;
    results.ber            = ber;
    results.link_margin_dB = link_margin_dB;
    results.status         = ternary(link_margin_dB >= 3.0, 'PASS (Nominal)', ...
                             ternary(link_margin_dB >= 0, 'MARGINAL (< 3 dB)', 'FAIL (Link Closure Failed)'));
end

function out = ternary(cond, trueVal, falseVal)
    if cond, out = trueVal; else, out = falseVal; end
end
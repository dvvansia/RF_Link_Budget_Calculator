function ber_curves(op_eb_n0_dB, op_ber, mod_type)
% BER_CURVES Plots theoretical + Monte Carlo BER curves and marks the satellite link operating point.

    eb_n0_range_dB = 0:0.5:14;
    eb_n0_lin = 10.^(eb_n0_range_dB / 10);
    ber_theory = 0.5 * erfc(sqrt(eb_n0_lin));

    % Monte Carlo validation (1e5 bits per SNR point)
    num_bits = 1e5;
    ber_sim = zeros(size(eb_n0_range_dB));
    tx_bits = randi([0 1], 1, num_bits);
    tx_sym = 2 * tx_bits - 1; % BPSK antipodal mapping (-1, +1)

    for idx = 1:length(eb_n0_range_dB)
        noise_std = sqrt(1 / (2 * eb_n0_lin(idx)));
        rx_sym = tx_sym + noise_std * randn(1, num_bits);
        rx_bits = rx_sym > 0;
        ber_sim(idx) = sum(tx_bits ~= rx_bits) / num_bits;
    end

    figure('Name', 'Satellite Link BER Performance', 'Color', 'w');
    semilogy(eb_n0_range_dB, ber_theory, 'b-', 'LineWidth', 2); hold on;
    semilogy(eb_n0_range_dB, ber_sim, 'ko', 'MarkerSize', 5);

    % Plot operating point if provided
    if nargin >= 2
        plot(op_eb_n0_dB, max(op_ber, 1e-12), 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
        legend(['Theoretical ' upper(mod_type)], 'Monte Carlo Simulation', ...
               sprintf('Operating Point (%.2f dB, BER=%.2e)', op_eb_n0_dB, op_ber), ...
               'Location', 'southwest');
    else
        legend('Theoretical BPSK/QPSK', 'Monte Carlo Simulation', 'Location', 'southwest');
    end

    grid on;
    ylim([1e-10 1]);
    xlim([0 14]);
    xlabel('E_b / N_0 [dB]', 'FontWeight', 'bold');
    ylabel('Bit Error Rate (BER)', 'FontWeight', 'bold');
    title('AWGN Channel Bit Error Rate Performance (BPSK / QPSK)', 'FontWeight', 'bold');
end
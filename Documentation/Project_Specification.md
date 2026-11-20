# RF Link Budget Calculator — Project Specification

## Objective
Build a MATLAB-based satellite link budget calculator that computes Eb/N0, BER, and link margin for QPSK/BPSK modulation schemes. This tool validates whether a satellite communication link meets reliability requirements before deployment.

## Why This Matters
Link budget analysis is fundamental to satellite communication system design. Every satellite mission (LEO, MEO, GEO) requires link margin verification to ensure reliable telemetry, tracking, and command (TT&C) as well as payload data downlink. This is a core skill for Communication Systems Engineers at ESA, DLR, Airbus Defence and Space, and OHB.

## Technical Requirements

### Core Calculations
1. **Friis Transmission Equation**
   - Pr = Pt + Gt + Gr - Lp - La - Lmisc (dB form)
   - Path loss: Lp = 20*log10(4*pi*d/lambda)
   - Frequency-dependent: lambda = c/f

2. **Carrier-to-Noise Ratio (C/N)**
   - C/N = EIRP + G/T - k - B - Ltotal
   - k = Boltzmann constant (-228.6 dBW/Hz/K)

3. **Energy-per-bit to Noise Ratio (Eb/N0)**
   - Eb/N0 = C/N - 10*log10(Rb/B)
   - Rb = bit rate, B = bandwidth

4. **Bit Error Rate (BER)**
   - BPSK: BER = 0.5 * erfc(sqrt(Eb/N0))
   - QPSK: BER = 0.5 * erfc(sqrt(Eb/N0/2))

5. **Link Margin**
   - Margin = (Eb/N0)available - (Eb/N0)required
   - Typical requirement: 3-6 dB margin for reliability

### Input Parameters
- Frequency (GHz)
- Distance/altitude (km)
- Transmit power (W or dBW)
- Transmit antenna gain (dBi)
- Receive antenna gain (dBi)
- System noise temperature (K)
- Bit rate (bps)
- Bandwidth (Hz)
- Modulation type (BPSK/QPSK)
- Atmospheric losses (dB)
- Implementation losses (dB)
- Required Eb/N0 for target BER (dB)

### Output Metrics
- Received power (dBW, dBm)
- Path loss (dB)
- EIRP (dBW)
- C/N (dB)
- Eb/N0 (dB)
- BER (dimensionless)
- Link margin (dB)
- Pass/Fail verdict

### MATLAB GUI Requirements
- Input panel with parameter fields
- Calculation button
- Results display panel
- BER vs Eb/N0 curve plot
- Link margin indicator (color-coded)
- Export results to CSV/PDF

## Learning Outcomes
1. Satellite communication link analysis
2. RF propagation and path loss modeling
3. Digital modulation theory (BPSK, QPSK)
4. Noise analysis and system temperature
5. MATLAB App Designer for GUI development
6. Communication system verification methodology

## Project Structure
```
RF_Link_Budget_Calculator/
├── MATLAB/
│   ├── link_budget_calculator.m      (Main calculation engine)
│   ├── ber_curves.m                  (BER plotting functions)
│   ├── rf_gui_app.mlapp              (MATLAB App Designer GUI)
│   └── test_cases.m                  (Verification scenarios)
├── Documentation/
│   ├── Project_Specification.md      (This file)
│   ├── Theory_Reference.md           (Equations and derivations)
│   └── User_Guide.md                 (How to use the tool)
├── Results/
│   ├── test_case_outputs/            (Saved calculation results)
│   └── ber_plots/                    (Exported figures)
├── Test_Cases/
│   ├── leo_satellite.mat             (LEO scenario parameters)
│   ├── geo_satellite.mat             (GEO scenario parameters)
│   └── ground_station.mat            (Ground link parameters)
└── README.md                         (GitHub project overview)
```

## Test Scenarios

### Scenario 1: LEO Satellite (ISS-like)
- Altitude: 400 km
- Frequency: 2.4 GHz (S-band)
- Data rate: 1 Mbps
- Verify: Link margin > 3 dB

### Scenario 2: GEO Satellite
- Altitude: 35,786 km
- Frequency: 12 GHz (Ku-band)
- Data rate: 10 Mbps
- Verify: Link margin > 5 dB

### Scenario 3: CubeSat Downlink
- Altitude: 500 km
- Frequency: 437 MHz (UHF)
- Data rate: 9600 bps
- Verify: BER < 10^-6

## Timeline
- Week 1: Theory study, Friis equation, noise analysis
- Week 2: MATLAB calculation engine implementation
- Week 3: GUI development in App Designer
- Week 4: Test cases, validation, documentation
- Week 5: GitHub publication, resume integration

## Resume Positioning
**Project Title:** RF Link Budget Calculator for Satellite Communications
**Skills Demonstrated:** Satellite link analysis, RF engineering, MATLAB, communication theory, system verification
**Target Roles:** Communication Systems Engineer, RF Engineer, Avionics Engineer, Satellite Systems Engineer

## References to Study
1. "Satellite Communications" by Dennis Roddy (Ch. 4, 5, 12)
2. "Digital Communications" by John Proakis (Ch. 5)
3. ESA ECSS-E-ST-50-05C (Space Engineering: Radio Frequency and Modulation)
4. MATLAB Communications Toolbox documentation

## Verification Criteria
- Calculator produces correct Eb/N0 within 0.1 dB of hand calculations
- BER curves match theoretical BPSK/QPSK performance
- Link margin correctly identifies feasible vs infeasible links
- GUI is intuitive and error-free for test scenarios

---
**Status:** Specification complete. Ready for implementation.
**Next Step:** Study Friis equation and noise analysis, then implement MATLAB calculation engine.

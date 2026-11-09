# IIR_filter
This repository contains verilog code that implements a First Order RC Filter as an IIR filter using the Bilinear Transform Method. The module has AXI4-Stream interfaces.

___

## First Order RC Low Pass Filter
<img width="230" height="151" alt="RCfilter" src="https://github.com/user-attachments/assets/8573feb4-ef58-436a-9a13-7e7a340c9660" />

The transfer function for the RC network is given as

$`H(s) = \frac{Vout(s)}{Vin(s)} = \frac{1}{1+\frac{s}{2\pi f_c}}`$

where the 3 db cutoff frequency is given by

$`f_c = \frac{1}{2\pi RC}`$

## Bilinear Transform
The bilinear transform maps continuous time transfer functions (s-domain) into discrete time equivalents (z-domain). The mapping is given by

$`s = \frac{2}{T} \frac{1-z^{-1}}{1+z^{-1}}`$

where T is the sampling period. Upon mapping RC Network's transfer function to the z-domain, we obtain the following equation

$`H(z) = \frac{b_0 + b_1 z^{-1}}{1 + a_1 z^{-1}}`$

The terms $`b_0`$, $`b_1`$ and $`a_1`$ are given by

$`b_0 = b_1 = \frac{1}{1 + \frac {f_s}{\pi f_c}}`$

$`a_1 = \frac{1- \frac {f_s}{\pi f_c}}{1 + \frac {f_s}{\pi f_c}}`$

These terms are then scaled according to required data width and set in the parameters section of the module.

## IIR Filter Structure

The sample domain function obtained from the z-domain transfer function is given as

$`y[n] = b_0 x[n] + b_1 x[n-1] - a_1 y[n-1]`$

The structure of the IIR filter is as follows

<img width="536" height="121" alt="IIR Filter drawio" src="https://github.com/user-attachments/assets/605af5b2-a665-4658-abac-8103d0d0fa73" />

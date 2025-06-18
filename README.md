# Unified Volterra-Series Metrics for Neuromorphic Computing

**Status:**  
This repository hosts the code and data accompanying the manuscript titled  
*"Unified Volterra-Series Metrics: Bridging Physical Dynamics and Computational Properties for Neuromorphic Computing"*,  
which is currently under submission to *Physical Review Letters (PRL)*.

The purpose of sharing this code is to promote transparency and reproducibility of our research.  
Please note that the repository content may be updated following the peer review process and eventual publication.

---

## Overview

This project contains code and data to reproduce the results presented in the above manuscript.  
It includes simulations of spintronic reservoirs, Volterra-series approximations, polynomial regressions for governing relationships, and benchmark tasks for NARMA.

---

## Reproduction Instructions

### A. Spintronic Reservoir Simulation

1. **Generate Damping Distribution**  
   Run `Damping_generation.m` in MATLAB to generate the damping distribution based on control parameters. The output will be automatically saved as a `.txt` file.

2. **Generate Input Magnetic Field**  
   Run `Input_field_generation.m` in MATLAB to generate the input magnetic field. This script will output both a `input_data.mat` file and a `.txt` file containing the generated data.

3. **Run Mumax3 Simulations**  
   Modify and run the three Mumax3 code files (`Mumax3Code1`, `Mumax3Code2`, `Mumax3Code3`) separately using the Mumax3 simulation tool.

4. **Convert Mumax3 Data**  
   Run `Mumax_data_save.m` in MATLAB to convert the raw Mumax3 output data into MATLAB data format.

5. **Combine System Responses**  
   The system responses are combined into a single matrix for further analysis. The resulting matrix is saved as `system_response.mat`.

---

### B. Volterra-Series Approximation

- Run `Main.m` in MATLAB. It loads `input_data.mat` and `system_response.mat` to perform the analysis.  
- Note: The code performs a linear order approximation followed by higher order terms to compute the Volterra-series metrics. This method uses a simple least squares regression. More advanced approximation methods may improve accuracy.

---

### C. Finding Governing Relationships

- Run `Curve_fit.m` in MATLAB. It loads `MEM_mean_matrix.mat`, `MEM_std_matrix.mat`, `NL_mean_matrix.mat`, and `NL_std_matrix.mat` for computation.
- Note: Polynomial regression is used to approximate the governing relationships.  


---

### D. NARMA Task Benchmarks

- Run NARMA2.m and NARMA10.m in MATLAB to perform the NARMA2 and NARMA10 tasks respectively. Both scripts load `input_data.mat` and `system_response.mat` for computation.

---

## Requirements

- [MATLAB](https://www.mathworks.com/products/matlab.html) (tested on R2023b or later recommended)  
- [Mumax3](https://mumax.github.io/) (for micromagnetic simulations)

---

## Citation

If you use this code in your research, please cite the corresponding manuscript once published.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Contact

For questions or issues, please open an issue in this repository or contact the author directly.

---

*Thank you for your interest in our work!*

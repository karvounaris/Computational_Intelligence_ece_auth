# 🤖 Computational Intelligence Project (Fuzzy Systems)

## 📖 Overview
This repository contains three distinct assignments completed as part of the Computational Intelligence course at Aristotle University of Thessaloniki. Each assignment applies different computational intelligence methods, demonstrating their capabilities and performance in control and modeling tasks. 

The assignments cover:
1. **Linear and Fuzzy Controllers**
2. **Fuzzy Logic Controller (FLC)**
3. **Takagi-Sugeno-Kang (TSK) Models**

---

## 🎯 Goals

### Assignment 1: Linear and Fuzzy Controllers
- Develop a **Proportional-Integral (PI)** controller for precise velocity control in high-accuracy mechanisms.
- Design and compare a **Fuzzy PI (FZ-PI)** controller with the linear PI controller.
- Evaluate the controllers on overshoot, rise time, and overall performance.

### Assignment 2: Fuzzy Logic Controller (FLC)
- Create an FLC to safely navigate a vehicle through obstacles to a target.
- Define rule bases and membership functions using MATLAB’s Fuzzy Logic Designer.
- Simulate and visualize the vehicle's trajectory for varying scenarios.

### Assignment 3: Takagi-Sugeno-Kang (TSK) Models
- Model regression tasks using four distinct TSK models with varying membership functions and output types.
- Optimize parameters through hybrid methods, combining backpropagation and least squares.
- Compare performance metrics such as RMSE, NMSE, and \( R^2 \).

---

## ✨ Features

### 📐 Assignment 1: Linear and Fuzzy Controllers
- **Linear PI Controller**:
  - Developed using MATLAB's Control System Designer.
  - Tuned to minimize overshoot (<7%) and rise time (<0.6s).
- **Fuzzy PI Controller**:
  - Inputs: Error (E) and Change in Error (dE).
  - Output: Control signal adjustment (dU).
  - Rule base: 49 rules for granular control.
- **Results**:
  - FZ-PI controller provided smoother responses but required additional tuning to match the linear PI’s rise time.

### 🌫️ Assignment 2: Fuzzy Logic Controller
- **Vehicle Navigation**:
  - Inputs: Vertical and horizontal distances to obstacles (dv, dh), and orientation (θ).
  - Output: Steering angle adjustment (Δθ).
  - Rules: Derived through logical scenarios and MATLAB's FLC tools.
- **Simulation**:
  - Successfully navigated through complex obstacle layouts.
  - Challenges addressed: Overshooting near obstacles and trajectory fine-tuning.

### 🔢 Assignment 3: Takagi-Sugeno-Kang Models
- **Datasets**:
  - Simple Dataset: Airfoil Self-Noise dataset.
  - High-Dimensional Dataset: Superconductivity dataset.
- **TSK Models**:
  - Variations in membership functions (Singleton vs. Polynomial).
  - Studied the effect of increasing membership function counts.
- **Results**:
  - Higher membership function counts improved accuracy (e.g., TSK Model 4 achieved \( R^2 = 0.887 \)).
  - Rule explosion mitigated through dimensionality reduction and grid search optimization.

---

## 🏆 Results
- **Linear vs. Fuzzy PI Controllers**:
  - Linear PI met specifications faster, while FZ-PI offered smoother performance with minimal overshoot.
- **Fuzzy Logic Controller**:
  - Enabled effective vehicle navigation, achieving close proximity to target positions.
- **TSK Models**:
  - Demonstrated the trade-off between model complexity and accuracy, achieving optimal configurations for both datasets.

---

## 🛠️ Techniques Utilized
- **Control System Design**: Linear PI tuning via MATLAB.
- **Fuzzy Logic**: Rule base design, membership function optimization, and FLC simulations.
- **Hybrid Optimization**: Combined backpropagation and least squares for TSK models.
- **Dimensionality Reduction**: PCA and Relief algorithms to combat high-dimensional challenges.

---

## 📂 Repository Contents
- **📄 Reports**:
  - [Assignment 1 Report: Linear and Fuzzy Controllers](./1_Computational_Intelligence_Theoharis.pdf)
  - [Assignment 2 Report: Fuzzy Logic Controller](./2_Panagiotis_Karvounaris_10193.pdf)
  - [Assignment 3 Report: TSK Models](./3_Panagiotis_Karvounaris_10193.pdf)
- **💻 Code**: MATLAB scripts and FIS models for all assignments.
- **📊 Results**: Visualizations and performance metrics.

---

## 🤝 Contributors
- [Panagiotis Karvounaris](https://github.com/karvounaris)

---

Thank you for exploring this project! 🌟 Feel free to raise issues or contribute to improve the repository. 🚀😊

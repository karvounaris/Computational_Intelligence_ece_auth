# 🤖 Computational Intelligence Project (Fuzzy Systems)

## 📖 Overview
This repository contains four distinct assignments completed as part of the Computational Intelligence course at Aristotle University of Thessaloniki. Each assignment applies different computational intelligence methods, demonstrating their capabilities and performance in control, modeling, classification, and regression tasks.

The assignments cover:
1. **Linear and Fuzzy Controllers**
2. **Fuzzy Logic Controller (FLC)**
3. **High-Dimensional Regression with TSK Models**
4. **High-Dimensional Classification with TSK Models**

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

### Assignment 3: High-Dimensional Regression with TSK Models
- Model regression tasks using four distinct TSK models with varying membership functions and output types.
- Optimize parameters through hybrid methods, combining backpropagation and least squares.
- Compare performance metrics such as RMSE, NMSE, and \( R^2 \).

### Assignment 4: High-Dimensional Classification with TSK Models
- Address classification problems with datasets of high dimensionality.
- Utilize **Subtractive Clustering (SC)** to generate rules and reduce complexity.
- Perform grid search optimization to determine the best parameters for TSK models.
- Compare performance metrics such as Overall Accuracy (OA), Producer’s Accuracy (PA), and User’s Accuracy (UA).

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

### 🔢 Assignment 3: High-Dimensional Regression with TSK Models
- **Datasets**:
  - Simple Dataset: Airfoil Self-Noise dataset.
  - High-Dimensional Dataset: Superconductivity dataset.
- **TSK Models**:
  - Variations in membership functions (Singleton vs. Polynomial).
  - Studied the effect of increasing membership function counts.
- **Results**:
  - Higher membership function counts improved accuracy (e.g., TSK Model 4 achieved \( R^2 = 0.887 \)).
  - Rule explosion mitigated through dimensionality reduction and grid search optimization.

### 🧬 Assignment 4: High-Dimensional Classification with TSK Models
- **Datasets**:
  - Haberman’s Survival dataset (low-dimensional).
  - Epileptic Seizure Recognition dataset (high-dimensional).
- **Clustering Methods**:
  - Class-independent and class-dependent clustering.
  - Subtractive Clustering for feature-space partitioning.
- **Parameter Optimization**:
  - Grid search to determine optimal cluster radius and feature count.
  - Relief algorithm for feature selection.
- **Results**:
  - Class-dependent models achieved better accuracy with fewer rules.
  - Optimal models minimized MSE but highlighted challenges with overlapping membership functions and low generalization ability.

---

## 🏆 Results
- **Linear vs. Fuzzy PI Controllers**:
  - Linear PI met specifications faster, while FZ-PI offered smoother performance with minimal overshoot.
- **Fuzzy Logic Controller**:
  - Enabled effective vehicle navigation, achieving close proximity to target positions.
- **TSK Models for Regression**:
  - Demonstrated the trade-off between model complexity and accuracy, achieving optimal configurations for both datasets.
- **TSK Models for Classification**:
  - Highlighted the importance of feature selection and parameter tuning in high-dimensional spaces.
  - Showcased the trade-off between rule count and classification accuracy.

---

## 🛠️ Techniques Utilized
- **Control System Design**: Linear PI tuning via MATLAB.
- **Fuzzy Logic**: Rule base design, membership function optimization, and FLC simulations.
- **Hybrid Optimization**: Combined backpropagation and least squares for TSK models.
- **Dimensionality Reduction**: PCA and Relief algorithms to combat high-dimensional challenges.
- **Grid Search Optimization**: Systematic exploration of parameters for optimal TSK model performance.

---

## 📂 Repository Contents
- **📄 Reports**:
  - [Assignment 1 Report: Linear and Fuzzy Controllers](./1_Computational_Intelligence_Theoharis.pdf)
  - [Assignment 2 Report: Fuzzy Logic Controller](./2_Panagiotis_Karvounaris_10193.pdf)
  - [Assignment 3 Report: TSK Models](./3_Panagiotis_Karvounaris_10193.pdf)
  - [Assignment 4 Report: High-Dimensional Classification](./4_Panagiotis_Karvounaris_10193.pdf)
- **💻 Code**: MATLAB scripts and FIS models for all assignments.
- **📊 Results**: Visualizations and performance metrics.

---

## 🤝 Contributors
- [Panagiotis Karvounaris](https://github.com/karvounaris)

---

Thank you for exploring this project! 🌟 Feel free to raise issues or contribute to improve the repository. 🚀😊

# RewardPredictionErrorAccumulation

This repository contains analysis code for the study:

Makino H. and Suhaimi A. (2025) Distributed representations of temporally accumulated reward prediction errors in the mouse cortex. Science Advances 11, eadi4782.  


## Dataset

The dataset required for this analysis is available on Zenodo: https://zenodo.org/records/13587722.  


## Agent training

The `PPO_algorithm` folder contains Python files for Proximal Policy Optimization (PPO) training.  

### Instructions:

1. **Install dependencies**:
   Ensure you have the following packages installed using `Python` (version == 3.7.16):
   - `numpy` (version == 1.21.6)
   - `gym` (version == 0.21.0)
   - `scipy` (version == 1.7.3)
   - `torch` (version == 1.13.1)

2. **Edit directory paths**:
   - Open the Python files in the `PPO_algorithm` folder.
   - Replace the placeholder directory path: `/home/user/Documents/Error/gym-navigation/` with the path to the directory containing the `gym_navigation` folder (e.g. `~/PPO_environment/gym-navigation/`).

3. **Move files**:
   - Transfer the Python files from the `PPO_algorithm` folder to the `gym-navigation` folder located in the `PPO_environment` folder.

4. **Run the code**:
   - Execute the scripts to initiate training.

Note:
The RL results described in this repository may exhibit slight variations if different software versions are used. However, the general trends and findings remain consistent across different setups.


## Correspondence

For inquiries or further information, please contact:

Hiroshi Makino  
Department of Physiology  
Keio University School of Medicine  
Email: hmakino@keio.jp

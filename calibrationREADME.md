# **calibration.m**
This script processes the static system calibration data obtained with LabVIEW to calculate the K-matrix.

## Section 1: Set parameters
This section is used to set parameters and flags for the script to use in the following sections.
1. If using the script to test a single CSV, set `singleFileBool` to `true`. Otherwise, set it to `false`.
2. If `singleFileBool` was set to true, set `single_idx` to the desired CSV index according to:
> [1,2,3,4,5,6,7,8,9,10,11,12] = [Fx+,Fx-,Fy+,Fy-,Fz+,Fz-,Tx+,Tx-,Ty+,Ty-,Tz+,Tz-]
3. Set `prefixfilename` to the directory where the CSV files are located. The default value assumes that it's 'FinalData', which is inside the same directory as this script. If this is not the case, change this variable's value.
4. Type the names of the CSV files in the `csvarray` array according to the order mentioned in step 2.
> If running the script for a single file, name the file in the correct index.
5. The `caseflag` array contains 12 booleans (for the 12 tests performed) that determine if the tests were done by using low-high steps `caseflag=0` (achieved by using weights), or high-low steps `caseflag=1` (achieved by using the crane).
6. The `calsensorflag` array contains 12 values (for the 12 tests performed) that determine the s-sensor calibration number that was used. Use `1` for sensor 1, `2` for sensor 2, `3` if both sensors were used for torque, and `4` if both sensors were used for force.
7. The `sf` variable is a 9x12 matrix containing the scaling factor values for the x, y, z components for the 3 sensors over the 12 experiments. The row follows the following order: [Fx1,Fx2,Fx3,Fy1,Fy2,Fy3,Fz1,Fz2,Fz3]
> By default, it's a matrix of 1's. **ONLY** change this if the scaling factors entered in LabVIEW didn't match the values of the charge amplifiers during data collection.
8. The lines following `sf` and before **Section 2** contain constants and don't need to be changed.

## Section 2: Read CSV files
This section is used to read the CSV files and store the 9 forces obtained by the three 3-axis force sensors in `Ftablefs` and the calibration forces recorded by the s-sensors in `FtableCS`.
If `singleFileBool` was set to `true`, it will only iterate once for the CSV file corresponding to `single_idx`.

## Section 3: Plot for Unknown Starting/Ending Points
This section is used to plot the data from 3-axis force sensors and from the calibration sensors. This is used to manually select the starting and ending points of the lows and highs of the load steps.
Run this section if the start and end points for a CSV file are unknown. The plot generated can be used to manually pick these points. Pick a range of ~1000 points. Write these points in the next section.

## Section 4: Start and End Points for All Steps
This section is used to record the start and end points for all steps for all the 12 files.
If running the script for a single file, write down these points for the corresponding file index.

## Section 5: Check Start and End Points
This section will plot 9 subplots (for each axis of each sensor) with vertical lines showing the start and end points to check if the selection of points was correct.

### Section 6: Create Diagram
This section creates a figure that shows a top-down view of the plate with the force sensors locations, and displays the corresponding x, y and z forces for each sensor, and it calculates the net forces and torques about the center.
This is helpful to analyze if the data recorded for calibration was performed properly by looking at the forces and torques and comparing them to what would be expected.
For instance, when doing Fx+ calibration, the net Fx should be positive. And forces on other axes should be (ideally) < 5% of Fx.

## Section 7: K-Matrix Creation Section
This section can only be run if all 12 tests have been performed, meaning that there are 12 CSV files, and all 12 start/end points have been found.
A 9x6 K matrix will be created at the end.
Save this matrix as "K96.mat".

## Section 8: Get Matrix Inverse
This section will reshape the matrix found in the previous section into a 6x6 matrix using the equations for `Vfx_Ks`, `Vfy_Ks`, `Vfz_Ks`, `Vtx_Ks`, `Vty_Ks`, and `Vtz_Ks`. This 6x6 matrix will then be inverted to be used to find the 'calibrated' loads.
Save this matrix as "K66inv.mat".
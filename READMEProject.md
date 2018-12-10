README for AJ and Jesse's project
cse824_calc_distance.m - calculates the distance from each node, given rssi from each node and model parameters
cse824driver.m - main file to apply the signal strength model to the experiments (more detailed description below)
				this file reads in experiment data as specified by the "filename" and
				sheet_names variables. It then runs through the previously generated
				signal strength model to turn the rssi/tpl measurements from each node
				into distance calculations. It then calls the trilateration function and
				outputs the results. Plots of the node distances over time are outputed.
				Note that the "actual" values are generated manually and artificially
				smoothed to account for operator movement. We realize this introduces
				potential error into the solution and it is listed in the future work
cse824_dronelander.m - this is the main file that generates the signal strength model from the calibration. See code comments for more detailed description
cse824_genmodel.m - actually calculates the fit parameters for the model generation, subfunction, used by dronelander
adjust_rssi.m - adjusts the rssi by the transmit power level, used by dronelander and the calcdistance function
cse824_trilateration.m - actually does the trilateration and is configured by the dronelander function. Outputs the estimated position and errors
Dataset_Networks.xlsx - this is all the data, calibration, actual, and experimental. Be careful modifying it though

How to run the code/reproduce results
Two main groups of code. With all the files listed above in the same directory, you can run as follows:
cse824_dronelander.m - Instructions on what the code does is mostly inline. Just running this file will 
generate a slew of plots and fit parameters. We typically would interatively change mtemp/ctemp to be
values from m_arr and c_arr. Changing mtemp and ctemp will change the model fit. Model tweaks can also
made by commenting out the adjustrssi calls, although this will decrease model accuracy. The output of this
for the project is finding the best m and c values for the model.

THe other main chunk of code to run is the cse824driver.m ... detailed instructions are given inline, but the
results of this will be reproduced directly, as is. To change the model used from this file, change the hardcoded
mtemp and ctemp values, or comment out adjustrssi function calls (although we picked the values and use the rssi adjust
the way it is for a reason)
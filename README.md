ASCII/Undecimal Square Area Calculator and Statistical Analysis

Overview

This assembly program processes square side lengths given in ASCII/undecimal (base-11) format, converts them into integers, computes the square areas, and performs statistical analysis on the results. The program outputs the sum, average, minimum, and maximum square areas, all displayed in ASCII/undecimal format.

Author:
Kosisochukwu Nwambuonwor


Features

This program performs the following tasks:

ASCII/Undecimal to Integer Conversion:
Converts a string of ASCII/undecimal digits into an integer representation.
Implements both direct code and a macro (aUndec2int) for this purpose.
Square Area Calculation:
Squares the side lengths (stored as integers) to compute the areas of squares.
Stores the areas in an array for further processing.
Statistical Analysis:
Calculates the sum, average, minimum, and maximum of the square areas.
Uses these values to provide key insights into the data set.
Integer to ASCII/Undecimal Conversion:
Converts integers back to ASCII/undecimal format for display.
Implements both direct code and a macro (int2aUndec) for this conversion.
Output Formatting:
Displays square areas in a neatly formatted manner, five areas per line.
Prints the calculated sum, average, minimum, and maximum areas.
Program Structure

Step 1: Convert an ASCII/undecimal string into an integer and store the result in a variable.
Step 2: Use the macro aUndec2int to convert multiple side lengths from ASCII/undecimal to integers, calculate their areas, and store the results.
Step 3: Compute the statistics (sum, average, minimum, and maximum) based on the areas of the squares.
Step 4: Convert the sum of the areas into an ASCII/undecimal string for display.
Step 5: Use the macro int2aUndec to convert the average, minimum, and maximum values for display.

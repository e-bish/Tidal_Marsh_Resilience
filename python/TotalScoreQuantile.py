# Description: This script was written to score the TotalScore field by quantile rankings.
# Requirements:  
# Author: Jamie Carter
# Date: 10-30-19

# Import modules
import arcpy
import numpy as np

# Set path for feature class or table with metrics to be scored
in_features = r"C:\\Documents\Westward Ecology\Marsh Resilience\Marsh Resilience_Python\marsh_resilience_slr_national_2010"

# Create numpy array from table and convert to float
arrp = arcpy.da.FeatureClassToNumPyArray(in_features, 'QuantileScoreSum')
arr = np.array(arrp,np.float)

# Set up quantile breaks
p1 = np.percentile(arr, 10)  
p2 = np.percentile(arr, 20)  
p3 = np.percentile(arr, 30)  
p4 = np.percentile(arr, 40)
p5 = np.percentile(arr, 50)
p6 = np.percentile(arr, 60)  
p7 = np.percentile(arr, 70)  
p8 = np.percentile(arr, 80)  
p9 = np.percentile(arr, 90)
p10 = np.percentile(arr, 100)

# Create update cursor
with arcpy.da.UpdateCursor(in_features , ['QuantileScoreSum','TotalScore_Quantile']) as cursor:
    # Loop through rows with update cursor. 
    for row in cursor:
        # Conditional statements to assign quantile score for the field value. Null values are given score of zero. 
        if row[0] == None:
            row[1] = 0
        elif row[0] <= p1:
            row[1] = 1  
        elif p1 <= row[0] and row[0] < p2:
            row[1] = 2
        elif p2 <= row[0] and row[0] < p3:
            row[1] = 3
        elif p3 <= row[0] and row[0] < p4:
            row[1] = 4
        elif p4 <= row[0] and row[0] < p5:
            row[1] = 5
        elif p5 <= row[0] and row[0] < p6:
            row[1] = 6
        elif p6 <= row[0] and row[0] < p7:
            row[1] = 7
        elif p7 <= row[0] and row[0] < p8:
            row[1] = 8
        elif p8 <= row[0] and row[0] < p9:
            row[1] = 9
        else:
            row[1] = 10
                        
        # Update row for QuantileField
        cursor.updateRow(row)

# Create numpy array from table and convert to float
arrp = arcpy.da.FeatureClassToNumPyArray(in_features, 'CurrentConditionSum')
arr = np.array(arrp,np.float)

# Set up quantile breaks
p1 = np.percentile(arr, 10)  
p2 = np.percentile(arr, 20)  
p3 = np.percentile(arr, 30)  
p4 = np.percentile(arr, 40)
p5 = np.percentile(arr, 50)
p6 = np.percentile(arr, 60)  
p7 = np.percentile(arr, 70)  
p8 = np.percentile(arr, 80)  
p9 = np.percentile(arr, 90)
p10 = np.percentile(arr, 100)

# Create update cursor
with arcpy.da.UpdateCursor(in_features , ['CurrentConditionSum','CurrentConditionSum_Quantile']) as cursor:
    # Loop through rows with update cursor. 
    for row in cursor:
        # Conditional statements to assign quantile score for the field value. Null values are given score of zero. 
        if row[0] == None:
            row[1] = 0
        elif row[0] <= p1:
            row[1] = 1  
        elif p1 <= row[0] and row[0] < p2:
            row[1] = 2
        elif p2 <= row[0] and row[0] < p3:
            row[1] = 3
        elif p3 <= row[0] and row[0] < p4:
            row[1] = 4
        elif p4 <= row[0] and row[0] < p5:
            row[1] = 5
        elif p5 <= row[0] and row[0] < p6:
            row[1] = 6
        elif p6 <= row[0] and row[0] < p7:
            row[1] = 7
        elif p7 <= row[0] and row[0] < p8:
            row[1] = 8
        elif p8 <= row[0] and row[0] < p9:
            row[1] = 9
        else:
            row[1] = 10
                        
        # Update row for QuantileField
        cursor.updateRow(row)

# Create numpy array from table and convert to float
arrp = arcpy.da.FeatureClassToNumPyArray(in_features, 'VulnerabilitySum')
arr = np.array(arrp,np.float)

# Set up quantile breaks
p1 = np.percentile(arr, 10)  
p2 = np.percentile(arr, 20)  
p3 = np.percentile(arr, 30)  
p4 = np.percentile(arr, 40)
p5 = np.percentile(arr, 50)
p6 = np.percentile(arr, 60)  
p7 = np.percentile(arr, 70)  
p8 = np.percentile(arr, 80)  
p9 = np.percentile(arr, 90)
p10 = np.percentile(arr, 100)

# Create update cursor
with arcpy.da.UpdateCursor(in_features , ['VulnerabilitySum','VulnerabilitySum_Quantile']) as cursor:
    # Loop through rows with update cursor. 
    for row in cursor:
        # Conditional statements to assign quantile score for the field value. Null values are given score of zero. 
        if row[0] == None:
            row[1] = 0
        elif row[0] <= p1:
            row[1] = 10  
        elif p1 <= row[0] and row[0] < p2:
            row[1] = 9
        elif p2 <= row[0] and row[0] < p3:
            row[1] = 8
        elif p3 <= row[0] and row[0] < p4:
            row[1] = 7
        elif p4 <= row[0] and row[0] < p5:
            row[1] = 6
        elif p5 <= row[0] and row[0] < p6:
            row[1] = 5
        elif p6 <= row[0] and row[0] < p7:
            row[1] = 4
        elif p7 <= row[0] and row[0] < p8:
            row[1] = 3
        elif p8 <= row[0] and row[0] < p9:
            row[1] = 2
        else:
            row[1] = 1
                        
        # Update row for QuantileField
        cursor.updateRow(row)

# Create numpy array from table and convert to float
arrp = arcpy.da.FeatureClassToNumPyArray(in_features, 'AdaptiveCapacitySum')
arr = np.array(arrp,np.float)

# Set up quantile breaks
p1 = np.percentile(arr, 10)  
p2 = np.percentile(arr, 20)  
p3 = np.percentile(arr, 30)  
p4 = np.percentile(arr, 40)
p5 = np.percentile(arr, 50)
p6 = np.percentile(arr, 60)  
p7 = np.percentile(arr, 70)  
p8 = np.percentile(arr, 80)  
p9 = np.percentile(arr, 90)
p10 = np.percentile(arr, 100)

# Create update cursor
with arcpy.da.UpdateCursor(in_features , ['AdaptiveCapacitySum','AdaptiveCapacitySum_Quantile']) as cursor:
    # Loop through rows with update cursor. 
    for row in cursor:
        # Conditional statements to assign quantile score for the field value. Null values are given score of zero. 
        if row[0] == None:
            row[1] = 0
        elif row[0] <= p1:
            row[1] = 1  
        elif p1 <= row[0] and row[0] < p2:
            row[1] = 2
        elif p2 <= row[0] and row[0] < p3:
            row[1] = 3
        elif p3 <= row[0] and row[0] < p4:
            row[1] = 4
        elif p4 <= row[0] and row[0] < p5:
            row[1] = 5
        elif p5 <= row[0] and row[0] < p6:
            row[1] = 6
        elif p6 <= row[0] and row[0] < p7:
            row[1] = 7
        elif p7 <= row[0] and row[0] < p8:
            row[1] = 8
        elif p8 <= row[0] and row[0] < p9:
            row[1] = 9
        else:
            row[1] = 10
                        
        # Update row for QuantileField
        cursor.updateRow(row)

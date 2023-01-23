# Description: This script was written to score HUC feature metric values by quantile rankings.
# Requirements: HUC ID field must contain "HUC". Table sould only included HUC ID field and the metrics fields to be scored. Default/required fields like Object_ID and Shape fields will be ignored. 
# Author: David Betenbaugh
# Date: 8-26-2019

# Import modules
import arcpy
import numpy as np

# Set path for feature class or table with metrics to be scored
in_features = rics_final02202020"

# Create list of fields
fields = arcpy.ListFields(in_features)

# Add field to count non-null values and calculate to equal zero
arcpy.AddField_management(in_features,"NonNULLMetricsCount","SHORT")
arcpy.CalculateField_management(in_features,"NonNULLMetricsCount","0","PYTHON_9.3")

# Add field to sum all quantile scores and calculate to equal zero
arcpy.AddField_management(in_features,"QuantileScoreSum","SHORT")
arcpy.CalculateField_management(in_features,"QuantileScoreSum","0","PYTHON_9.3")

# Loop through fields
for field in fields:
    # Skip HUC ID field
    if field.required == False:
        if "HUC" in field.name:
            print "Skipping " + field.name
            
        # For each metric field, add a new field to capture quantile score and calculate to equal zero
        else:
            QuantileField = field.name + "_Quantile"
            arcpy.AddField_management(in_features,QuantileField,"SHORT")

            print field.name

            # Create numpy array from table and convert to float
            arrp = arcpy.da.FeatureClassToNumPyArray(in_features, field.name)
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

        
            print "Analyzing and updating rows"

            # Create update cursor
            with arcpy.da.UpdateCursor(in_features , [field.name,QuantileField,"NonNULLMetricsCount","QuantileScoreSum"]) as cursor:
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

                    # Conditional statements for "NonNULLMetricsCount"
                    if row[0] == None:
                        row[2]=row[2]
                    else:
                        row[2] = row[2] + 1

                    # Conditional statement for "QuantileScoreSum"
                    row[3] = row[3] + row[1]

                    # Update row for "NonNULLMetricsCount" and "QuantileScoreSum"
                    cursor.updateRow(row)

print "Done"


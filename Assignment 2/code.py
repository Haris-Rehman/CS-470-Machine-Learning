import numpy as np
import pandas as pd
                            # TASK 1
print("\n\t\t\tTask No. 1")
print("\nStudent Data", end = "\n\n")
col0 = ['Ambrine', 'Samrine', 'Nasreen', 'Flourine', 'Chlorine']
col00 = ['SEECS', 'SEECS', 'SMME', 'SADA', 'SCME']
col1 = [1, 2, 9, 6, 5]
col2 = [5, 6, np.nan, np.nan, 8]
col3 = [3,np.nan, 5,4,10]
d = {'Student':col0, 'Department':col00, 'Test-A':col1, 'Test-B':col2, 'Test-C':col3}
df = pd.DataFrame(d)
print(df)

print("\nDisplay Average of each student", end = "\n\n")
df_new = df.fillna(0)
df_new['Average'] = df_new[df_new.columns].mean(axis=1)
print(df_new)

                            # TASK 2
print("\n\t\t\tTask No. 2")
print("\nAward Average marks in Test-B", end = "\n\n")
df['Test-B'] = df['Test-B'].fillna(value=df['Test-B'].mean())
print(df)

print("\nAverage marks in test by grouping into schools", end = "\n\n")
bySchool = df.groupby('Department')
print(bySchool.mean())

print("\nAverage marks of each student", end = "\n\n")
df_new = df.fillna(0)
df_new['Average'] = df_new[df_new.columns].mean(axis=1)
print(df_new)

                            # TASK 3
print("\n\t\t\tTask No. 3")
print("\nA new student added", end = "\n\n")
df = df.append(
    {'Student' : 'Bromine', 
    'Department' : 'NBS',
    'Test-A' : 3,
    'Test-B' : 9,
    'Test-C' : 7}, ignore_index = True)
print(df)

print("\nAverage of all students", end = "\n\n")
df_new = df.fillna(0)
df_new['Average'] = df_new[df_new.columns].mean(axis=1)
print(df_new)

############################
### Creating ReadMe file ###
############################

import os, re
from pathlib import Path

## Setting directory
cwd = os.getcwd()
root = Path(cwd).parents[0]
inputdir = str(Path(root)) + str('/input')
print(root)

# Opening file
readMeFilePath = str(root) + str('/ReadMe.txt')
file = open(readMeFilePath, "w")

first_text = ["To reproduce the results: \n",
              "1. Open do-file master.do \n",
              "2. Change global stem with your path to the folder reproducing_results \n",
              "3. Run master.do\n",
              "\n",
              "__________________________\n",
              "Structure and contents: \n"]

file.writelines(first_text)

# Listing folders, subfolders and files
for foldername, subfolders, filenames in os.walk(root):

    filenames = [f for f in filenames if not f[0] == '.']
    subfolders[:] = [d for d in subfolders if not d[0] == '.']
    
    foldername = foldername.replace(str(root), "")
    
    print("The current folder is " + foldername)
    file.write("The current folder is " + foldername)
    file.write("\n")
    
    for subfolder in subfolders:
        print("Subfolder " + "/" + subfolder)
        file.write("    -Subfolder " + "/" + subfolder)
        file.write("\n")
        
    for filename in filenames:
        print("File inside " + ": " + filename)
        file.write("         -File inside " + ": " + filename)
        file.write("\n")
            
    print(" ")
    file.write("\n")
    file.write("\n")


file.close() 

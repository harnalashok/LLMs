# Last amended: 4th Sep, 2026
# Obj: Demonstrate the use of __name__ = __main__ variable
# Every Python file has a built-in variable called __name__. 
#  Its value changes depending on how the file is run.

"""
The if __name__ == "__main__": statement is a control mechanism used
to prevent code from automatically running when a Python file is 
imported into another script. 

Whenever the Python interpreter reads a source file, it automatically 
sets a few hidden, built-in variables. One of these variables 
is __name__. 

How Python assigns a value to __name__ depends entirely on 
how you run the file:

1. Running the script directly: If you execute the file from
   your terminal (e.g., python script.py), Python designates 
   this file as the application entry point. It automatically
   sets the variable __name__ = "__main__". 
2. Importing the script as a module: If you import this file 
   into another script (e.g., import script), Python sets 
   the variable __name__ equal to the actual filename 
   (e.g., __name__ = "script"). 

"""





def say_greet():
    print("Hello! Welcome to the Python world.")
    

def ok_greet():
    print("My name is ashok kumar harnal.")



if __name__ == "__main__":
    say_greet()
    
        
        
        

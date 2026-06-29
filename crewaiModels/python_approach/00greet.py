# Last amended: 25th June, 2026
# Obj: Demonstrate the use of __name__ = __main__ variable
# Every Python file has a built-in variable called __name__. 
#  Its value changes depending on how the file is run.

def say_greet():
    print("Hello! Welcome to the Python world.")
    

def ok_greet():
    print("My name is ashok kumar harnal.")



if __name__ == "__main__":
    say_greet()
    
        
        
        

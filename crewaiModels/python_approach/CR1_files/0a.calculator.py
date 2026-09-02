# Last amended: 2nd Sep, 2026
# calculator.py
# Obj: Demonstrate the use of __name__ = __main__ variable
# Every Python file has a built-in variable called __name__. 
#  Its value changes depending on how the file is run.

# python 0a.calculator.py


def add(a: float, b: float)-> float:
    return a + b

def subtract(a: int, b: int) -> int:
    return a - b

if __name__ == "__main__":
    # This only runs when you do: python calculator.py
    # It does NOT run when someone does: import calculator
    print(add(10, 5))       # 15
    print(subtract(10, 5))  # 5
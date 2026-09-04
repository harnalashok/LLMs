"""
In Python, a class is simply a blueprint or a template 
for creating objects. Objects are concrete instances of 
that blueprint, containing real data and functional 
behaviors.

Think of a class like a blueprint for a house. The 
blueprint itself isn't a house—it just describes 
how a house should look and act. When you use that 
blueprint to actually build a physical home, 
that home is the object (or instance). 

To understand classes, you only need to master 
four core concepts: the class keyword, 
the constructor (__init__), the self variable, 
and methods.

"""

class Dog:
    # 1. The Constructor (Initializer)
    def __init__(self, name, breed):
        self.name = name    # Instance attribute
        self.breed = breed  # Instance attribute
        
    # 2. A Method (Behavior)
    def bark(self):
        return f"{self.name} says Woof!"


"""

__init__ method
===============
The __init__ method is a special function that automatically 
runs the exact moment you create a new object from the class. 
Its job is to initialize the object with data (called attributes)

self parameter
==============
The self parameter represents the specific object you are 
currently creating or manipulating. 

When you type self.name = name, you are telling Python: 
"Give this specific dog a property called name, and set it to 
the value I provided."You must include self as the first argument
in __init__ and any other methods inside the class. However, 
you don't pass it manually when calling them—Python handles 
it behind the scenes

Methods
=======
Methods are just functions defined inside a class. They represent 
the actions or behaviors that the object can perform 
(like a dog barking or a car accelerating).

"""

# Once the blueprint is built, you can generate as many unique 
# objects as you want from it

# Creating two separate dog objects (instantiation)
dog1 = Dog("Buddy", "Golden Retriever")
dog2 = Dog("Luna", "Husky")

# Accessing attributes using dot notation
print(dog1.name)   # Output: Buddy
print(dog2.breed)  # Output: Husky

# Calling methods on the objects
print(dog1.bark()) # Output: Buddy says Woof!
print(dog2.bark()) # Output: Luna says Woof!

"""
Pydantic classes are specifically built for data validation 
and settings management.

Instead of writing manual validation code to check if an email 
is valid, if an age is a positive integer, or if a required 
field is missing, Pydantic handles it all automatically using 
standard Python type hints.

"""

# To create a Pydantic class, you inherit from its core building
# block: BaseModel.

from pydantic import BaseModel, EmailStr, Field

# Defining a Pydantic Class
class User(BaseModel):
    id: int
    name: str
    email: EmailStr  # Automatically validates email formatting
    age: int = Field(gt=0, lt=120)  # Age must be between 1 and 119

# Passing a string "42" for age, and "1" for id
valid_user = User(id="1", name="Alice", email="alice@example.com", age="42")

print(valid_user.id)   # Output: 1 (Converted automatically to an int!)
print(valid_user.age)  # Output: 42 (Converted automatically to an int!)
# Description

These two programs implement the simulation of a file management system on a hard drive. The first program manages a one-dimensional array of files, while the second works with a two-dimensional matrix. Both programs provide file management functionalities, including adding, deleting, searching for files, and defragmenting memory. The program that works with the two-dimensional matrix includes an additional feature for managing files based on a directory path, which allows it to read information such as the file ID and its size.

### Common Features (for both programs):
1. Adding a file:
    The program can add a new file to the system, assigning it an ID and placing it in the appropriate memory location (one-dimensional array or two-dimensional matrix).
2. Deleting a file:
	Allows for the deletion of an existing file, freeing up the allocated memory space.
3. Finding a file:
	Searches for a file in the allocated memory (array or matrix) based on its ID.
4. Defragmenting the drive:
	Provides the option to defragment memory, rearranging files to eliminate free spaces between them and optimizing performance.

### Additional Feature for the Two-Dimensional Program:
Managing files based on a directory:
	If a directory path is provided, the program will read information such as the file ID and its size, and will determine if the file can be added to the matrix based on available space.<br/>
	If there is insufficient space for the file, the program will signal an error.

## How the Programs Work:    

Both programs function by receiving commands from the terminal or from an input file:
##### 1.The first number read will represent the number of commands the program will receive.
##### 2. Add command:
If the program receives command number 1 it means we would like it to add a file in memory.<br/>
After reading 1, the program expects another number that repressents how many files we wish to add.<br/>
For example, if it receives 2, it will expect 2 files as input.<br/>
When we want to add a file the format is id and then size in kb (each of the blocks represent 8kb). Ex: 2 43 -> it means we want to add a file with the id of 2 and size of 43kb (this will take up 5 block)<br/>
After finishing, the program prints "id: (starting_point, ending_point)" for the one-dimensional program and "id: ((start_x, start_y), (end_x, end_y))". If there wasn't enough space it will just return "(0,0)" or "((0,0),(0,0))".
##### 3. Get command:
If the program receives 2 as input it will expect an id.<br/>
It will look for the id inside the memory, if it finds it then it  will print out "id: (start, end)" or "id: ((startx, starty), (stopx, stopy))".<br/>
If the file is not in the memory the program will print out "(0,0)" or "((0,0),(0,0))".
##### 4. Delete command:
If the program receives 3 as input it will expect a valid id(an id that is inside the memory).<br/>
After finding it, the program will print the whole memory. The same format that is used for add will be used here as well.
##### 5. Defragmentaion command:
If the program receives 4 as input it will perform a defragmentaion.<br/>
Defragmentation implies that it will "compress" the files inside the memory,by removing the free space between files.<br/>
After it is done the program prints out the full memory, the samw way it does for delete.

## Extra functionality for the two-dimensional program
#### 1. Add and defragmentaion
The first difference between the two programs is that if a file does not fit on one line, it won.t be split in two.<br/>
The program will continue to look for free space until finding enough space to fit the whole file on one line.<br/>
If this is not possible the file will not be added to memory.

#### 2. Concrete
The two-dimensional program has another command, the concrete command
##### Usage:
If the program receives command 5 it will look inside the path provided to it inside the "path" variable. It will open the directory and then each of the files inside the directory and get their unique ids and sizes. The id will be then divided by 256 and the remainder will become the id used inside the program<br/>
Then it will add them to the memory if the id of the file isn't already inside the memory.

# How to run
## For compiling run the following program
    
    ./run.sh filenName.s fileName
Inside run.sh is a simple shell script I wrote to help me compile faster.

## One-dimensional program.

    ./task1 
If you run this you will have to give input manually

    ./task1 < input.txt

This is how you run it in order to give the input through a file.

## Two-dimensional program

    ./task2
    ./task2 < input.txt

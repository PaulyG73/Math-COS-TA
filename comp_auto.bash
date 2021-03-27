# MIT License

# Copyright (c) 2021 Paul Guertin

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# comp_auto.bash
# This bash script searches for .cpp files and compiles them to run on the linux subsystem.
# It then runs each executable just compiled and stores the output in a text file.



OUTPUT=output_execute.txt           # text file where output is stored
COMPILE=compile_files.txt           # text file where source code paths are stored
PROGRAMS=programs.txt               # text file where executable paths are stored
S_PROGRAMS=sorted_programs.txt       # same as PROGRAMS but lines are sorted alphabetically

# read SOURCE, the directory containing the source code
echo Enter source code directory:
read SOURCE
echo SOURCE ------- $SOURCE

# read Input, the text file where input values are stored
echo Enter input value file:
read INPUT
echo INPUT ------- $INPUT

# find all .cpp files and store their paths in COMPIlE
find $SOURCE | grep .cpp > $COMPILE

# determine how many .cpp files there are and ask user if they want to compile and run their executables 
COMPILE_NUM=$(wc -l $COMPILE)
COMPILE_NUM=${COMPILE_NUM% *}
echo Are you sure you want to compile and run $COMPILE_NUM executable? Y/n
read DECISION

# exit script and return 1 if the user cancels the compilation
if [[ $DECISION != Y ]]
then
    echo Compilation terminated
    exit 1
fi

# read COMPILE and compile each .cpp file using g++
# LINE holds the path of the .cpp file
while read LINE 
do
    echo
    echo
	echo ---- FILENAME ----
	echo
	echo "$LINE"
	echo
	echo ---- COMPILING ----

    NAME=${LINE%.*}

    echo NAME--------
    echo "$NAME"

	g++ -o "$NAME.out" "$LINE"

    

done < $COMPILE

# remove COMPILE
rm -f $COMPILE

# find all .out files and store their paths in PROGRAMS
find . | grep .out | sort -z > $PROGRAMS

# sort PROGRAMS so that each line is in alphabetical order and store results in S_PROGRAMS
sort $PROGRAMS > $S_PROGRAMS

# execute each .out file stored in S_PROGRAMS and append results in OUTPUT
# LINE holds the path of the .out file
while read LINE
do
    echo ------ >> "$OUTPUT"
    echo >> "$OUTPUT"
    echo "$LINE" >> "$OUTPUT"

    ./"$LINE" < "$INPUT" >> "$OUTPUT"

    echo >> "$OUTPUT"
    echo ------ >> "$OUTPUT"

done < $S_PROGRAMS

# remove PROGRAMS and S_PROGRAMS
rm -f $PROGRAMS
rm -f $S_PROGRAMS

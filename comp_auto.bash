# comp_auto.bash
# This script searches for .cpp files and compiles them to run on the linux subsystem.
# It then runs each executable just compiled and stores the output in a text file.
# Last modified 2/26/2021 by Paul Guertin


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
#!/bin/bash

# Define classpath
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# Clean up directories
rm -rf student-submission
rm -rf grading-area
mkdir grading-area

# Clone student's submission from the provided repository URL
git clone $1 student-submission
echo 'Finished cloning'

# Check if ListExamples.java file exists
if [ -f "./student-submission/ListExamples.java" ]; then 
    echo "ListExamples.java file found."
else
    echo "ListExamples.java file not found."
    echo "Grade: 0"
    exit
fi

# Copy necessary files to grading area
cp TestListExamples.java student-submission/*.java grading-area
cp -r lib grading-area

# Move to grading area
cd grading-area

# Compile Java code
javac -cp $CPATH *.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compiled Successfully!"
else 
    echo "Did not compile successfully."
    exit
fi

# Run JUnit tests and capture output
test_output=$(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples)

# Extract the number of test failures
failures=$(echo "$test_output" | grep -o "Failures: [0-9]*" | awk '{print $2}')

# Extract the number of tests run
tests_run=$(echo "$test_output" | grep -o "Tests run: [0-9]*" | awk '{print $3}')

# Store the failure score as a variable
failure_score=$failures

# Store the failure score as a variable
total_score=$tests_run

# Check if all tests passed
if [ -z "$failure_score" ]; then
    echo "Every Test Passed!"
    exit
else
    echo "Failure score: $failure_score"
    exit
fi

# Continue with post-processing or grading based on the failure score

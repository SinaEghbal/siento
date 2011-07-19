TML - Matlab integration (2009)

This zip contains all libraries and examples to use TML from Matlab.
Please unzip the contents of this file in a directory called 'tml' in your Matlab user directory:

Windows C:\Users\YourUser\Documents\MATLAB
MacOSX /Users/YourUser/MATLAB

Now, Matlab uses Lucene for its search function within the product help. As TML uses
Lucene as well, you need to update to a version that TML will work with. You need to perform
two steps to do this.

Step 1 - Copy the new versions

Copy from the tml\lib folder, the two files:
lucene-analyzers-2.3.1.jar
lucene-core-2.3.0.jar

in the Matlab folder C:\Program Files\MATLAB\Rxxxxa\java\jarext

(NOTE: You can keep the old versions in case you want to rollback the changes)

Step 2 - Update Matlab's classpath

Change C:\Program Files\MATLAB\Rxxxxa\toolbox\local\classpath.txt

Comment the previous version and add the final two lines
## $matlabroot/java/jarext/lucene-analyzers-2.0.0.jar
## $matlabroot/java/jarext/lucene-core-2.0.0.jar
$matlabroot/java/jarext/lucene-analyzers-2.3.1.jar
$matlabroot/java/jarext/lucene-core-2.3.0.jar

Done.

Now, you can run Matlab.
To start using TML, you must run the init.m script, which loads TML and all the libraries required for it to run.

Detailed instructions on how to execute tml from Matlab can be found in the example.m script.

Enjoy!

Jorge Villalon
villalon@ee.usyd.edu.au
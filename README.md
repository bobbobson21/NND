# contents
 o [how to set up](#how-to-set-up)  
 o [how to run](#how-to-run)  
 o [how to get back a result](#how-to-get-back-a-result)  

#how to set up
The first step to setting this up is to check the settings at the top and change them to meet your needs. The fist setting you should change is the input settings which tells the program how many inputs there are and what the names of them is. The input and output maps however basically is used to perform a replace on anything going into the network and on everything coming out.

The disassembly detail on the other hand is used to determine how much float detail is used 0 means your network runs on int's and 1 is impossible (infinite detail is not calculable) and 0.98 is the best for float tasks. The range defines the numerical min and max range of numbers it will go though.

The connection function is one of the most important parts of this system as it is how you connect NND to a neural network. how it works is simple the function will receive the inputs, passed though the map, NND wants to test your code (which you have to write in this function) will then communicate that data to the network and then a response will be returned in the function that will go though the output map.

#how to run

To run the system on a network you need to run nnd:RunDisassemblyCollectData() and after this you will have to wait for it to finish which will take a long time as it has a big O of O((MaxRange-MinRange)^ NumOfInputs) so do double check the connection function works before this.

#how to get back a result

To get a result you can use nnd:DisassemblyDataToDisassembly() to get the result as a string or you can use nnd:DisassemblyDataToDisassemblyOutToFile( File ) to output it to a file you can view in a coding language of your choice. The result you are getting by the way is a function written using the values defined by DisassemblyTable.

to define the values used in DisassemblyTable it is recommended you use nnd:LoadDisassemblyTableFromExternalFile() along with an external file which contains the values you want.
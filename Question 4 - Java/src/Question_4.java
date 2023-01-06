// Name the package.
package src;

// Import java's Input/Output library.
import java.io.*;

// Define the main class, with the file's name.
public class Question_4{
    // Define the main function which is called when the file is called.
    public static void main(String[] args) {
        try{
            // Get the file name from the first parameter.
            File file = new File(args[0]);

            // Read the file by instantiating a FileReader object.
            FileReader fileReader = new FileReader(file);
            // Buffer the text by instantiating a BufferedReader object.
            BufferedReader bufferedReader = new BufferedReader(fileReader);

            // Init a line var to hold the current line's text.
            String line;
            // Init an array that will hold the assignments of each of the two elves in the line.
            String[] assignments;
            // Init the answer variable at 0.
            Integer answer = 0;
            // While there are lines to read:
            while ((line = bufferedReader.readLine()) != null){
                // Fill the assignments array by splitting the line at the coma separator.
                assignments = line.split(",");

                // Get the lower and upper bounds of each assignment as ints by splitting at the hyphen seperator.
                int lowerBoundA = (int) Integer.parseInt(assignments[0].split("-")[0]);
                int UpperBoundA = (int) Integer.parseInt(assignments[0].split("-")[1]);
                int lowerBoundB = (int) Integer.parseInt(assignments[1].split("-")[0]);
                int UpperBoundB = (int) Integer.parseInt(assignments[1].split("-")[1]);

                //  if any the first assignments bouds are between the second's or vice versa.
                if ((lowerBoundA >= lowerBoundB && lowerBoundA <= UpperBoundB) || 
                    (UpperBoundA >= lowerBoundB && UpperBoundA <= UpperBoundB) ||
                    (lowerBoundB >= lowerBoundA && lowerBoundB <= UpperBoundA) || 
                    (UpperBoundB >= lowerBoundA && UpperBoundB <= UpperBoundA))  {
                    // Increase the answer's value by 1.
                    answer += 1;
                } 
            }
            // Close the reader.
            bufferedReader.close();

            // Print the answer.
            System.out.print(answer);
        // If the file is not found or not given:
        } catch (Exception fileNotFounException) {
            // Return an error message informing the user that an argument is needed.
            System.out.print("File not found. Be sure to include the file's path as argument.");
        }
    }
}
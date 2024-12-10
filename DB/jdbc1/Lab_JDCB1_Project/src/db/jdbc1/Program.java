package db.jdbc1;
import java.util.Scanner;

public class Program {
	public static void main(String[] args) {
		//Examples to read by keyboard
		System.out.println("Read an integer by keyboard");	
		int integ = ReadInt();
		System.out.println("Read a string by keyboard");	
		String str = ReadString();
	}

    /*
        1. Develop a Java method that shows the results of queries 21 and 32 from lab session SQL2.
        1.1. (21) Name and surname of customers that have bought a car in a 'madrid' dealer that has 'gti' cars.
    */
	public static void exercise1_1() {
		
	}
	
    /*
        1.2. (32) Dealers having an average stockage greater than the average stockage of all dealers together.
    */
	public static void exercise1_2() {
		
	}
	
    /*
        2. Develop a Java method that shows the results of query 6 from lab session SQL2, so that the search color is inputted by the user.
            (6) Names of car makers that have sold cars with a color that is inputted by the user.
    */
	public static void exercise2() {
		
	}
	
    /*
        3. Develop a Java method to run query 27 from lab session SQL2, so that the limits for the number of cars are inputted by the user.
            (27) CIFD of dealers with a stock between two values inputted by the user inclusive.
    */
	public static void exercise3() {
		
	}
	
    /*
        4. Develop a Java method to run query 24 from lab session SQL2, so that the city of the dealer and the color are inputted by the user.
            (24) Names of the customers that have NOT bought cars with a user-defined color at dealers located in a user-defined city.
    */
	public static void exercise4() {
		
	}
	
    /*
        5. Develop a Java method that, using the suitable SQL sentence:
        5.1 Creates cars into the CARS table, taking the data from the user.
    */
	public static void exercise5_1() {
		
	}
	
    /*
        5.2. Deletes a specific car. The code for the car to delete is defined by the user.
    */
	public static void exercise5_2() {
		
	}
	
    /*
        5.3. Updates the name and model for a specific car. The code for the car to update is defined by the user
    */
	public static void exercise5_3() {		
		
	}
	
    /*
        6. Invoke the exercise 10 function and procedure from lab session PL1 from a Java application.
            (10) Develop a procedure and a function that take a dealer id and return the number of sales that were made in that dealer.
        6.1. Function
    */
	public static void exercise6_1() {		
			
	}
	
    /*
        6.2. Procedure
    */
	public static void exercise6_2() {		
			
	}
	
    /*
        7. Invoke the exercise 11 function and procedure from lab session PL1 from a Java application.
            (11) Develop a procedure and a function that take a city and return the number of customers in that city.
        7.1. Function
    */
	public static void exercise7_1() {		
			
	}	
	
    /*
        7.2. Procedure
    */
	public static void exercise7_2() {		
				
	}
	
    /*
        8. Develop a Java method that displays the cars that have been bought by each customer. Besides, it must display the number of cars that each customer has bought and the number of dealers where each customer has bought. Customers that have bought no cars should not be shown in the report.
    */
	public static void exercise8() {		
			
	}
		
	@SuppressWarnings("resource")
	private static String ReadString(){
		return new Scanner(System.in).nextLine();		
	}
	
	@SuppressWarnings("resource")
	private static int ReadInt(){
		return new Scanner(System.in).nextInt();			
	}	
}

package db.jdbc2;
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
    2. Implement a Java application that:
    b. Shows a list that includes, for the cinemas of a given location, the total income obtained in each cinema as well as the one obtained for each film shown in it.
    	Cinema 1 - Total income
			Code film 1 - Title 1 - Total_income_film1_in_cinema1
			Code film 2 - Title 2 - Total_income_film2_in_cinema1
		Cinema 2 - Total income
			Code film 1 - Title 1 - Total_income_film1_in_cinema1
			Code film 2 - Title 2 - Total_income_film2_in_cinema1
			Code film 3 - Title 3 - Total_income_film2_in_cinema2
    */
	public static void exercise2_b() {

	}

    /*
    3. Implement a JAVA application that:
    a. Shows a list that includes, for each film, the following information:
        Film title 1
            Cinema 1
                Room - Session - Number of spectators
                Room - Session - Number of spectators
            Cinema 2
                Room - Session - Number of spectators
                Room - Session - Number of spectators
    */
	public static void exercise3_a() {

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

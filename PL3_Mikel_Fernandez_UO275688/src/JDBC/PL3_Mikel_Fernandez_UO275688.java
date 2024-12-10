package JDBC;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

public class PL3_Mikel_Fernandez_UO275688 {

		//ORACLE	
		private static String USERNAME = "EVAL_JUL_UO275688";
		private static String PASSWORD = "passuo275688";
		private static String CONNECTION_STRING = "jdbc:oracle:thin:@156.35.94.99:3389:DESA";
	
		public static void main(String[] args) throws ParseException {		
			try {
				Delivery4_Exercise1("DEMIOZSJAR");
				Delivery4_Exercise2();
				Delivery4_Exercise3();
				Delivery4_Exercise4();				
			} catch (SQLException e) {			
				System.err.println("SQL Exception " + e.getMessage());
				e.printStackTrace();
			}
		}
		
		private static void Delivery4_Exercise1(String code) throws SQLException {
			System.out.println("################### EXERCISE 1 ###################");
			Connection con = getConnection();			
			
			//We create a 'cursor' of the orders passing by parameter the code of the order
			String orders = ("SELECT s.code, s.description, i.price, i.quantity\r\n"
					+ "FROM tsparepart s, tis_in i\r\n"
					+ "WHERE s.code=i.sparepart_code AND i.order_code=?");
			
			//We pass the parameter and execute the query, then show the result
			PreparedStatement orders2 = con.prepareStatement(orders.toString());
			orders2.setString(1, code);
			
			ResultSet orders3 = orders2.executeQuery();
			
			showResults(orders3);
			
			//We need to check if it was received
			String wasReceived = ("SELECT status\r\n"
					+ "FROM torder\r\n"
					+ "WHERE code=?");
			
			PreparedStatement wasReceived2 = con.prepareStatement(wasReceived.toString());
			wasReceived2.setString(1, code);
			ResultSet wasReceived3 = wasReceived2.executeQuery();
			wasReceived3.next();
			
			String status = wasReceived3.getString("status").toUpperCase();
			
			//Order is pending
			if(status.equals("PENDING")) {
				//We need to update from PENDING to RECEIVED and also the date
				String recieveUpdate = "UPDATE torder \r\n" + 
						"SET status='RECEIVED' AND reception_date=SYSDATE\r\n" + 
						"WHERE code=?";
				
				PreparedStatement recieveUpdate2 = con.prepareStatement(recieveUpdate.toString());
				recieveUpdate2.setString(1, code);
				
				if(recieveUpdate2.executeUpdate() == 1) {
					System.out.println("Data successfully deleted.");
					recieveUpdate2.close();
				}
				else {
					System.err.println("Some error has ocurred, not updated.");
					recieveUpdate2.close();
				}
			
				//Later used to update the stock and the price from the spareparts
				String updateStockPrice = "UPDATE tsparepart \r\n" + 
						"SET stock = ?, price = ?\r\n" + 
						"WHERE code = ?";
				
				PreparedStatement updateStockPrice2 = con.prepareStatement(updateStockPrice.toString());
				
				//In order to select the price and the stock for each sparepart
				String sparepart = "SELECT price, stock \r\n"
						+ "FROM tsparepart \r\n"
						+ "WHERE code=?\r\n";  

				while(orders3.next()) {
					PreparedStatement sparepart2 = con.prepareStatement(sparepart.toString());
					sparepart2.setString(1, code);
					ResultSet sparepart3 = sparepart2.executeQuery();
					
					//We initialize these variables to the values of the price and stockage 
					//from the spareparts and the quantity of the order
					double prevPrice = sparepart3.getDouble("price");
					double priceOrder = orders3.getDouble("price");
					int prevStock = sparepart3.getInt("stock");
					int quantity = sparepart3.getInt("quantity");
					int quantityOrder = orders3.getInt("quantity");

					//We update the values of the stock and price					
					int newStock = prevStock + quantity; 
					double newPrice = (prevStock * prevPrice + 1.2 * quantityOrder * priceOrder) / newStock;

					updateStockPrice2.setInt(1, newStock);
					updateStockPrice2.setDouble(2, newPrice);
					updateStockPrice2.setString(3, code);
					updateStockPrice2.close();
				}
			}
			//If the status of the order equals RECEIVED
			else {
				System.out.print("The order has been received");
				wasReceived3.close();
				wasReceived2.close();
			}
			
			wasReceived3.close();
			orders3.close();
			con.close();
		}
		
		private static void Delivery4_Exercise2() throws SQLException {
			System.out.println("################### EXERCISE 2 ###################");
			Connection con = getConnection();

			//We declare two attributes representing then number of invoices paid and not paid and initialize them to zero
			int paid = 0;
			int notPaid = 0;
			
			//We create a 'cursor' of the invoices passing later on the parameter requested to the user
			String invoices = "SELECT * FROM tinvoice WHERE numb IN (\r\n"
					+ "        SELECT DISTINCT invoice_numb \r\n"
					+ "        FROM tvehicle v, tworkorder w \r\n"
					+ "        WHERE w.vehicle_pn=v.platenumber AND v.client_dni= ?)\r\n"
					+ "    	   ORDER BY status, in_date ASC"; 
			
			//The user must be asked for a DNI
			System.out.print("Select a DNI: ");
			String dni = ReadString(); 
			 
			//The input parameter is dni the user just got asked for and execute it
			PreparedStatement invoices2 = con.prepareStatement(invoices.toString());
			invoices2.setString(1, dni);

			ResultSet invoices3 = invoices2.executeQuery();

			//We create another cursor in order to obtain the vehicles given the numb parameter from the invoice and
			//select the plate number, brand, the number of work orders and the sum of the amount
			String vehicles = ("SELECT platenumber, brand, COUNT(invoice_numb) AS num_workorders, SUM(amount) AS tot_amount \r\n"
					+ "    FROM tvehicle v, tworkorder w \r\n"
					+ "    WHERE v.platenumber=w.vehicle_pn AND w.invoice_numb=?\r\n"
					+ "    GROUP BY platenumber, brand");
			
			PreparedStatement vehicles2 = con.prepareStatement(vehicles.toString());

			//We declare new variables
			int numb = 0;
			double amount = 0;
			double vat = 0;
			String status;
			
	        //We print the necessary information and for each invoice we sum the amount to the previous variables
			while(invoices3.next()) {
				numb = invoices3.getInt("numb");
				amount = invoices3.getDouble("amount");
				vat = invoices3.getDouble("vat");
				status = invoices3.getString("status");
				
				//PAID
				if(status.toUpperCase().equals("PAID")) 
					paid += amount;
				
				//NOT PAID
				if(status.toUpperCase().equals("NOT_YET_PAID"))
					notPaid += amount;
								
				System.out.println("*INVOICE: -" + numb + " --" + invoices3.getDate("in_date") 
						+ " -- " + amount + " -- " + vat + " -- " + status);
			
				vehicles2.setInt(1, numb);
				
				ResultSet vehicles3 = vehicles2.executeQuery();
				
				while(vehicles3.next()) {
					String platenumber = vehicles3.getString("platenumber"); 
					String brand = vehicles3.getString("brand"); 
					int num_workorders = vehicles3.getInt("num_workorders"); 
					int tot_amount = vehicles3.getInt("tot_amount"); 

					System.out.println("	-VEHICLE: " + platenumber + " -- " + brand + 
							" -- " + num_workorders + " -- " + tot_amount);
				}
				vehicles3.close();
			}
			
			System.out.println("TOTALS");
			System.out.println("NOT_YET_PAID: " + notPaid);
			System.out.println("PAID: " + paid);

			invoices3.close();
			vehicles2.close();
			invoices2.close();
			con.close();			
		}
		
		private static void Delivery4_Exercise3() throws SQLException, ParseException {
			System.out.println("################### EXERCISE 3 ###################");
			
			System.out.println("WHAT DO YOU NEED?");
			System.out.println("REGISTER, DEREGISTER or QUERY");
			String answer = ReadString();
			
			if(answer.equals("REGISTER"))
				register();
			else if(answer.equals("DEREGISTER"))
				deregister();
			else if(answer.equals("QUERY"))
				query();
			else
				System.out.println("Error, can only REGISTER, DEREGISTER or QUERY");		
		}
		
		private static void register() throws SQLException, ParseException {
			System.out.println("################### REGISTER ###################");
			Connection con = getConnection();
			
			//The user is asked for a plate number from a vehicle
			System.out.println("Select a year: ");
			int year = ReadInt();
			System.out.println("Select a month (number): ");
			int month = ReadInt();
			System.out.println("Select a day (number): ");
			int day = ReadInt();

			String pattern = "dd/MM/yy";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			Date woDate = simpleDateFormat.parse(""+ day + "/" + month + "/" + year);
			java.sql.Date woDate2 = new java.sql.Date(woDate.getTime());
			
			System.out.println("Register a plate number from a vehicle: ");
			String platenum = ReadString();
			System.out.println("Register a mechanic dni: ");
			String dni = ReadString();
			int inter_date = java.sql.Types.DATE;
			System.out.println("Register the minutes: ");
			int minutes = ReadInt();
			
			//We need to create the query to insert the values to tintervention in order to register
			String insert = ("INSERT INTO tintervention (wo_date,vehicle_pn,mechanic_dni,inter_date,minutes) "
					+ "VALUES (?,?,?,?,?)");
	
			//We pass the previous variables
			PreparedStatement insert2 = con.prepareStatement(insert.toString());
			insert2.setDate(1, woDate2);
			insert2.setString(2, platenum);
			insert2.setString(3, dni);
			insert2.setInt(4, inter_date);
			insert2.setInt(5, minutes);
			
			//We try to execute it
			if(insert2.executeUpdate() == 1)
				System.out.println("Data successfully registered.");
			else
				System.out.println("Some error has ocurred, data could not be inserted.");
	        
			insert2.close();
			con.close();			
		}

		private static void deregister() throws SQLException {
			System.out.println("################### DEREGISTER ###################");
			Connection con = getConnection();
			
			//We create the variable to ask the user which car they want to deregister
			System.out.println("Select a vehicle plate number: ");
			String platenum = ReadString();
			
			//We have to create the query to deregister given plate number previously asked
			String delete = ("DELETE FROM tintervention WHERE vehicle_pn=?");
			
			PreparedStatement delete2 = con.prepareStatement(delete.toString());
			delete2.setString(1, platenum);
			
			//We try to execute it
			if(delete2.executeUpdate() == 1)
				System.out.println("Data successfully deregistered.");
			else
				System.out.println("Some error has ocurred, data could not be deleted.");
	        
			delete2.close();
			con.close();
		}

		
		private static void query() throws SQLException, ParseException {
			System.out.println("################### QUERY ###################");
			Connection con = getConnection();
			
			//The user is asked for a plate number from a vehicle
			System.out.println("Select a year: ");
			int year = ReadInt();
			System.out.println("Select a month (number): ");
			int month = ReadInt();
			System.out.println("Select a day (number): ");
			int day = ReadInt();

			String pattern = "dd/MM/yy";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			Date woDate = simpleDateFormat.parse(""+ day + "/" + month + "/" + year);
			java.sql.Date woDate2 = new java.sql.Date(woDate.getTime());
			
			System.out.println("Register a mechanic dni: ");
			String dni = ReadString();
			
			System.out.println("Select a year (2 digits): ");
			year = ReadInt();
			System.out.println("Select a month (number): ");
			month = ReadInt();
			System.out.println("Select a day (number): ");
			day = ReadInt();

			Date inter_date = simpleDateFormat.parse(""+ day + "/" + month + "/" + year);
			java.sql.Date inter_date2 = new java.sql.Date(inter_date.getTime());
			
			//We create the query selecting the data we want to show given the ones the used got asked for
			String query = ("SELECT p.code, p.description, p.price, COUNT(ss.provider_nif) AS numSupplies\r\n"
					+ "FROM tintervention i, tsubstitution s, tsparepart p, tsupply ss\r\n"
					+ "WHERE ?=s.wo_date AND i.vehicle_pn=s.vehicle_pn AND ?=s.mechanic_dni \r\n"
					+ "AND ?=s.inter_date AND s.sparepart_code=p.code AND p.code=ss.sparepart_code\r\n"
					+ "GROUP BY p.code, p.description, p.price");
			
			//We set the parameters the user provided and execute the query so that we can show it later on
			PreparedStatement query2 = con.prepareStatement(query.toString());
			query2.setDate(1, woDate2);
			query2.setString(2, dni);
			query2.setDate(3, inter_date2);

			ResultSet query3 = query2.executeQuery();
			
			showResults(query3);
			
			query3.close();
			query2.close();
			con.close();
		}
		
		private static void Delivery4_Exercise4() throws SQLException {
			System.out.println("################### EXERCISE 4 ###################");
			Connection con = getConnection();
			
			//The user will get asked for the brand of the vehicle
			System.out.print("Select a brand: ");
			String brand = ReadString();
			
			//We use a CallableStatement in order to call the function previously created in the second delivery
			CallableStatement function = con.prepareCall("{? = call DELIVERY2_EXERCISE3(?,?)}"); 

			//We pass the parameter of the brand
			function.setString(2, brand);
			
			//We need to pass the output parameter and the value the function returns
			//The value that returns is an integer (the number of substitutions)
			function.registerOutParameter(1, java.sql.Types.INTEGER);
			
			//The VARCHAR parameter is the plate number
			function.registerOutParameter(3, java.sql.Types.VARCHAR);
			
			//We execute the function
			function.execute();
			
			//We need to create some variables so that we can print them later on
			String plateNum = function.getString(3);
			int numSubs = function.getInt(1);
			
			System.out.println("* VEHICLE: " + plateNum + " - number of substitutions: " + numSubs);

			function.close();
			con.close();			
		}	

		// ------------------- DATABASE UTILS -------------------
		private static Connection getConnection() throws SQLException{
			if(DriverManager.getDriver(CONNECTION_STRING) == null)
				if(CONNECTION_STRING.contains("oracle"))	
					DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
				else
					DriverManager.registerDriver(new org.hsqldb.jdbc.JDBCDriver());
			return  DriverManager.getConnection(CONNECTION_STRING,USERNAME,PASSWORD);
		}
		
		/**
		 * Method to invoke Oracle stored procedure.
		 * The procedure has one IN parameter and another OUT parameter.  
		 * @throws SQLException
		 */
		private static void showResults(ResultSet rs) throws SQLException {
			int columnCount = rs.getMetaData().getColumnCount();
			StringBuilder headers = new StringBuilder();
	        
			for(int i = 1; i < columnCount ; i++)
				headers.append(rs.getMetaData().getColumnName(i) + "\t");
			headers.append(rs.getMetaData().getColumnName(columnCount));
	        
			System.out.println(headers.toString());
			StringBuilder result = null;
	        
			while (rs.next()) {
				result = new StringBuilder();	
				for(int i = 1; i < columnCount ; i++)
					result.append(rs.getObject(i) + "\t");
				result.append(rs.getObject(columnCount));
				System.out.println(result.toString());
			}
	        
			if(result == null)
				System.out.println("No data found.");
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
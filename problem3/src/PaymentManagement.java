import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class PaymentManagement {
	
	/** method that helps to connect orders and payments in own database. **/
	/** parameter passed is database connection **/
	/** return type is void **/
	public void reconcilePayments(Connection database) {
        try {
        	/** create statement for executing data base queries **/
            Statement stmt1 = database.createStatement();
            Statement stmt2 = database.createStatement();
            Statement stmt3 = database.createStatement();
            
            /** Created ArrayLists for storing order numbers and customer numbers **/
            ArrayList<Integer> orderNumbers = new ArrayList<Integer>();
            ArrayList<Integer> customerNumbers = new ArrayList<Integer>();
            
            /** created result set statement for executing the query to get the payments **/
            ResultSet rs2 = stmt2.executeQuery("select * from payments order by paymentDate;");
               
            /** Iterated through the payment tables and map each check number accordingly **/
    		while(rs2.next()) {
    			/** retrieve the details from the payments table **/
    			double amount = rs2.getDouble("amount");
    			String checkNumber = rs2.getString("checkNumber");
    			int customerNumber = rs2.getInt("customerNumber");
    			
    			/** created result set statement for executing the query to get the orders that are shipped and resolved **/
    			ResultSet rs1 = stmt1.executeQuery("select * from orders where status in ('Shipped', 'Resolved') and customerNumber = '"+ customerNumber +"' order by customerNumber, orderDate;");
    			    		
    			/** Iterated through the orders table for the respective customer number **/
    			while(rs1.next()) {
    				/** check for the customers that are not in the customers that are not mapped to the check numbers **/
	    			if(!customerNumbers.contains(customerNumber)) {
	    				if(rs1.getString("checkNumber") != null) {
	    					continue;
	    				}
	    				else {
	        				double orderTotal = rs1.getDouble("orderTotal");
            				orderNumbers.add(rs1.getInt("orderNumber"));
            				
            				/** if the order is not mapped to the check amount take the difference from the total amount **/
	            			if(orderTotal != amount) {
	            				/** changes into double value using formatter **/
	            				String amountFormatter = new DecimalFormat("#.##").format((amount - orderTotal));
	            				amount = Double.parseDouble(amountFormatter);
	            			}
	            			
	            			/** if the amount is mapped update the database using execute update **/
	            			if(rs1.getDouble("orderTotal") == amount || amount == 0) {
	            				if(rs1.getDouble("orderTotal") == amount) {
	            					if(rs2.getDate("paymentDate").compareTo(rs1.getDate("orderDate")) < 0) {
	            						break;
	            					}
	            				}
	            				for(Integer orderNumber: orderNumbers) {
	            					//stmt3.executeQuery("SET SQL_SAFE_UPDATES = 0;");
	    	        				stmt3.executeUpdate("update orders \r\n" + 
	    	        	            		"    set checkNumber = '"+ checkNumber +"' \r\n" + 
	    	        	            		"    where customerNumber = '"+ customerNumber +"' and orderNumber = '"+ orderNumber +"';");  
	            				}
	            				orderNumbers.clear();
	            				//stmt3.executeQuery("SET SQL_SAFE_UPDATES = 0;");
	            				stmt3.executeUpdate("update payments \r\n" + 
		        	            		"    set pairStatus = 'checkPaired' \r\n" + 
		        	            		"    where  customerNumber = '"+ customerNumber +"' and  checkNumber = '"+ checkNumber +"';"); 

	            				break;
	            				
	            			}
	            			
	            			/** if the amount is matched clear the array list iterate to the other orders **/
	            			if(orderTotal == rs2.getDouble("amount") && !orderNumbers.isEmpty()) {
	            				customerNumbers.add(customerNumber);
	            				orderNumbers.clear();
	            				break;
	            			}
	            			
	            			else if(amount > 0) {
	            				continue;
	            			}
	            			else {
	            				orderNumbers.clear();
	            				break;
	            			}    					
	    				}
	    			}
    			}
    			/** close the result set **/
    			rs1.close();
    		} 
    		
    		/** close the result set and statements **/
    		rs2.close();
    		stmt1.close();
    		stmt2.close();
    		stmt3.close();
        }
        /** handle the sql exceptions **/
        catch(SQLException ex) {
            System.out.println("Database error"+ ex.getMessage());
        }
	}
	
	/** method that records the receipt of a payment, with the given cheque number, that is	supposed to cover all of the listed orders. **/
	/** parameter passed is database connection, amount to be paid, cheque_number and list of orders **/
	/** return type is boolean **/
	public boolean payOrder(Connection database, float amount, String cheque_number, ArrayList<Integer> orders) {
		try {
	        Statement stmt2 = database.createStatement();
	        Statement stmt3 = database.createStatement();
			
			int i = 0, customerNumberCheck = 0;
			/** change the given amount to double amount **/
			String amountChange = new DecimalFormat("#.##").format(amount);
			double totalOrderAmount = Double.parseDouble(amountChange);
			double totalAmount = 0;
			
			/** iterate through the list of orders **/
			for(Integer orderNumber: orders) {
				
				/** retrieve the order total and customer number for the particular order **/
				ResultSet rs2 = stmt2.executeQuery("select orderTotal, customerNumber from orders where orderNumber = '"+ orderNumber+ "' and checkNumber is null;");
				
				/** check the result set if any else return false **/
				if(!rs2.next()) {
					return false;
				}
				
				/** check if all the orders belong to the same customer **/
				if(i != 0 && customerNumberCheck != rs2.getInt("customerNumber")) {
					return false;
				}
				String amountFormatter = new DecimalFormat("#.##").format(totalAmount + rs2.getDouble("orderTotal"));
				totalAmount = Double.parseDouble(amountFormatter);
				
				customerNumberCheck = rs2.getInt("customerNumber");
				i++;
			}
			
			/** if the total amount is not equal to the amount to be paid return false **/
			if(totalAmount != totalOrderAmount) {
				return false;
			}
			else {
				/** iterate through all the customers and update the orders and payments table **/
				for(Integer orderNumber: orders) {
					stmt3.executeUpdate("update orders\r\n" + 
							"set checkNumber = '"+ cheque_number +"' \r\n" + 
							"where orderNumber = '"+ orderNumber +"';");
				}
	
				stmt3.executeUpdate("insert into payments(customerNumber, checkNumber, paymentDate, amount, pairStatus) \r\n" + 
						"values ('"+ customerNumberCheck +"','"+ cheque_number +"',curdate(),'"+ totalOrderAmount +"','checkPaired');");
				
				return true;
			}
		}
		/** handle sql exception **/
        catch(SQLException ex) {
            System.out.println("Database error"+ ex.getMessage());
            return false;
        }
	}
	
	/** method that returns a list of all the orders for which we have no record of a payment in the database and excluding cancelled and disputed orders. **/
	/** parameter passed is database connection **/
	/** return type is arraylist **/
	public ArrayList<Integer> unpaidOrders(Connection database) {
		/** create the arraylist of integers for adding all the unpaid orders **/
		ArrayList<Integer> unPaidOrderList = new ArrayList<Integer>();
		try {
			Statement stmt = database.createStatement();
			/** execute the query for the orders where the check number is null and that are not cancelled and disputed **/
			ResultSet rs = stmt.executeQuery("select *\r\n" + 
					"	from orders \r\n" + 
					"    where checkNumber is null and status not in ('Cancelled', 'Disputed');");
			
			while(rs.next()) {           	
				unPaidOrderList.add(rs.getInt("orderNumber"));
			}
			rs.close();
			stmt.close();
			/**  return the unpaid order list **/
			return unPaidOrderList;
		}
		/** handle the sql exception **/
        catch(SQLException ex) {
            System.out.println("Database error"+ ex.getMessage());
            return unPaidOrderList;
        }
		
	}

	/** method that returns a list of all the cheque numbers that haven’t managed to pair up with orders in the database. **/
	/** parameter passed is database connection **/
	/** return type is arraylist **/
	public ArrayList<String> unknownPayments(Connection database) {
		/** created the arraylist for storing the unknown payments**/
		ArrayList<String> unknownPaymentList = new ArrayList<String>();
		try {			
			Statement stmt = database.createStatement();
			/** execute the query that are paired with the orders **/
			ResultSet rs = stmt.executeQuery("select *\r\n" + 
					"	from payments \r\n" + 
					"    where pairStatus is null;");
			
			while(rs.next()) {         
				/** add the unknown payments to the list **/
				unknownPaymentList.add(rs.getString("checkNumber"));
			}	
			rs.close();
			stmt.close();
			return unknownPaymentList;
		}
		/** handle the sql exception **/
        catch(SQLException ex) {
            System.out.println("Database error"+ ex.getMessage());
            return unknownPaymentList;
        }
	}
	
}

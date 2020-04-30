
import java.sql.*;

/** class that creates database **/
public class DbConnection {
	
	/** data base details for data base connection **/
	
    private static String url = "jdbc:mysql://db.cs.dal.ca:3306?serverTimezone=UTC";    
    private static String driverName = "com.mysql.cj.jdbc.Driver";   
    private static String userName = "itekela";   
    private static String password = "B00839907";
    private static Connection connection = null;
	
    /** method that helps to connect the data base **/
	public static Connection getConnection() {		
		try {
			/** loads the data base driver **/
			Class.forName(driverName);
			
			/** get the driver connection **/
			connection = DriverManager.getConnection(url, userName, password);
		} 
		catch(ClassNotFoundException e) {
			e.printStackTrace();
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;
	}
	
	/** close the connection established **/
	public void closeConnection() {
		try {
			connection.close();
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
}

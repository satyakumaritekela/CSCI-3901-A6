import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class PaymentUI {
	public static void main(String[] args) throws SQLException {
		
		PaymentManagement p = new PaymentManagement();
		
		Connection database = DbConnection.getConnection();
		Statement stmt1 = database.createStatement();
		//p.reconcilePayments();
		
		/*System.out.println("Unknown payments");
		for(String checkNumber: p.unknownPayments(database)) {
			System.out.println(checkNumber);
		}
		System.out.println("");
		System.out.println("Unpaid orders");
		for(Integer orderNumber: p.unpaidOrders(database)) {
			System.out.println(orderNumber);
		}*/
		stmt1.execute("use itekela;");
		p.reconcilePayments(database);
		
		/*ArrayList<Integer> orders = new ArrayList<Integer>();
		
		orders.add(10412);
		
		System.out.println(p.payOrder(database, (float) 2326.18, "AC131256", orders));*/
		
	}
}

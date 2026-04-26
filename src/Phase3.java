import java.nio.file.FileSystemNotFoundException;
import java.sql.*;
import java.util.*;

public class Phase3 {
    private static final String username = "msegui";
    private static final String password = "MSEGUI";
    // setup connection
    public static void main(String[] args){
        // > java Phase3 <username> <password>
        if(args.length < 2){
            System.out.println("Insufficient arguments\nFormat:\n\tjava programName <username> <password> [option]");
            return;
        }
        String username = args[0];
        String password = args[1];
        String option;
        // option 0
        if(args.length == 2){
            printOptions();
            return;
        } else{
           option = args[2];
        }

        System.out.println("------------Oracle JDBC Connection Testing------------");
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e){
            System.out.println("Where is your Oracle JDBC Driver?");
            e.printStackTrace();
            return;
        }

        System.out.println("Oracle JDBC Driver Registered!");

        try(Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", username, password)){
            switch (option){
                case "1":
                    reportPatients(connection);
                    break;
                case "2":
                    reportDoctor(connection);
                    break;
                case "3":
                    reportAdmissions(connection);
                    break;
                case "4":
                    updatePayment(connection);
                    break;
                default:
                    System.out.println("Invalid option");
                    connection.close();
            }
        } catch (SQLException e){
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        }
        System.out.println("\nOracle JDBC Driver Connected!");
    }
    // 0.
    public static void printOptions(){
        System.out.println("1 - Report Patients Basic Information");
        System.out.println("2 - Report Doctors Basic Information");
        System.out.println("3 - Report Admissions Information");
        System.out.println("4 - Update Admissions Payment");
    }

    // 1 - Report Patients Basic Information
    public static void reportPatients(Connection connection){
        Scanner scan = new Scanner(System.in);

        System.out.println("Enter Patient SSN: ");
        String ssn = scan.nextLine();
        String sql = "SELECT SSN, firstName, lastName, address FROM Patient WHERE SSN = ?";
        try(PreparedStatement stmt = connection.prepareStatement(sql)){
            stmt.setString(1, ssn);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                System.out.println("Patient SSN: " + rs.getString("SSN"));
                System.out.println("Patient First Name: " + rs.getString("firstName"));
                System.out.println("Patient Last Name: " + rs.getString("lastName"));
                System.out.println("Patient Address: " + rs.getString("address"));
            } else{
                System.out.println("Patient Not Found.");
            }
            rs.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    // 2 - Report Doctors Basic Information
    public static void reportDoctor(Connection connection){
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter Doctor ID: ");
        String doctorID = scan.nextLine();
        String sql = "SELECT d.employeeID, e.firstName, e.lastName, d.gender, d.graduatedFrom, d.specialty " +
                     "FROM Doctor d JOIN Employee e ON d.employeeID = e.employeeID " +
                     "WHERE d.employeeID = ?";

        try(PreparedStatement stmt = connection.prepareStatement(sql)){
            stmt.setString(1, doctorID);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                System.out.println("Doctor ID: " + rs.getString("employeeID"));
                System.out.println("Doctor First Name: " + rs.getString("firstName"));
                System.out.println("Doctor Last Name: " + rs.getString("lastName"));
                System.out.println("Doctor Gender: " + rs.getString("gender"));
                System.out.println("Doctor Graduated From: " + rs.getString("graduatedFrom"));
                System.out.println("Doctor Specialty: " + rs.getString("specialty"));
            } else{
                System.out.println("Doctor Not Found.");
            }
            rs.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    // 3 - Report Admissions Information
    public static void reportAdmissions(Connection connection){
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter Admission Number: ");
        int admissionNum = scan.nextInt();
        // admission data
        String admisionSQL = "SELECT admissionNum, SSN, admissionDate, totalPayment " +
                             "FROM Admission " +
                             "WHERE admissionNum = ?";
        try(PreparedStatement stmt = connection.prepareStatement(admisionSQL)){
            stmt.setInt(1, admissionNum);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                System.out.println("Admission Num: " + rs.getString("admissionNum"));
                System.out.println("Patient SSN: " + rs.getString("SSN"));
                System.out.println("Admission date (start date): " + rs.getString("admissionDate"));
                System.out.println("Total Payment: " + rs.getString("totalPayment"));
            } else{
                System.out.println("Admission Number Invalid.");
            }
            rs.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
        // rooms data
        String roomSQL = "SELECT roomNum, startDate, endDate " +
                         "FROM StayIn " +
                         "WHERE admissionNum = ?";
        System.out.println("Rooms:");
        try(PreparedStatement stmt = connection.prepareStatement(roomSQL)){
            stmt.setInt(1, admissionNum);
            ResultSet rs2 = stmt.executeQuery();

            while(rs2.next()){
                System.out.println("RoomNum: " + rs2.getString("roomNum") +
                                    " FromDate: " + rs2.getString("startDate") +
                                    " ToDate: " + rs2.getString("endDate"));
            }
            rs2.close();
            stmt.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
        // doctor data
        String doctorSQL = "SELECT doctorID FROM Examine WHERE AdmissionNum = ?";
        System.out.println("Doctors examined the patient in this admission:");
        try(PreparedStatement stmt = connection.prepareStatement(doctorSQL)){
            stmt.setInt(1, admissionNum);
            ResultSet rs3 = stmt.executeQuery();

            while(rs3.next()){
                System.out.println("Doctor ID: " + rs3.getString("doctorID"));
            }
            rs3.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
    // 4 - Update Admissions Payment
    public static void updatePayment(Connection connection){
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter Admission Number: ");
        int admissionNum = scan.nextInt();

        System.out.println("Enter the new total payment: ");
        double totalPayment = scan.nextDouble();

        String updateSQL = "UPDATE Admission SET totalPayment = ? WHERE admissionNum = ?";
        try(PreparedStatement stmt = connection.prepareStatement(updateSQL)){
            stmt.setDouble(1, totalPayment);
            stmt.setInt(2, admissionNum);
            int count = stmt.executeUpdate();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
}

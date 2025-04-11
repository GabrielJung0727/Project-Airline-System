import Foundation
import SQLite3  // Using SQLite3 directly

class DatabaseService {
    static let shared = DatabaseService()
    
    private var db: OpaquePointer?  // SQLite3 database pointer
    private var loggedInUserID: String = "" // Currently logged-in user ID storage

    init() {
        setupDatabase()  // Initialize the database when the service is created
    }
    
    // MARK: - Database Setup
    
    // Creates/opens the database file and initializes tables
    private func setupDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbPath = documentDirectory.appendingPathComponent("ProjectAirplane.sqlite").path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("✅ SQLite3 DB connected successfully: \(dbPath)")
                createTables()  // Create all tables
                
                // Check if an admin exists; if not, insert a default admin
                let checkQuery = "SELECT COUNT(*) FROM users WHERE id = 'admin';"
                var statement: OpaquePointer?
                if sqlite3_prepare_v2(db, checkQuery, -1, &statement, nil) == SQLITE_OK {
                    if sqlite3_step(statement) == SQLITE_ROW {
                        let count = sqlite3_column_int(statement, 0)
                        if count == 0 {
                            // Insert default admin
                            let insertQuery = "INSERT INTO users (id, name, role, password) VALUES ('admin', 'Administrator', 'admin', 'admin1234');"
                            _ = executeInsertQuery(insertQuery, values: [])
                        }
                    }
                }
                sqlite3_finalize(statement)
                
            } else {
                print("❌ Failed to connect to SQLite3 DB")
            }
        } catch {
            print("❌ SQLite3 DB setup error: \(error.localizedDescription)")
        }
    }
    
    // Creates required tables if they do not exist
    private func createTables() {
        let usersTableQuery = """
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            name TEXT,
            role TEXT,  -- 'crew', 'pilot', 'admin', etc.
            password TEXT
        );
        """
        
        let flightsTableQuery = """
        CREATE TABLE IF NOT EXISTS flights (
            id TEXT PRIMARY KEY,
            flightNumber TEXT,
            departure TEXT,
            destination TEXT,
            departureTime REAL,
            arrivalTime REAL
        );
        """
        
        let passengersTableQuery = """
        CREATE TABLE IF NOT EXISTS passengers (
            id TEXT PRIMARY KEY,
            name TEXT,
            seatNumber TEXT,
            flightNumber TEXT
        );
        """
        
        let logsTableQuery = """
        CREATE TABLE IF NOT EXISTS logs (
            id TEXT PRIMARY KEY,
            userID TEXT,
            action TEXT,
            timestamp TEXT
        );
        """
        
        executeQuery(usersTableQuery, values: [])
        executeQuery(flightsTableQuery, values: [])
        executeQuery(passengersTableQuery, values: [])
        executeQuery(logsTableQuery, values: [])
    }
    
    // MARK: - User Management Functions
    
    // Save the logged-in user ID
    func setLoggedInUserID(_ userID: String) {
        self.loggedInUserID = userID
    }

    // Login: returns a tuple (role, username) if successful
    func loginUser(userID: String, password: String) -> (String, String)? {
        let query = "SELECT role, name FROM users WHERE id = ? AND password = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, userID, -1, nil)
            sqlite3_bind_text(statement, 2, password, -1, nil)
            if sqlite3_step(statement) == SQLITE_ROW {
                let role = String(cString: sqlite3_column_text(statement, 0))
                let username = String(cString: sqlite3_column_text(statement, 1))
                sqlite3_finalize(statement)
                setLoggedInUserID(userID) // Save the user ID upon successful login
                return (role, username)
            }
        }
        
        sqlite3_finalize(statement)
        return nil // Login failed
    }

    // Get the role of the currently logged-in user
    func getCurrentUserRole() -> String {
        guard !loggedInUserID.isEmpty else { return "default" }  // Return default if not logged in
        let query = "SELECT role FROM users WHERE id = ?;"
        var statement: OpaquePointer?
        var role: String = "default"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, loggedInUserID, -1, nil)
            if sqlite3_step(statement) == SQLITE_ROW {
                role = String(cString: sqlite3_column_text(statement, 0))
            }
        }
        
        sqlite3_finalize(statement)
        return role
    }
    
    // MARK: - Crew and Pilot Management
    
    // Add a crew member (only admin can add)
    func addCrewMember(name: String, id: String) -> Bool {
        guard getCurrentUserRole() == "admin" else {
            print("❌ Admin privileges required.")
            return false
        }
        
        let query = "INSERT INTO users (id, name, role) VALUES (?, ?, 'crew');"
        return executeInsertQuery(query, values: [id, name])
    }

    // Add a pilot (only admin can add)
    func addPilot(name: String, id: String) -> Bool {
        guard getCurrentUserRole() == "admin" else {
            print("❌ Admin privileges required.")
            return false
        }
        
        let query = "INSERT INTO users (id, name, role) VALUES (?, ?, 'pilot');"
        return executeInsertQuery(query, values: [id, name])
    }

    // Delete a crew member (only admin)
    func deleteCrewMember(id: String) {
        guard getCurrentUserRole() == "admin" else {
            print("❌ Admin privileges required.")
            return
        }

        let query = "DELETE FROM users WHERE id = ? AND role = 'crew';"
        executeQuery(query, values: [id])
    }

    // Delete a pilot (only admin)
    func deletePilot(id: String) {
        guard getCurrentUserRole() == "admin" else {
            print("❌ Admin privileges required.")
            return
        }

        let query = "DELETE FROM users WHERE id = ? AND role = 'pilot';"
        executeQuery(query, values: [id])
    }
    
    func fetchCrewMembers() -> [CrewModel] {
        let query = "SELECT id, name FROM users WHERE role = 'crew';"
        var crewList: [CrewModel] = []
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                crewList.append(CrewModel(id: id, name: name))
            }
        } else {
            print("❌ Crew members fetch failed")
        }
        sqlite3_finalize(statement)
        return crewList
    }
    
    func fetchPilots() -> [PilotModel] {
        let query = "SELECT id, name FROM users WHERE role = 'pilot';"
        var pilotList: [PilotModel] = []
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                pilotList.append(PilotModel(id: id, name: name))
            }
        } else {
            print("❌ Failed to prepare pilot query")
        }
        sqlite3_finalize(statement)
        return pilotList
    }
    
    func fetchLogs() -> [LogModel] {
        let query = "SELECT id, userID, action, timestamp FROM logs ORDER BY timestamp DESC;"
        var logs: [LogModel] = []
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let userID = String(cString: sqlite3_column_text(statement, 1))
                let action = String(cString: sqlite3_column_text(statement, 2))
                let timestamp = String(cString: sqlite3_column_text(statement, 3))
                logs.append(LogModel(id: id, userID: userID, action: action, timestamp: timestamp))
            }
        } else {
            print("❌ Failed to prepare logs query")
        }
        sqlite3_finalize(statement)
        return logs
    }
    // MARK: - Flight and Passenger Functions
    
    // Add flight (admin only)
    func addFlight(flightNumber: String, departure: String, destination: String, adminPassword: String) -> Bool {
        // Check admin password (example: "admin1234")
        guard adminPassword == "admin1234" else {
            print("❌ Admin privileges required.")
            return false
        }
        
        let fullFlightNumber = "KE\(flightNumber)"  // Prefix flight number with "KE"
        let flightId = UUID().uuidString
        let query = "INSERT INTO flights (id, flightNumber, departure, destination) VALUES (?, ?, ?, ?);"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, flightId, -1, nil)
            sqlite3_bind_text(statement, 2, fullFlightNumber, -1, nil)
            sqlite3_bind_text(statement, 3, departure, -1, nil)
            sqlite3_bind_text(statement, 4, destination, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("✅ Flight added successfully: \(fullFlightNumber)")
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        print("❌ Flight addition failed")
        return false
    }
    
    // Fetch flights
    func fetchFlights() -> [FlightModel] {
        let query = "SELECT * FROM flights;"
        var statement: OpaquePointer?
        var flightList: [FlightModel] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let flightNumber = String(cString: sqlite3_column_text(statement, 1))
                let departure = String(cString: sqlite3_column_text(statement, 2))
                let destination = String(cString: sqlite3_column_text(statement, 3))
                let departureTime = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
                let arrivalTime = Date(timeIntervalSince1970: sqlite3_column_double(statement, 5))
                
                let flight = FlightModel(id: id, flightNumber: flightNumber, departure: departure, destination: destination, departureTime: departureTime, arrivalTime: arrivalTime)
                flightList.append(flight)
            }
        } else {
            print("❌ Failed to fetch flights")
        }
        sqlite3_finalize(statement)
        return flightList
    }
    
    // Fetch passenger info for a given seat and flight
    func getPassengerInfo(seatNumber: String, flightNumber: String) -> PassengerModel? {
        let query = "SELECT * FROM passengers WHERE seatNumber = ? AND flightNumber = ?;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, seatNumber, -1, nil)
            sqlite3_bind_text(statement, 2, flightNumber, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let passenger = PassengerModel(
                    id: String(cString: sqlite3_column_text(statement, 0)),
                    name: String(cString: sqlite3_column_text(statement, 1)),
                    seatNumber: String(cString: sqlite3_column_text(statement, 2)),
                    flightNumber: String(cString: sqlite3_column_text(statement, 3))
                )
                sqlite3_finalize(statement)
                return passenger
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    // Log search or activity
    func logSearch(userID: String, action: String) {
        let query = "INSERT INTO logs (id, userID, action, timestamp) VALUES (?, ?, ?, datetime('now'));"
        // If you see a warning "Result of call to 'executeInsertQuery(_:values:)' is unused", you can write:
        _ = executeInsertQuery(query, values: [UUID().uuidString, userID, action])
    }
    
    // MARK: - SQL Execution Helpers
    
    // Execute an insert query and return true if successful
    private func executeInsertQuery(_ query: String, values: [String]) -> Bool {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            for (index, value) in values.enumerated() {
                sqlite3_bind_text(statement, Int32(index + 1), value, -1, nil)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }

    // Execute a query (for updates or deletes)
    private func executeQuery(_ query: String, values: [String]) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            for (index, value) in values.enumerated() {
                sqlite3_bind_text(statement, Int32(index + 1), value, -1, nil)
            }
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - SQLite Connection Management
    
    // Close the SQLite database connection when the instance is deallocated
    deinit {
        sqlite3_close(db)
    }
}

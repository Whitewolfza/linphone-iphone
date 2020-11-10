//
//  NonQuery.swift
//  ZenComms
//
//  Created by Clevercom Developers on 2020/10/05.
//  Copyright © 2020 Clevercom. All rights reserved.
//

import PostgresClientKit
import Foundation

public class NonQuery{
    
    
    
    var host:String = "41.76.213.244"
    var port:Int = 25383
    var ssl:Bool = false
    var database:String = "zencomms"
    var user:String = "CleverFinUser"
    var password:String = "F!nu53r%*33@$*24"
    var connectionPool:ConnectionPool
//    var connection:Connection
//    var statement:Statement
    var Params:[PostgresValueConvertible]
    var sStatement:String
    var sCommand:String
    var outParams:[PostgresValueConvertible]
    
    
    //MARK: INIT
    
    internal init(command: String,paramcount:Int) throws {
        
        // Configure a connection pool with, at most, a single connection.  Using a connection pool
                // allows the connection to be lazily created, automatically re-creates the connection if
                // there is an unrecoverable error, and performs database operations on a background thread.
                var connectionPoolConfiguration = ConnectionPoolConfiguration()
                connectionPoolConfiguration.maximumConnections = 1
                
                // Configure how connections are created in that connection pool.
                var connectionConfiguration = ConnectionConfiguration()
                connectionConfiguration.host = host
                connectionConfiguration.port = port
                connectionConfiguration.ssl = ssl
                connectionConfiguration.database = database
                connectionConfiguration.user = user
                connectionConfiguration.credential = .md5Password(password: password)
                
                connectionPool = ConnectionPool(connectionPoolConfiguration: connectionPoolConfiguration,
                                                connectionConfiguration: connectionConfiguration)
        
        Params = [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        outParams =  [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        sCommand = command
        sStatement="";
        
    
    }
    
    internal init(command: String,conns:String,paramcount:Int) throws {
        // Configure a connection pool with, at most, a single connection.  Using a connection pool
        // allows the connection to be lazily created, automatically re-creates the connection if
        // there is an unrecoverable error, and performs database operations on a background thread.
        var connectionPoolConfiguration = ConnectionPoolConfiguration()
        connectionPoolConfiguration.maximumConnections = 1
        
        
        //Split ConnString
        
        // Configure how connections are created in that connection pool.
        var connectionConfiguration = ConnectionConfiguration()
        connectionConfiguration.host = host
        connectionConfiguration.port = port
        connectionConfiguration.ssl = ssl
        connectionConfiguration.database = database
        connectionConfiguration.user = user
        connectionConfiguration.credential = .md5Password(password: password)
        
        connectionPool = ConnectionPool(connectionPoolConfiguration: connectionPoolConfiguration,
                                        connectionConfiguration: connectionConfiguration)
        
        
        
        
        Params = [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        outParams =  [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        sCommand = command
        sStatement="";
        
    }
    
    internal init(command: String,conns:String,un:String,pass:String,paramcount:Int) throws {
        // Configure a connection pool with, at most, a single connection.  Using a connection pool
                // allows the connection to be lazily created, automatically re-creates the connection if
                // there is an unrecoverable error, and performs database operations on a background thread.
                var connectionPoolConfiguration = ConnectionPoolConfiguration()
                connectionPoolConfiguration.maximumConnections = 1
                
                // Configure how connections are created in that connection pool.
                var connectionConfiguration = ConnectionConfiguration()
                connectionConfiguration.host = host
                connectionConfiguration.port = port
                connectionConfiguration.ssl = ssl
                connectionConfiguration.database = database
                connectionConfiguration.user = user
                connectionConfiguration.credential = .md5Password(password: password)
                
                connectionPool = ConnectionPool(connectionPoolConfiguration: connectionPoolConfiguration,
                                                connectionConfiguration: connectionConfiguration)
        
        
        
        Params = [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        outParams =  [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        
        sCommand = command
        sStatement="";
    }
    
    
    
    //MARK: Strings
    
    func AddVarchar(position:Int,Length:Int,FieldValue:String)
    {
        Params[position] = FieldValue
    }
    
    func AddVarchar(position:Int,FieldValue:String)
    {
        Params[position] = FieldValue
    }
    
    func AddVarchar(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    func AddVarchar(position:Int,Length:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    
    func AddVarcharAsNull(position:Int,Length:Int)
    {
        Params[position] = PostgresValue.init(nil)
    }
    
    func AddXML(position:Int,FieldValue:String)
    {
        Params[position] = FieldValue
    }
    
    func AddXML(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    
    //MARK: Boolean
    func AddBoolean(position:Int,FieldValue:Bool)
    {
        Params[position] = FieldValue
    }
    
    func AddBoolean(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    //MARK: Decimal
    
    func AddDecimal(position:Int,FieldValue:Decimal)
    {
        Params[position] = FieldValue
    }
    
    func AddDecimal(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    
    //MARK: Int
    
    func AddInt(position:Int,FieldValue:Int)
    {
        Params[position] = FieldValue
    }
    
    func AddInt(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    //MARK: Date
    
    func AddDate(position:Int,FieldValue:Date)
    {
        let dt:PostgresTimestamp = PostgresTimestamp.init(date:FieldValue, in:TimeZone.current)
        
        Params[position] = dt
    }
    
    func AddDate(position:Int)
    {
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
    
    
    //MARK: DataTables
    /*
    func AddInt(position:Int,FieldValue:DataTable)
    {
        Params[position] = FieldValue
    }
    
    func AddInt(position:Int)
    {
         if self.outParams.count<position
         {
             while self.outParams.count<position {
                 outParams.append(PostgresValue.init(nil))
             }
         }
        outParams[position] = PostgresValue.init(nil)
        Params.remove(at: position)
    }
       */
        
    func Execute(completion: @escaping (Result<Bool,Error>)->Void)  {
        
        var params:String = ""
        for i in 0...self.Params.count-1
        {
            params += "$"+String(i+1)+","
        }
        
        params = String(params.dropLast())

         sStatement = "Select * from "+sCommand+"("+params+")"
        
        
        
        connectionPool.withConnection { connectionResult in
                    
                    let result = Result<Bool, Error> {
                        
                        let connection = try connectionResult.get()
                        
                        
                        let statement = try connection.prepareStatement(text: self.sStatement)
                        defer { statement.close() }
                        
                        let cursor = try statement.execute(parameterValues: self.Params,retrieveColumnMetadata: true)
                        defer { cursor.close() }
                        
                        //let Tcolums:[ColumnMetadata]? = cursor.columns
                        
                        for row in cursor {
                            let columns = try row.get().columns
                            for i:Int  in 0...columns.count-1 {
                                self.outParams[i+self.Params.count] = columns[i].postgresValue
                            }
                        } 
                        
                        return true
                    }
                    
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                }
    
    
    //MARK: ReturnData

    func ValueAsString(position:Int)throws->String
    {
        return try outParams[position].postgresValue.string()
    }
    
    func ValueAsXML(position:Int)throws->String
    {
        return try outParams[position].postgresValue.string()
    }
    
    func ValueAsBool(position:Int)throws->Bool
    {
        return try outParams[position].postgresValue.bool()
    }
    
    func ValueAsDouble(position:Int)throws->Double
    {
        return try outParams[position].postgresValue.double()
    }
    
    func ValueAsFloat(position:Int)throws->Double
    {
        return try outParams[position].postgresValue.double()
    }
    
    func ValueAsDecimal(position:Int)throws->Decimal
    {
        return try outParams[position].postgresValue.decimal()
    }
    
    func ValueAsInterger(position:Int)throws->Int
    {
        return try outParams[position].postgresValue.int()
    }

    func ValueAsLong(position:Int)throws->Int
    {
        return try outParams[position].postgresValue.int()
    }
    
    func ValueAsDateTime(position:Int)throws->Date?
    {
        return try outParams[position].postgresValue.timestamp().dateComponents.date
    }
}

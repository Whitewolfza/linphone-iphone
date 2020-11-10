//
//  Query.swift
//  ZenComms
//
//  Created by Clevercom Developers on 2020/10/06.
//  Copyright © 2020 Clevercom. All rights reserved.
//

import PostgresClientKit
import Foundation
public class Query{
    
    
    
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
    
    
    //MARK: INIT
    
    internal init(command: NSString,paramcount:Int) throws {
        
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
        
        var params:String = ""
        
        
        Params = [PostgresValueConvertible](repeating: PostgresValue.init(nil), count: paramcount)
        Params.reserveCapacity(paramcount)
        
        for i in 0...paramcount-1
        {
            params += "$"+String(i+1)+","
        }
        
        params = String(params.dropLast())

        sStatement = "Select * from "+(command as String)+"("+params+")"
        
    
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
    
    func AddVarcharAsNull(position:Int,Length:Int)
    {
        Params[position] = PostgresValue.init(nil)
    }
    
    func AddXML(position:Int,FieldValue:String)
    {
        Params[position] = FieldValue
    }
    
    //MARK: Boolean
    func AddBoolean(position:Int,FieldValue:Bool)
    {
        Params[position] = FieldValue
    }
    
    //MARK: Decimal
    
    func AddDecimal(position:Int,FieldValue:Decimal)
    {
        Params[position] = FieldValue
    }
    
    
    //MARK: Int
    
    func AddInt(position:Int,FieldValue:Int)
    {
        Params[position] = FieldValue
    }
    
    //MARK: Date
    
    func AddDate(position:Int,FieldValue:Date)
    {
        let dt:PostgresTimestamp = PostgresTimestamp.init(date:FieldValue, in:TimeZone.current)
        
        Params[position] = dt
    }
    
    
    //MARK: DataTables
    /*
    func AddInt(position:Int,FieldValue:DataTable)
    {
        Params[position] = FieldValue
    }
       */
        
    func ExecData(completion: @escaping (Result<Cursor,Error>)->Void)  {
        connectionPool.withConnection { connectionResult in
                    
                    let result = Result<Cursor, Error> {
                        
                        let connection = try connectionResult.get()
                        
                        
                        let statement = try connection.prepareStatement(text: self.sStatement)
                        //defer { statement.close() }
                        
                        let cursor = try statement.execute(parameterValues: self.Params,retrieveColumnMetadata: true)
                        //defer { cursor.close() }
                        
                        
                        
                        
                        
                        
                        return cursor
                    }
                    
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                }
    
    
    
}




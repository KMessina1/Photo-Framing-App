/*--------------------------------------------------------------------------------------------------------------------------
   File: SQLite.swift
 Author: Kevin Messina
Created: June 7, 2017

©2017-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
        Requires GRDB Cocoa pod: https://github.com/groue/GRDB.swift
        GRDB Helper Documentation: https://github.com/groue/GRDB.swift#records
--------------------------------------------------------------------------------------------------------------------------*/

import GRDB

extension Row {
    /** CAS: Returns tuple of GRDB SQLite Database's Row data in [String:AnyObject] format.

     * Version: 1.0
     * Author: Creative App Solutions

     - Example: let dict = try Row.fetchAll(db, CalibersAndGauges.all()).map { $0.asDictionary }
     
     - Requires: GRDB Sqlite
     - Returns: [String:AnyObject] Dictionary of Row data.
    **/
    var asDictionary:[String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        
        for (column, dbValue) in self {
            dict[column] = dbValue.storage.value as AnyObject
        }

        return dict
    }
}

class SQL {
//    func convertDBClassToArrayOfDictionaries(_ dbClassArray:[Record]) -> [[String:AnyObject]] {
//        let records:[[String:AnyObject]] = []
//
//        for itemRecord:Record in dbClassArray {
//            let dict = itemRecord.persistentDictionary as [String:AnyObject]
//
//            records.append(dict)
//        }
//
//        return records
//    }
    
    func get(
        _ dbQueue:DatabaseQueue,
        select:String? = "",
        table:String,
        where whereCondition:String? = "",
        orderBy:String? = ""
    ) throws -> [Row] {
        var records:[Row] = []
        
        var query = ""
            query += (select!.isEmpty) ?"SELECT * FROM \(table)" :"SELECT \(select!) FROM \(table)"
            query += (whereCondition!.isEmpty) ?"" :" WHERE \(whereCondition!)"
            query += (orderBy!.isEmpty) ?"" :" ORDER BY \(orderBy!)"
            query += ";"
        
        do {
            try dbQueue.inDatabase { db in
                records = try Row.fetchAll(db, sql: query)
            }
        } catch {
            if isSim { print("SQL ERROR on Fetch: \(query)") }
        }
        
        return records
    }
    
    @discardableResult func update(
        _ dbQueue:DatabaseQueue,
        table:String,
        fieldsAndVals:Dictionary<String,AnyObject>,
        where whereCondition:String? = ""
    ) throws -> Bool {
        var fields:String = ""
        var count = 0
        for item in fieldsAndVals {
            fields += "\(item.0)='\(item.1)'"
            
            count += 1
            if count < fieldsAndVals.count {
                fields += ","
            }
        }
        
        var query = "UPDATE \(table) SET \(fields)"
        
        if whereCondition!.isEmpty {
            query += ";"
        }else{
            query += " WHERE \(whereCondition!);"
        }
        
        do {
            try dbQueue.inDatabase { db in
                try db.execute(sql: query)
            }
            
            return true
        } catch {
            if isSim { print("SQL ERROR on Update: \(query)") }
            return false
        }
    }
    
    @discardableResult func delete(
        _ dbQueue:DatabaseQueue,
        table:String,
        where whereCondition:String? = ""
    ) throws ->Bool {
        var query = "DELETE FROM \(table)"
        
        if whereCondition!.isEmpty {
            query += ";"
        }else{
            query += " WHERE \(whereCondition!);"
        }
        
        do {
            try dbQueue.inDatabase { db in
                try db.execute(sql: query)
            }
            
            return true
        } catch {
            if isSim { print("SQL ERROR on Delete: \(query)") }
            return false
        }
    }
    
    @discardableResult func insert(_ dbQueue:DatabaseQueue,table:String,values:String) throws -> Bool {
        let query = "INSERT INTO \( table ) VALUES (\( values ));"
        
        do {
            try dbQueue.inDatabase { db in
                try db.execute(sql: query)
            }
            
            return true
        } catch {
            if isSim { print("SQL ERROR on Insert: \(query)") }
            return false
        }
    }
}


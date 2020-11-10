//
//  cleverframework-Swift.h
//  cleverframework
//
//  Created by Clevercom Developers on 2020/10/29.
//
#import <Foundation/Foundation.h>
@class Query;
// MyObjcClass.h
@class Query;
@protocol QueryProtocol;

@interface Query : NSObject
//Query * obj = [[Query alloc] init];
- (Query *)returnSwiftClassInstance;
- (id <QueryProtocol>)returnInstanceAdoptingSwiftProtocol;




//@objc(Query:query)
//static func init(command: String, paramcount: int,Query:query) {
//
//}
//+ (Query *)init:(NSString) command ;



//@property (strong, nonatomic) id host;
//public var testProperty: Any = "Some Initializer Val"






//var host:String = "41.76.213.244"
//var port:Int = 25383
//var ssl:Bool = false
//var database:String = "zencomms"
//var user:String = "CleverFinUser"
//var password:String = "F!nu53r%*33@$*24"
//var connectionPool:ConnectionPool
////    var connection:Connection
////    var statement:Statement
//var Params:[PostgresValueConvertible]
//var sStatement:String


//- (void) init(string command,paramcount:Int);
// ...
@end

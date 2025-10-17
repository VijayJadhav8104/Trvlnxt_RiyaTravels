
       
 --exec sp_Get_Cruise_Flat 7      
 CREATE PROCEDURE [Cruise].[sp_Get_Cruise_Cancellation]          
 @Id varchar(20)=Null      
 AS       
 BEGIN      
      
  SELECT *      
  FROM [Cruise].tblCruise_Cancellation WHERE Pkid=@Id      
      
 END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_Get_Cruise_Cancellation] TO [rt_read]
    AS [DB_TEST];


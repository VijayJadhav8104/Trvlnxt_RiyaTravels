 CREATE PROCEDURE [SS].[sp_Get_Cancellation]            
 @Id varchar(20)=Null        
 AS         
 BEGIN        
        
  SELECT *        
  FROM [SS].tbl_Cancellation WHERE Pkid=@Id        
        
 END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_Get_Cancellation] TO [rt_read]
    AS [DB_TEST];


         
 --exec sp_Get_Cruise_Flat 7        
 CREATE PROCEDURE ER.[sp_Get_Cancellation]            
 @Id varchar(20)=Null        
 AS         
 BEGIN        
        
  SELECT *        
  FROM [ER].[tbl_Cancellation] WHERE Pkid=@Id        
        
 END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[ER].[sp_Get_Cancellation] TO [rt_read]
    AS [RiyaTravels];


       
 --exec sp_Get_Cruise_Flat 7      
 CREATE PROCEDURE [Rail].[sp_Get_Cancellation]          
 @Id varchar(20)=Null      
 AS       
 BEGIN      
      
  SELECT *      
  FROM [Rail].[tbl_Cancellation] WHERE Pkid=@Id      
      
 END 

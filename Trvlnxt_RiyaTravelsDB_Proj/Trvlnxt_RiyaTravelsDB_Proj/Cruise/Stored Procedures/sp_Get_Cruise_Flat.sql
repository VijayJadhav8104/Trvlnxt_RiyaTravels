   
 --exec sp_Get_Cruise_Flat 7  
 CREATE PROCEDURE [Cruise].[sp_Get_Cruise_Flat]      
 @Id varchar(20)=Null  
 AS   
 BEGIN  
  
  SELECT *  
  FROM tbl_Cruise_Flat WHERE Id=@Id  
  
 END  

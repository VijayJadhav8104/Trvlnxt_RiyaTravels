
           
      
-- =============================================      
-- Author:  <sana>      
-- Create date: <18-May-2022>      
-- Description: <updates IsActive status>      
-- =============================================      
CREATE PROCEDURE [Cruise].[sp_ActiveStatus_Discount]    
@id int=null,      
@flag varchar(20)=null      
AS      
BEGIN      
 if(@flag='Active')      
 begin      
  update cruise.tbl_Cruise_Discount set isActive=1 where Id=@id      
 end      
      
 else if(@flag='Deactive')      
 begin      
  update cruise.tbl_Cruise_Discount set isActive=0 where Id=@id      
 end      
      
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_ActiveStatus_Discount] TO [rt_read]
    AS [DB_TEST];


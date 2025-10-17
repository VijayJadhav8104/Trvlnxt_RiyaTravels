  
-- =============================================  
-- Author:  <sana>  
-- Create date: <18-May-2022>  
-- Description: <updates IsActive status>  
-- =============================================  
CREATE PROCEDURE [Cruise].[sp_ActiveStatus_Flat]
@id int=null,  
@flag varchar(20)=null  
AS  
BEGIN  
 if(@flag='Active')  
 begin  
  update tbl_Cruise_Flat set isActive=1 where Id=@id  
 end  
  
 else if(@flag='Deactive')  
 begin  
  update tbl_Cruise_Flat set isActive=0 where Id=@id  
 end  
  
END  
  

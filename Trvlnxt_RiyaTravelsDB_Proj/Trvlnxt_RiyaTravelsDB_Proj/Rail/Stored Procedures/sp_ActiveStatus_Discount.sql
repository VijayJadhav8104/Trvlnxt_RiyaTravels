      
-- =============================================      
-- Author:  <sana>      
-- Create date: <18-May-2022>      
-- Description: <updates IsActive status>      
-- =============================================      
CREATE PROCEDURE [Rail].[sp_ActiveStatus_Discount]    
@id int=null,      
@flag varchar(20)=null      
AS      
BEGIN      
 if(@flag='Active')      
 begin      
  update [Rail].[tbl_Discount] set isActive=1 where Id=@id      
 end      
      
 else if(@flag='Deactive')      
 begin      
  update [Rail].[tbl_Discount] set isActive=0 where Id=@id      
 end      
      
END 

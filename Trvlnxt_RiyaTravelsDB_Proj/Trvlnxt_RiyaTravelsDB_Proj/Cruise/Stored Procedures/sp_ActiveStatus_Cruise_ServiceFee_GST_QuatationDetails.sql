
CREATE PROCEDURE [Cruise].[sp_ActiveStatus_Cruise_ServiceFee_GST_QuatationDetails]  
@id int=null,  
@flag varchar(20)=null  
AS  
BEGIN  
 if(@flag='Active')  
 begin  
  update [Cruise].tbl_Cruise_ServiceFee_GST_QuatationDetails set isActive=1 where Id=@id  
 end  
  
 else if(@flag='Deactive')  
 begin  
  update [Cruise].tbl_Cruise_ServiceFee_GST_QuatationDetails set isActive=0 where Id=@id  
 end  
  
END  
  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_ActiveStatus_Cruise_ServiceFee_GST_QuatationDetails] TO [rt_read]
    AS [DB_TEST];


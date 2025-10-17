
--===============================================
--Created By : Nitish Kahar
--Created Date: 02-June-2022
--Description : To get Agent Service fee details from Console API 
--Cruise.Get_Crusie_SFGST 51476 
--===============================================
  
CREATE PROCEDURE [Cruise].[sp_ActiveStatus_Cancellation]    
@id int=null,      
@flag varchar(20)=null      
AS      
BEGIN      
 if(@flag='Active')      
 begin      
  update [Cruise].tblCruise_Cancellation set isActive=1 where Pkid=@id      
 end      
      
 else if(@flag='Deactive')      
 begin      
  update [Cruise].tblCruise_Cancellation set isActive=0 where Pkid=@id      
 end      
      
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_ActiveStatus_Cancellation] TO [rt_read]
    AS [DB_TEST];


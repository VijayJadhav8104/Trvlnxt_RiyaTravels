-- =============================================              
-- Author:  <Amol Chaudhari>              
-- Create date: <11/06/2024>              
-- Description: To get Holiday Agency where country other than india          
-- [Hotel.GetHotelAiutoCompleteAgentList] 'Riya','India','4' 

-- =============================================           
 CREATE PROCEDURE Rail.GetAutoCompleteAgentList 
 --'MARHABA TRAVEL','AE','2'                 
  @AgencyName varchar(200)='',         
  @Country varchar(200)='',        
  @UserType int         
AS              
BEGIN         
  select top 10 BR.Pkid as 'FKUserID', AgencyName,
Al.userid as PKID,
(case WHEN Al.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + BR.AddrCity,'')as 'DisplayName',            
    Al.UserName,
	br.Icast  as Icast,
	Al.UserTypeID             
    ,ISNULL(NM.Code,0) as 'AgentNationality'            
    ,ISNULL(NM.Nationality,'') as 'AgentNationalityText',            
    Al.BookingCountry as 'AgentCountry',            
    Al.Country as 'AgentCountryText',    
    ISNULL(Al.GroupId,0)  as GroupId  
from B2BRegistration BR     
  left join agentLogin Al on br.FKUserID=al.UserID 
  left join Hotel_Nationality_Master NM on Al.BookingCountry=NM.ISOCode            
  left join mCommon mc on al.userTypeID=mc.ID and Category='UserType'    
   where     
      al.BookingCountry=@Country       
   and al.userTypeID=@UserType     
   and BR.Icast+'-'+BR.AgencyName  like '%'+@AgencyName+'%'      
           
End        
        
      
--===============================================      
--Created By : Nitish/Akash
--Created Date: 02-June-2022      
--Description : To get Agent Service fee details from Console API       
--ss.Get_SightSeeing_SFGST 51354       
--===============================================      
CREATE PROC [SS].[Get_SightSeeing_SFGST]        
@AgencyID bigint = null        
AS        
BEGIN        
  Declare @MarkentPoint varchar(5)        
  Declare @UserType int        
  Declare @isExist_ int      
  Set @MarkentPoint = (Select BookingCountry from AgentLogin where UserID=@AgencyID)        
  Set @UserType = (Select UserTypeID from AgentLogin where UserID=@AgencyID)       
  Set @isExist_ =(Select COUNT(Id) from [RiyaTravels].[ss].[tbl_Service_AgentMapping] where AgentId=@AgencyID)        
        
SELECT  
  SFGST.Id ,  
  SFGST.MarketPoint ,  
  SFGST.TravelValidityFrom ,  
  SFGST.TravelValidityTo ,  
  SFGST.SaleValidityFrom ,  
  SFGST.SaleValidityTo ,  
  SFGST.ReservationType,  
  SFGST.TimeSlotFrom,  
  SFGST.TimeSlotTo,  
  SFGST.CommissionType ,  
  SFGST.Commission,   
  SFGST.GST , 
  SFGST.BookingType,   
  SFGST.UserType,
  mCom.Value as UserTypeValue,  
  mComCR.Value as BookingTypeValue, 
  mComCR1.Value as Currency,
  mComCR2.Value as ReservationTypeValue,

  SFGST.isActive   
 -- SFGST.CreatedDate ,  
 -- SFGST.ModifiedDate ,  
 -- SFGST.CreatedBy ,  
 -- SFGST.ModifyBy ,  
 -- SFGST.SupplierType ,  
 -- SFGST.AgentId
  from  [RiyaTravels].[ss].tbl_SS_ServiceFee SFGST    
  LEFT JOIN [RiyaTravels].[ss].tbl_Service_AgentMapping AM on SFGST.Id=AM.ServiceId 
  LEFT JOIN mCommon mCom on SFGST.UserType=mCom.ID and mCom.Category='UserType'      
  LEFT JOIN [SS].[mCommonSightSeeing] mComCR on SFGST.BookingType=mComCR.ID and mComCR.Category='BookingType' and mComCR.isActive=1 
  LEFT JOIN [SS].[mCommonSightSeeing] mComCR1 on SFGST.Currency=mComCR1.ID and mComCR1.Category='Currency' and mComCR1.isActive=1    
  LEFT JOIN [SS].[mCommonSightSeeing] mComCR2 on SFGST.ReservationType=mComCR2.ID and mComCR2.Category='ReservationType' and mComCR2.isActive=1        
   Where ((@isExist_=0 and SFGST.AgentId='all')or (@isExist_!= 0 and SFGST.Id in (Select ServiceId from [RiyaTravels].[ss].tbl_Service_AgentMapping where AgentId=@AgencyID)))   
		and SFGST.MarketPoint=@MarkentPoint  and SFGST.UserType=@UserType  and SFGST.isActive=1  and AM.AgentId=@AgencyID

	--where id in (select ServiceId from Cruise_Service_AgentMapping where AgentId=@AgencyID)        
  --where SFGST.ID IN (CASE WHEN @isExist_= 0 THEN (Select ID FROM [RiyaTravels].[ss].tbl_SS_ServiceFee SFGST   WHERE AgentId='all'       
  --    and MarketPoint=@MarkentPoint and UserType=@UserType and isActive=1)       
  --    ELSE (Select ServiceId from [RiyaTravels].[SS].tbl_Service_AgentMapping where AgentId=@AgencyID) END)      
		--and SFGST.MarketPoint=@MarkentPoint  and SFGST.UserType=@UserType  and SFGST.isActive=1  
  
END        
        

		
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[Get_SightSeeing_SFGST] TO [rt_read]
    AS [DB_TEST];


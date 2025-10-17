  
--===============================================  
--Created By : Nitish Kahar/Akash Singh  
--Created Date: 02-June-2022  
--Description : To get discount details from Console API   
--[SS].[Get_SightSeeing_DISC] 51354   
--===============================================  
  
CREATE PROC [SS].[Get_SightSeeing_DISC]    
@AgencyID bigint = null    
AS    
BEGIN    
  Declare @MarkentPoint varchar(5)    
  Declare @UserType int    
  Declare @isExist_ int  
  Set @MarkentPoint = (Select BookingCountry from AgentLogin where UserID=@AgencyID)    
  Set @UserType = (Select UserTypeID from AgentLogin where UserID=@AgencyID)   
  Set @isExist_ =(Select COUNT(Id) from [RiyaTravels].[ss].tbl_Discount_AgentMapping where AgentId=@AgencyID)  
    
    
    
  SELECT DISC.Id ,DISC.MarketPoint ,DISC.TravelValidityFrom ,DISC.TravelValidityTo ,DISC.SaleValidityFrom ,DISC.SaleValidityTo --,DISC.Origin ,DISC.Destination   
  ,DISC.GST ,DISC.isActive ,DISC.CreatedDate ,DISC.ModifiedDate ,DISC.CreatedBy ,DISC.ModifyBy ,DISC.SupplierType ,DISC.AgentId   --,DISC.ServiceType 
  ,ISNULL(DISC.TDS,0) as TDS, DISC.BookingType, DISC.UserType  
     ,mCom.Value as UserTypeValue ,mComCR.Value as BookingTypeValue ,mComCR2.Value as Currency  --,mComCR1.Value as Cabin ,mComCR3.Value as Deck ,mComCR4.Value as Room  
  from  [RiyaTravels].[ss].tbl_SS_Discount DISC 
  LEFT JOIN [RiyaTravels].[ss].tbl_Discount_AgentMapping AM on DISC.Id=AM.ServiceId  
  LEFT JOIN mCommon mCom on DISC.UserType=mCom.ID and mCom.Category='UserType'  
  LEFT JOIN [SS].[mCommonSightSeeing] mComCR on DISC.BookingType=mComCR.ID and mComCR.Category='BookingType' and mComCR.isActive=1  
  LEFT JOIN [SS].[mCommonSightSeeing] mComCR2 on DISC.Currency=mComCR2.ID and mComCR2.Category='Currency' and mComCR2.isActive=1 
  --LEFT JOIN mCommonCruise mComCR1 on DISC.Cabin=mComCR1.ID and mComCR1.Category='Cabin' and mComCR1.isActive=1  
  --LEFT JOIN mCommonCruise mComCR3 on DISC.Deck=mComCR3.ID and mComCR3.Category='Deck' and mComCR3.isActive=1     
  --LEFT JOIN mCommonCruise mComCR4 on DISC.Room=mComCR4.ID and mComCR4.Category='Rooms' and mComCR4.isActive=1  

  Where ((@isExist_=0 and DISC.AgentId='all')or (@isExist_!= 0 and DISC.Id in (Select ServiceId from [RiyaTravels].[ss].tbl_Discount_AgentMapping where AgentId=@AgencyID)))   
		and DISC.MarketPoint=@MarkentPoint  and DISC.UserType=@UserType  and DISC.isActive=1  and AM.AgentId=@AgencyID
  --where id in (select ServiceId from tbl_Cruise_Discount where AgentId=@AgencyID)    
 -- where DISC.ID IN (CASE WHEN @isExist_= 0 THEN (Select ID FROM [RiyaTravels].[ss].tbl_SS_Discount WHERE AgentId='all'   
 --     and MarketPoint=@MarkentPoint and UserType=@UserType and isActive=1)   
 --     ELSE (Select ServiceId from [RiyaTravels].[ss].tbl_Discount_AgentMapping where AgentId=@AgencyID) END)  
	--and DISC.MarketPoint=@MarkentPoint  and DISC.UserType=@UserType  and DISC.isActive=1     
END    
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[Get_SightSeeing_DISC] TO [rt_read]
    AS [DB_TEST];


CREATE PROC [Cruise].[Get_Crusie_SFGST]    
@AgencyID bigint = null    
AS    
BEGIN    
  Declare @MarkentPoint varchar(5)    
  Declare @UserType int    
  Declare @isExist_ int  
  Set @MarkentPoint = (Select BookingCountry from AgentLogin where UserID=@AgencyID)    
  Set @UserType = (Select UserTypeID from AgentLogin where UserID=@AgencyID)   
  Set @isExist_ =(Select COUNT(Id) from Cruise.Cruise_Service_AgentMapping where AgentId=@AgencyID)    
    
  SELECT   
  SFD.Id ,SFD.MarketPoint ,SFD.TravelValidityFrom ,SFD.TravelValidityTo ,  
  SFD.SaleValidityFrom ,SFD.SaleValidityTo ,  
  CASE WHEN SFD.Origin = 1 THEN 'India' ELSE SFD.Origin END AS Origin,  
  CASE WHEN SFD.Destination = 1 THEN 'India' ELSE SFD.Destination END AS Destination,  
  SFD.GST ,SFD.ServiceType ,SFD.isActive ,SFD.CreatedDate ,SFD.ModifiedDate ,  
  SFD.CreatedBy ,SFD.ModifyBy ,SFD.SupplierType ,SFD.AgentId ,  
  SFD.BookingType,SFD.CommissionType ,SFD.Commission, SFD.DiscountType, SFD.Discount,  
  SFD.ChargeType , SFD.UserType ,   
  mCom.Value as UserTypeValue ,mComCR.Value as BookingTypeValue ,      
  mComCR2.Value as Currency,  
  Cabin=STUFF((SELECT ','+ MC.Value FROM Cruise.CabinMappCrusDiscount AS CB LEFT OUTER JOIN Cruise.mCommonCruise AS MC ON CB.FK_CabinId=MC.ID    
   WHERE MC.CATEGORY='Cabin' AND CB.FK_CrusId=SFD.Id  FOR XML PATH('')),1,1,'')  
  --mComCR1.Value as Cabin ,  
  --,mComCR3.Value as Deck ,mComCR4.Value as Room  
  from  Cruise.tbl_Cruise_ServiceFee_GST_QuatationDetails SFD   
  LEFT JOIN Cruise.Cruise_Service_AgentMapping AM on SFD.Id=AM.ServiceId  
  LEFT JOIN mCommon mCom on SFD.UserType=mCom.ID and mCom.Category='UserType'  
  LEFT JOIN Cruise.mCommonCruise mComCR on SFD.BookingType=mComCR.ID and mComCR.Category='BookingType' and mComCR.isActive=1  
  LEFT JOIN Cruise.mCommonCruise mComCR2 on SFD.Currency=mComCR2.ID and mComCR2.Category='Currency' and mComCR2.isActive=1  
  --LEFT JOIN Cruise.mCommonCruise mComCR1 on SFD.Cabin in (mComCR1.ID) and mComCR1.Category='Cabin' and mComCR1.isActive=1   
  --LEFT JOIN Cruise.mCommonCruise mComCR3 on SFD.Deck=mComCR3.ID and mComCR3.Category='Deck' and mComCR3.isActive=1     
  --LEFT JOIN Cruise.mCommonCruise mComCR4 on SFD.Room=mComCR4.ID and mComCR4.Category='Rooms' and mComCR4.isActive=1   
  Where ((@isExist_=0 and SFD.AgentId='all')or (@isExist_!= 0 and SFD.Id in (Select ServiceId from Cruise.Cruise_Service_AgentMapping where AgentId=@AgencyID)))     
  and SFD.MarketPoint=@MarkentPoint  and SFD.UserType=@UserType  and SFD.isActive=1 

  -- CHECK Sarvagya
  AND ((@isExist_ = 0) or (@isExist_ != 0 and AM.AgentId=@AgencyID))
    
  --where id in (select ServiceId from Cruise_Service_AgentMapping where AgentId=@AgencyID)    
  --where SFD.ID IN (CASE WHEN @isExist_= 0 THEN (Select ID FROM tbl_Cruise_ServiceFee_GST_QuatationDetails WHERE AgentId='all'   
  --    and MarketPoint=@MarkentPoint and UserType=@UserType and isActive=1)   
  --    ELSE (Select ServiceId from Cruise_Service_AgentMapping where AgentId=@AgencyID) END)  
  --and SFD.MarketPoint=@MarkentPoint  and SFD.UserType=@UserType  and SFD.isActive=1     
END    
    
  
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[Get_Crusie_SFGST] TO [rt_read]
    AS [DB_TEST];


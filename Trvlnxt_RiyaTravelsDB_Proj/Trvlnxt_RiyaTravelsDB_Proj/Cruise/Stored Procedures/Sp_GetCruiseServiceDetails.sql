CREATE PROC [Cruise].[Sp_GetCruiseServiceDetails]      
@UserType varchar(50)=null,      
@MarketPoint varchar(50)=null      
AS      
BEGIN       
 select       
 CD.Id,AgentId,AgencyName,TravelValidityFrom,TravelValidityTo,SaleValidityTo,SaleValidityFrom,MarketPoint,GST,Commission,cd.CommissionType,Discount,cd.DiscountType
 
   
 BookingType,Deck,Room,Currency,ServiceType,CD.isActive,CreatedDate,ModifiedDate,MU.UserName as 'CreatedBy',    
 case    
 when UserType=1 then 'B2C'     
 when UserType=2 then 'B2B'     
 when UserType=3 then 'Marine'     
 when UserType=4 then 'Holiday'    
 when UserType=5 then 'RBT'     
 when UserType=1245 then 'External Client'     
 else 'NA'    
end  as 'UserType',     
    
	
	Cabin=STUFF(
	(SELECT ','+MC.Value FROM CabinMappCrusDiscount AS CA LEFT OUTER JOIN mCommonCruise AS MC ON CA.FK_CabinId=MC.ID  WHERE MC.CATEGORY='Cabin' AND CA.FK_CrusId=CD.Id  FOR XML PATH('')),1,1,''
	),

	Origin=STUFF(
	(SELECT ','+MC.Value FROM OriginMappCrusDiscount AS OP LEFT OUTER JOIN mCommonCruise AS MC ON OP.FK_OriginId=MC.ID  WHERE MC.CATEGORY='Orgin' AND OP.FK_CrusId=CD.Id  FOR XML PATH('')),1,1,''
	),

	Destination=STUFF(
	(SELECT ','+MC.Value FROM DiscountMappCrusDiscount AS DN LEFT OUTER JOIN mCommonCruise AS MC ON DN.FK_Discount=MC.ID  WHERE MC.CATEGORY='Orgin' AND DN.FK_CrusId=CD.Id  FOR XML PATH('')),1,1,''
	)

 from [Cruise].tbl_Cruise_ServiceFee_GST_QuatationDetails  CD    
 left join mUser MU on Mu.ID=CD.CreatedBy    
 where      
  (CD.UserType = @UserType or @UserType='' or @UserType=null ) and       
  (CD.MarketPoint = @MarketPoint or @MarketPoint='' or @MarketPoint=null )   
  order by CD.createddate desc
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[Sp_GetCruiseServiceDetails] TO [rt_read]
    AS [DB_TEST];


CREATE proc [Rail].[Sp_GetServiceDetails]        
@UserType varchar(50)=null,        
@MarketPoint varchar(50)=null        
AS        
BEGIN         
 select         
 CD.Id,  
 --TravelValidityFrom,TravelValidityTo,Origin,Destination,GST,Cabin,Deck,Room,  
 IssuanceFrom,IssuanceTo,MarketPoint,BookingFee, AgencyName,  
 BookingType,ServiceType,CD.isActive,CreatedDate,ModifiedDate,MU.UserName as 'CreatedBy',MU.FullName,    
 --PassType,ProductList,cd.CommissionType,Commission,CD.BookingFeeType,BookingFee,CD.AdditionAmountType,AdditionAmount,Currency,  
 case      
 --when UserType=5 then 'AFA'       
 --when UserType=4 then 'Air Arabia'       
 when UserType=1 then 'B2C'
 when UserType=2 then 'B2B'
 when UserType=3 then 'Marine'
 when UserType=4 then 'Holiday'      
 when UserType=5 then 'RBT'       
 when UserType=1245 then 'External Client'       
 else 'NA'      
end  as 'UserType'       
      
 from [Rail].[tbl_ServiceFee]  CD      
 left join mUser MU on Mu.ID=CD.CreatedBy      
 where        
  (CD.UserType = @UserType or @UserType='' or @UserType=null ) Or         
  (CD.MarketPoint = @MarketPoint or @MarketPoint='' or @MarketPoint=null ) and 
  CD.isActive=1 order by CreatedDate desc
END  
--============================================              
-- Author : amol chaudhari              
-- Crated Date : 12/05/2022              
-- Description : To get Cruise Sevice/ fee / quotation / gst              
-- Sp_GetCruiseDiscountDetails null, null              
--============================================              
              
              
CREATE proc [Rail].[Sp_GetServiceDetailsNew]  --2,'Select',''             
@UserType int=0,              
@MarketPoint varchar(50)=null,      
@AgencyName varchar(5000)=null      
AS              
BEGIN       
      
if(@UserType =0 and @MarketPoint='Select' And @AgencyName!='')      
begin      
 select               
 sf.Id,        
 --TravelValidityFrom,TravelValidityTo,Origin,Destination,GST,Cabin,Deck,Room,        
 IssuanceFrom,IssuanceTo,MarketPoint,BookingFee, BR.AgencyName,        
 BookingType,ServiceType,sf.isActive,CreatedDate,ModifiedDate,MU.UserName as 'CreatedBy',MU.FullName,          
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
            
 from rail.Service_AgentMapping sa 
inner join 
Rail.tbl_ServiceFee sf on sa.ServiceId = sf.Id
inner join 
B2BRegistration BR on sa.AgentId=BR.FKUserID
left join mUser MU on Mu.ID=sf.CreatedBy 
where BR.AgencyName LIKE '%' + @AgencyName + '%'
and sf.isActive = 1        
 end       
      
 else if(@UserType !=0  and @MarketPoint='Select' and  @AgencyName='' )      
       
 begin      
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
       
 CD.UserType=@UserType  and      
   CD.isActive=1 order by CreatedDate Desc       
      
 end       
      
      
 else if(@UserType =0  and @MarketPoint!='Select' and @AgencyName='')      
       
 begin      
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
       
 CD.MarketPoint=@MarketPoint  and      
   CD.isActive=1  order by CreatedDate Desc     
      
 end      
   else if(@UserType !=0  and @MarketPoint!='Select' and @AgencyName='')      
       
 begin      
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
 CD.UserType=@UserType and      
 CD.MarketPoint=@MarketPoint and      
   CD.isActive=1  order by CreatedDate Desc     
      
 end       
      
  else if(@UserType =0  and @MarketPoint!='Select' and @AgencyName!='')      
       
 begin      
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
       
 CD.MarketPoint=@MarketPoint and CD.AgencyName=@AgencyName and      
   CD.isActive=1 order by CreatedDate Desc      
      
 end       
  else if(@UserType !=0  and @MarketPoint='Select' and @AgencyName!='')      
       
 begin      
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
 CD.UserType=@UserType and      
 CD.AgencyName=@AgencyName       
 and CD.isActive=1  order by CreatedDate Desc     
      
 end       
      
      
 else if(@UserType  !=0 and @MarketPoint!='Select' and @AgencyName !='')      
       
 begin      
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
  (CD.UserType=@UserType and      
  CD.MarketPoint=@MarketPoint and CD.AgencyName=@AgencyName or    
  CD.AgencyName='All')    
 and CD.isActive=1 order by CreatedDate Desc      
      
 end       
 else       
      
 begin      
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
   CD.isActive=1   order by CreatedDate Desc   
      
 end       
      
END 
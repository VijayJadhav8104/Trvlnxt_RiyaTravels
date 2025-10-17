-- Sp_helpText BookingTrackReport_Hotel              
               
                
CREATE proc BookingTrackReport_Hotel                  
 @FromDate Date=null,                     
 @ToDate Date=null,                     
 -- @BranchCode varchar(40)=null,                     
 @PaymentType varchar(50)=null,                    
 @UserTypeId int=null,      --b2b b2c marine holiday                 
 @AgentId int=null,                    
 @Country varchar(100)=null,                      
 @Status  varchar(50)=null,                
 @BookingId varchar(50)=null,            
 @hotelPnr varchar(20)=null            
                  
                
AS                  
BEGIN                  
                  
Select              
            
            
 distinct HB.pkId,                    
BR.AgencyName as 'AgencyName',                  
HB.BookingReference as 'BookingId',                  
SH.Status as 'Status',                  
CONVERT(varchar, HB.inserteddate,106) as 'BookingDate',-- convert(varchar, HB.CheckInDate, 106) as CheckInDate                         
'' as 'Remark',                  
--AGL.UserName as 'AgentId',   
BR.Icast as 'AgentId',                 
HB.SupplierName as 'SupplierName',                  
case                   
    when HB.B2BPaymentMode =1 then 'Hold'                  
    when HB.B2BPaymentMode =2 then 'Credit Limit'                  
    when HB.B2BPaymentMode =3 then 'Make Payment'                  
    when HB.B2BPaymentMode =4 then 'Self Balance'                  
 end as 'PaymentMode',                  
HB.QtechAppliedAgentRate as 'HotelRate',                  
--UserType.Value as 'UserName',                 
concat(mu.FullName, '-', mu.UserName) as 'UserName',                
convert(varchar,SH.CreateDate,106) as 'UpdateDate',                  
AGL.FirstName + ' '+AGL.LastName  as 'UpdateBy'                  
                  
                  
from                  
    Hotel_BookMaster HB  WITH (NOLOCK)                 
 left join B2BRegistration BR  WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                   
 left join AgentLogin AGL  WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                  
-- left join (select  UserID,value from AgentLogin ag left join mCommon com on ag.UserTypeID=com.ID)UserType on  HB.RiyaAgentID=UserType.UserID                 
 left Join(select Mu1.username, mu1.FullName,mu1.ID,muc.CountryCode from  Muser Mu1  WITH (NOLOCK) left join mCountry MuC  WITH (NOLOCK) ON MuC.ID=Mu1.CountryId)Mu  on HB.MainAgentID=Mu.ID                
 inner join (Select SH1.FKHotelBookingId,SH1.CreateDate,SH1.CreatedBy, SH1.FkStatusId,SM.Status,SH1.IsActive from Hotel_Status_History SH1  WITH (NOLOCK) left join Hotel_Status_Master SM  WITH (NOLOCK) on SH1.FkStatusId= SM.Id) SH on HB.pkId=SH.FKHotelBookingId                
                  
 where                 
    cast(HB.inserteddate as date) between @FromDate and @ToDate and                  
   (HB.B2BPaymentMode=@PaymentType or @PaymentType='') and                
--(AGL.Country= @Country or @Country='') and                  
       
(AGL.UserTypeID = @UserTypeId  or @UserTypeId ='') and                 
 (HB.RiyaAgentID=@AgentId or @AgentId='') and                
                                  --(HB.CurrentStatus=@Status or @Status='')and              
 (SH.FkStatusId=@Status or @Status='')and            
 --(Mu.CountryCode IN  (select Data from sample_split(@Country,',')) or @Country='' )and        
 (HB.BookingReference=@BookingId or @BookingId='')and            
 (HB.BookingReference=@hotelPnr or @hotelPnr='')and             
 SH.IsActive=1 and                 
 HB.BookingReference is not null                
                 
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BookingTrackReport_Hotel] TO [rt_read]
    AS [dbo];


-- =============================================              
-- Author:  Jishaan.S              
-- Create date: 09-02-2023              
-- Description: ApiBookData              
-- =============================================              
CREATE PROCEDURE [Hotel].[insertApiBookDataTest]              
@bookingId varchar(100) = null,              
@BookingAmount varchar(100) = null,              
@commission varchar(100) = null  ,            
@deadlineDate varchar(100) = null ,            
@Tds varchar(100) = null,          
@ClientBookingId varchar(150)=null,          
@SuppliyerCurr varchar(150)=null,          
@AgencyCurr varchar(150)=null,        
@HGToken varchar(200)=null,        
@HGRateCode Varchar(200)=null,      
@BookToken varchar(200)=null,    
@SupplierRate varchar(200)=null,  
@AmOfficeId varchar(200)=null,  
@AmRateCode varchar(200)=null  
AS              
BEGIN              
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'BookingAmount',@BookingAmount,@ClientBookingId);            
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'SupplierRate',@SupplierRate,@ClientBookingId);     
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'AgentCommission',(case when (@commission is null or @commission = '') then '0' else @commission end),@ClientBookingId);            
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'DeadlineDate',@deadlineDate,@ClientBookingId);            
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'TDS',(case when (@Tds is null or @Tds = '') then '0' else @Tds end),@ClientBookingId);            
-- new line added      
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'BookToken',@BookToken ,@ClientBookingId);            
      
 IF(@SuppliyerCurr IS NOT NULL)          
 BEGIN          
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'SupplierCurrencyRate',@SuppliyerCurr,@ClientBookingId);            
 END          
 if(@AgencyCurr IS NOT NULL)          
 BEGIN          
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'AgentCurrencyRate',@AgencyCurr,@ClientBookingId);            
 END          
          
 if(@HGToken IS NOT NULL and @HGToken!='')          
 BEGIN          
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'HGToken',@HGToken,@ClientBookingId);            
 END        
         
 if(@HGRateCode IS NOT NULL and @HGRateCode!='')          
 BEGIN          
 insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'HGRateCode',@HGRateCode,@ClientBookingId);            
 END          
        
if(@AmOfficeId IS NOT NULL and @AmOfficeId!='')          
 BEGIN          
   insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'AmOfficeId',@AmOfficeId,@ClientBookingId);            
 END   
  
 if(@AmRateCode IS NOT NULL and @AmRateCode!='')          
 BEGIN          
   insert into Hotel.ApiBookData(BookingId,[Key],Value,ClientBookingID) values(@bookingId,'AmRateCode',@AmRateCode,@ClientBookingId);            
 END   
  
        
END 
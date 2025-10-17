            
  -- GetHBRatedCodeToken 'TNHAPI00000037','TNHAPIEANTEST19042023'          
CREATE Proc GetHBRatedCodeToken           
@BookingId varchar(100)=null,          
@ClientBookingId varchar(100)=null          
As            
BEgin            
 Declare @Token varchar(50)=null            
 Declare @RateCodes varchar(50)=null            
 Declare @IsCBId varchar(50)=null  --Is Client Booking Id alredy Exists            
 Declare @IsBId varchar(50)=null  --Is Booking Id alredy Exists       
 Declare @AmOfficeId varchar(50)=null            
 Declare @AmRateCode varchar(50)=null       
          
            
 select @Token=Value   from [Hotel].ApiBookData where  [key]='HGToken'  and BookingId=@BookingId             
 select @RateCodes=Value   from [Hotel].ApiBookData where  [key]='HGRateCode'  and BookingId=@BookingId        
 select @AmOfficeId=Value   from [Hotel].ApiBookData where  [key]='AmOfficeId'  and BookingId=@BookingId             
 select @AmRateCode=Value   from [Hotel].ApiBookData where  [key]='AmRateCode'  and BookingId=@BookingId        
       
      
 if exists (select id from [Hotel].ApiBookData where BookingId=@BookingId)          
 begin          
     select @IsBId='Yes'          
 End          
 else          
 Begin          
      select @IsBId='No'          
 End          
  if exists (select id from [Hotel].ApiBookData where ClientBookingID=@ClientBookingId)          
 begin          
     select @IsCBId='Yes'          
 End          
 else          
 Begin          
    select @IsCBId='No'          
 End          
           
      --final select       
 Select       
 @Token as 'HGToken' ,      
 @RateCodes as 'HGRateCode' ,      
 @IsBId as 'IsBookingIdExists'  ,      
 @IsCBId as 'IsBookingClinetIdExists',      
 @AmOfficeId as 'AmOfficeId',      
 @AmRateCode as 'AmRateCode'      
            
            
--select * from [Hotel].ApiBookData             
ENd 
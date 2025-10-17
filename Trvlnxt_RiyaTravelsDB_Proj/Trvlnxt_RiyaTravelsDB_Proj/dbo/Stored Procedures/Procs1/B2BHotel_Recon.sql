              
        --select  CONVERT(varchar,inserteddate,106),FORMAT (inserteddate, 'MMM dd yyyy hh:mm tt'),* from Hotel_BookMaster where pkId=99926      
    --exec B2BHotel_Recon 98675            
-- =============================================                    
-- Author:  <Author,,Name>                    
-- Create date: <Create Date,,>                    
-- Description: <Description,,>                    
-- execute  B2BHotel_Recon 176423                    
-- =============================================                    
CREATE PROCEDURE [dbo].[B2BHotel_Recon]                     
 -- Add the parameters for the stored procedure here                    
                     
 @Id int=0                    
                    
AS                    
                        
BEGIN                        
                      
declare @PassangerName varchar(max)='';                      
 --select                       
 --  --STRING_AGg(Salutation+' '+ HP.FirstName+' '+HP.LastName, '<br/>')                       
 --  @PassangerName=@PassangerName +  '<br/> Room No '+cast( RoomNo as varchar) +                       
 -- STRING_AGg('<br/>'+Salutation+' '+ HP.FirstName+' '+HP.LastName+case PassengerType when 'Child' then '('+age+')' else ''end, '<br/>')                       
                      
 --  from Hotel_Pax_master HP                       
 -- group by book_fk_id,RoomNo                      
 -- having HP.book_fk_id                    
                      
  select                       
   --coalesce(Salutation+' '+ HP.FirstName+' '+HP.LastName, '<br/>')                       
   @PassangerName=coalesce(@PassangerName +  '<br/> Room No '+cast( RoomNo as varchar) +                       
   '<br/>'+Salutation+' '+ HP.FirstName+' '+HP.LastName+case PassengerType when 'Child' then '('+age+')' else ''end, '<br/>')                       
                      
   from Hotel_Pax_master HP                       
  group by book_fk_id,RoomNo ,Salutation ,FirstName, LastName, PassengerType, Age                    
  having HP.book_fk_id   =@Id                      
                      
  --select @PassangerName                      
                      
                      
select * from (                      
--Data of riya tables                      
                      
select                        
         HB.SupplierName                        
  ,FORMAT (hb.inserteddate, 'MMM dd yyyy hh:mm tt') as BookingDate                        
  --,CONVERT(varchar,SH.CreateDate,100) as BookingStatusDate                        
  ,'' as BookingStatusDate                        
                          
  ,HB.BookingReference as 'RefNO'                        
  ,HB.HotelName as HotelName                        
  ,'<br/>'+RM.RoomTypeDescription as 'RoomType'                        
  ,HB.HotelAddress1 as 'Address'                        
  ,rm.room_no 'RoomNo'                      
  , @PassangerName as'PassangerName'                        
 -- ,'pax details' 'PassangerName'                        
  ,'Room Policy' as 'RoomPolicy'                        
  ,CONVERT(varchar,HB.CheckInDate,6) as CheckInDate                         
     ,CONVERT(varchar,HB.CheckOutDate,6) as CheckOutDate                        
    ,HB.DisplayDiscountRate as 'TotalPrice'     
 ,Convert(varchar(200),(HB.CurrencyCode +' '+ HB.DisplayDiscountRate )) AS BookingAmount    
 ,HB.ROEValue as 'SupplierToAgentRoe'    
          
 --,HB.SupplierRate as 'TotalPrice'                      
--,(Select sum(baseRate) from Hotel_Room_master where book_fk_id=@Id) as 'TotalPrice'  --add column  on 8-5-23                      
  ,HB.CurrencyCode as 'Currency'      --commented on 8-5-23    --uncommented on 18-5-23                  
--,HB.SupplierCurrencyCode as 'Currency'  --commented on 18-5-23                        
  ,SM.Status as 'Status'                        
  ,FORMAT (HB.ExpirationDate, 'MMM dd yyyy hh:mm tt') as DeadlineDate                        
  ,Hb.CountryName as 'Country'         
  ,HB.cityName as 'City'                        
  ,HB.PassengerPhone as 'Phone'                        
  ,HNM.Nationality as 'Nationality'    --add column on 19-5-23                        
                        
  ,'Riya' 'info',                      
case ReconStatus
	when 'Y' then 'OK' + ' by '+ mu.EmployeeNo+' - ' +mu.FullName 
	when 'N' then 'DISPUTE' + ' by '+ mu.EmployeeNo+' - ' +mu.FullName else '' end   as 'ReconStatus'                      
  ----,HP.FirstName          
  ----,SM.Status                        
--from Hotel_BookMaster HB                        
 ,ReconRemark                       
                      
  from                      
   Hotel_Room_master RM  WITH (NOLOCK)                      
   --join Hotel_Pax_master HP on RM.book_fk_id =HP.book_fk_id                        
                          
    left join Hotel_Status_History SH WITH (NOLOCK) on rm.book_fk_id=SH.FKHotelBookingId                        
                      
                      
    left join Hotel_BookMaster HB WITH (NOLOCK)  on hb.pkId= RM.book_fk_id                      
    inner join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                  
 left join Hotel_Nationality_Master HNM WITH (NOLOCK)  on HB.BookingCountry=HNM.ISOCode                
                       left join mUser mu on mu.ID=hb.ReconBy  
where (RM.book_fk_id = @Id)  and SH.IsActive=1  )a                      
                      
union all                    
--Data to be fetched from Supliers log.                      
select                        
  HR.Supplier                       
  --,CONVERT(varchar,HB.inserteddate,100) as BookingDate            
    ,  FORMAT (hr.Booking_Date, 'MMM dd yyyy hh:mm tt') as BookingDate                        
  --,CONVERT(varchar,SH.CreateDate,100) as BookingStatusDate                        
  ,'' as BookingStatusDate                        
                          
  ,HB.SupplierReferenceNo as 'RefNO'                        
  ,Concat('HotelName : ',HR.Hotel_Name) as HotelName                        
    -- ,'<br/>'+RM.RoomTypeDescription as 'RoomType'              
  --, HR.Room_Category  as 'RoomType' 
 , CONCAT('RoomType : ', HR.Room_Category) AS RoomType
            
 --,HR.Room_Category as 'RoomType'            
  --,RM.RoomTypeDescription as 'RoomType'                        
  --,HB.HotelAddress1 as 'Address'               
  ,Concat('Address : ',HR.HotelAddressline +' '+ 'City: '+ HR.Booked_City) as 'Address'            
  ,HR.No_of_Room as   'RoomNo'                      
                      
  ,Concat('GuestName : ',HR.GuestName) as'PassangerName'                        
 -- ,'pax details' 'PassangerName'                        
 , 'Room Policy ' as 'RoomPolicy'                        
  --,CONVERT(varchar,HB.CheckInDate,6) as CheckInDate                     
  , CONVERT(varchar,HR.Check_in_date,6) as 'CheckInDate'             
     --,CONVERT(varchar,HB.CheckOutDate,6) as CheckOutDate            
    ,CONVERT(varchar,HR.Check_out_date,6) as 'CheckOutDate'             
            
  ,ROUND(HR.Total_Amount,2) as 'TotalPrice'     
  ,'0' AS BookingAmount    
  ,0 as 'SupplierToAgentRoe'    
  --,HB.SupplierCurrencyCode as 'Currency'             
  , HR.Supplier_Currency as 'Currency'            
  --,SM.Status as 'Status'             
  , HR.Status as 'Status'            
  --,FORMAT (HB.ExpirationDate, 'MM/dd/yyyy hh:mm tt') as DeadlineDate             
    ,convert(varchar(max), HR.DeadlineDate, 0)  as 'DeadlineDate'            
            
  ,'' as 'Country'                        
  ,HR.Booked_City as 'City'                        
  ,'' as 'Phone'                        
  ,'' as 'Nationality'    --add column on 19-5-23                    
                      
  ,'Supplier' 'info',                      
case   
ReconStatus   
when 'Y' then 'OK' + ' by '+ mu.EmployeeNo +' - ' +mu.FullName 
when 'N' then 'DISPUTE' + ' by '+ mu.EmployeeNo+' - ' +mu.FullName else '' end  as   
  
'ReconStatus'                      
,ReconRemark                       
                      
  from   Hotel_BookMaster HB  WITH (NOLOCK)              
  left join Hotel_Room_master RM WITH (NOLOCK) on HB.pkId=RM.book_fk_id            
       left join Hotel_Status_History SH WITH (NOLOCK) on rm.book_fk_id=SH.FKHotelBookingId                               
    inner join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                       
     left join Hotel_Nationality_Master HNM  WITH (NOLOCK) on HB.BookingCountry=HNM.ISOCode              
  left join Hotel.HotelReconRpt HR WITH (NOLOCK) on HB.BookingReference=HR.BookID      
  left join mUser mu on mu.ID=hb.ReconBy  
where (RM.book_fk_id = @Id)  and SH.IsActive=1  and HR.IsActive=1 and HR.RowFlag='Supplier'            
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BHotel_Recon] TO [rt_read]
    AS [dbo];


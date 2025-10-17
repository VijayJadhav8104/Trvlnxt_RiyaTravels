/*alter table Hotel.HotelReconRpt    
add     
    
Room_Category,    
GuestName,    
DeadlineDate    
*/    
CREATE proc [Hotel].[Proc_InsertHotelReconLogs]                     
                    
                    
@RowFlag as varchar(50)= null,                    
--@SrNo as int= null,                    
@BookingDate as datetime= null,                    
@BookID as varchar(150)= null,                    
@Supplier as varchar(50)= null,                    
@Channel as varchar(50)= null,                    
@Status as varchar(50)= null,                    
@AgentCurrency as varchar(5)= null,                    
@SupplierCurrency as varchar(5)= null,                    
@ROE as float= null,                    
@TotalAmount as float= null,                    
@Commission as float= null,                    
@DebittoAgent as decimal= null,                    
@CredittoAgent as decimal= null,                    
@Revenue as decimal= null,                    
@Paymentmode as int= null,                    
@ConvienceFees as decimal= null,                    
@PGMode as varchar(150)= null,                    
@NoofNight as int= null,                    
@NoofPax as varchar(15)= null,                    
@NoofRoom as int= null,                    
@HotelName as varchar(max)= null,                    
@BookedCity as varchar(150)= null,                    
@Checkindate as datetime= null,                    
@Checkoutdate as datetime= null,                    
@AgencyCode as varchar(250)= null,                    
@AgencyName as varchar(250)= null,                    
@CorelationID as nvarchar(500)= null ,                
@Checkintime as varchar(10)=null,                
@Checkouttime as varchar(10)=null,        
@error as nvarchar(max)=null,      
@SBaseRateSCurrency as float = null ,     
     
@Room_Category as varchar(max)=null ,    
@GuestName as varchar (max)=null,      
@DeadlineDate aS VARCHAR(MAX)=null    
as                    
                    
Begin                     
BEGIN --commented temperory            
    declare @MasterbookingDate as datetime        
   Declare @fkBookid int =0             
if(Exists(select 1 from [Hotel].HotelReconRpt where BookID= @BookID and RowFlag=@RowFlag and IsActive=1))                    
Begin                    
                    
             
select @fkBookid=pkId,@MasterbookingDate=inserteddate from Hotel_BookMaster where BookingReference=@BookID           
        
delete  [Hotel].HotelReconRpt                    
--set                     
--IsActive=0                    
where BookID= @BookID and RowFlag=@RowFlag  and IsActive=1                  
End                    
                    
Insert into [Hotel].HotelReconRpt          
      (              
                 
RowFlag,                    
        
Sr_No,                    
Booking_Date,                    
BookID,                    
Supplier,                    
Channel,                    
Status,                    
Agent_Currency,                    
Supplier_Currency,                    
ROE,                    
Total_Amount,                    
Commission,                    
Debit_to_Agent,                    
Credit_to_Agent,                    
Revenue,                    
Payment_mode,                    
Convience_Fees,                    
PG_Mode,                    
No_of_Night,                    
No_of_Pax,                    
No_of_Room,                    
Hotel_Name,                    
Booked_City,                    
Check_in_date,                    
Check_out_date,                    
Agency_Code,                    
Agency_Name,                    
Corelation_ID,                  
IsActive,                    
ReconInsertDate    ,                
Checkintime,              
Checkouttime,              
FKBOOKID ,        
ErrorDesc             
 ,SBaseRateSCurrency ,    
 Room_Category,    
GuestName,    
DeadlineDate    
 )              
values                    
(                    
                    
@RowFlag,                    
null,                    
isnull(@BookingDate,@MasterbookingDate),           
@BookID,                    
@Supplier,                    
@Channel,                    
@Status,                    
@AgentCurrency,                    
@SupplierCurrency,                    
@ROE,                    
@TotalAmount,                 
@Commission,                    
@DebittoAgent,                    
@CredittoAgent,                    
@Revenue,                    
@Paymentmode,                    
@ConvienceFees,                    
@PGMode,                    
@NoofNight,                    
@NoofPax,                    
@NoofRoom,                    
@HotelName,                    
@BookedCity,                    
@Checkindate,                    
@Checkoutdate,                    
@AgencyCode,                    
@AgencyName,                  
@CorelationID,                    
1,                    
GETDATE()    ,                
@Checkintime ,                
@Checkouttime  ,              
@fkBookid,        
@error        
,@SBaseRateSCurrency  ,    
@Room_Category,    
@GuestName,    
@DeadlineDate    
)              
--select 'ok'            
END            
                   
END 
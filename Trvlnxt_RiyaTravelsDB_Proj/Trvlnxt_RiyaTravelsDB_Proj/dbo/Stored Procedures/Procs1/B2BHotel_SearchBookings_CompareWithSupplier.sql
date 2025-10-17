CREATE PROCEDURE [dbo].[B2BHotel_SearchBookings_CompareWithSupplier]                
 -- Add the parameters for the stored procedure here                
                 
 @Id int=0,                
 @Consultant nvarchar(200)='',                
 @Branch nvarchar(200)='',                
 @Agent nvarchar(200)='',                
 @TravelerName nvarchar(200)='',                
 @ServiceFromDate varchar(50)='',                
 @ServiceToDate varchar(50)='',                
 @BookingID nvarchar(200)='',                
 @BookingStatus  nvarchar(200)='',                
 @SupplierRefNo nvarchar(200)='',                
 @Supplier nvarchar(200)='',                
 @BookingFromDate varchar(50)='',                
 @BookingToDate varchar(50)='',                
 @VoucherFromDate varchar(50)='',                
 @VoucherToDate varchar(50)='',                
 @AgentReferenceNo nvarchar(200)='',                
 @StatusFromDate varchar(50)='',                
 @StatusToDate varchar(50)='',                
 @VoucherID nvarchar(200)='',                
 @ConfirmationNumber nvarchar(200)='',                
 @ModifiedFromDate varchar(50)='',                
 @ModifiedToDate varchar(50)='',                
 @CancellationFromDate varchar(50)='',                
 @CancellationToDate varchar(50)='',                
 @Country nvarchar(200)='',                
 @City nvarchar(200)='',              
 @ExcelFlag varchar(50)=''              
AS                
BEGIN            
           
 if(@ExcelFlag='Excel')              
 begin              
 IF OBJECT_ID ( 'tempdb..#TEMPCompareWithSupplier') IS NOT NULL              
 DROP table  #TEMPCompareWithSupplier              
          
 SELECT * INTO #TEMPCompareWithSupplier from           
   (          
   select distinct                
   HB.pkId    ,    
    HB.DisplayDiscountRate 'BookingAmount'    
   --,HB.book_Id as book_Id               
  -- ,'' as [Service]              
   ,HB.BookingReference as [Booking Id]                       
  from Hotel_BookMaster HB WITH (NOLOCK)
  left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id                 
  left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                 
  left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                 
  join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                
  --left join Hotel_Status_History HSH on HB.book_Id=HSH.FKHotelBookingId                
  left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                
                  
 where                 
   --(HB.AgentId = @Consultant  or @Consultant ='')                
                
   --(HB.MainAgentID = @Consultant  or @Consultant ='')                
   ( ( @Consultant ='') or (HB.MainAgentID IN  (select Data from sample_split(@Consultant,','))) )                
                
                
                
   --and(BR.BranchCode=@Branch or @Branch ='')                
   and( ( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))) )                
                   
   --and(HB.AgentId = @Agent or @Agent ='')  --akash                
      and(HB.RiyaAgentID = @Agent or @Agent ='')                  
                    
   and(HB.LeaderTitle+' '+HB.LeaderFirstName like '%'+@TravelerName+'%'  or @TravelerName ='')                
   and(HB.BookingReference = @BookingID or @BookingID ='')                
                   
   --and(SH.FkStatusId = @BookingStatus or @BookingStatus='')                 
   and( (@BookingStatus ='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))) )                  
                
   and(HB.SupplierReferenceNo = @SupplierRefNo or @SupplierRefNo='')                 
                
                
   --and(HB.SupplierName =@Supplier  or @Supplier ='')                  
   and( (@Supplier ='') or (HB.SupplierName IN  (select Data from sample_split(@Supplier,','))) )                  
                
   and(HB.riyaPNR = @AgentReferenceNo or @AgentReferenceNo='')                
   and(HB.VoucherNumber = @VoucherID   or @VoucherID='')                 
                   
   --and(HB.CountryName like '%'+@Country+'%'   or @Country='')                 
   --and( (@Country ='') or (HB.CountryName IN  (select cast(Data as varchar) from sample_split(@Country,','))) ) --commented by sana                  
   and( (@Country ='') or (HB.CountryName IN  (select cast(Data as varchar) from sample_split(@Country,','))) )       -- changed to countryname from countrypkid          
                
   --and(HB.cityName like '%'+@City+'%'   or @City='')                 
   and( (@City ='') or (HB.cityName IN  (select cast(Data as varchar) from sample_split(@City,','))))                  
                
                
   and (                
     (@ConfirmationNumber = '1' and isnull(ConfirmationNumber,'') <> '')                
     OR                
     (@ConfirmationNumber = '0' and isnull(ConfirmationNumber,'') = '')                
     OR                
     (@ConfirmationNumber = '')                
   )                
                   
   and (Convert(varchar(12),HB.CheckInDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                
   case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                
                
   and (Convert(varchar(12),HB.inserteddate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                
   case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                
                
   and (Convert(varchar(12),HB.VoucherDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                
   case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end or (@VoucherFromDate='' and @VoucherToDate=''))                
                
   and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) and                
   case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                
                
   and (Convert(varchar(12),SH.ModifiedDate,102) between Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) and                
   case when @ModifiedToDate <> '' then Convert(varchar(12),Convert(datetime, @ModifiedToDate,103),102)else Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) end or (@ModifiedFromDate='' and @ModifiedToDate=''))                
                
                
                
   --and book_Id is not null                
   and SH.IsActive=1                 
   and HB.RiyaAgentID is not null                 
   and HB.B2BPaymentMode is not null                
   and HB.BookingReference is not null                
  -- order by pkId desc          
  )p order by pkId          
        
     
  
    
    
  select * from       
        
  (        
  select       
  --ROW_NUMBER() OVER (ORDER BY  Rl.Id ASC) AS 'Serial Number',      
    BM.[Booking Id],    
   BookingAmount,    
  --Bm.[Booking Currency],      
 -- Rl.Id,      
  --BM.[Hotel Name],      
 -- Rl.RoomType,      
  min(RL.Price) 'lowestprice',      
  UPPER(LEFT( Rl.SupplierName,1))+LOWER(SUBSTRING( Rl.SupplierName,2,LEN( Rl.SupplierName))) as 'SupplierName'      
 -- Rl.CheckInDate,      
 -- RL.CheckOutDate          
            
  from BBHotelRoomListLog RL  WITH (NOLOCK)          
  join #TEMPCompareWithSupplier BM WITH (NOLOCK)  on BM.pkid=RL.FkBookId          
  where RL.FkBookId in(BM.pkid)        
        
 group by SupplierName, BM.[Booking Id] ,BookingAmount     
  ) as SourcTable      
  pivot      
(      
       
       
 min(lowestprice)      
      
  FOR SupplierName      
  IN (Agoda,Cleartrip,Desiya,Dotw,Expediapackage,Hotelbeds,Hotelspro,Localsystem,Logitravel,Lotsofhotels,Miki,Misterroom,Restel,Wsrgthlt,YouTravel)      
 ) as xyz      
      
      
    end  
        
           
END          

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BHotel_SearchBookings_CompareWithSupplier] TO [rt_read]
    AS [dbo];


      
CREATE procedure [dbo].[updateallBookDetailsDemo]                      
         @Message varchar(500)=null,                      
         @book_Id varchar(150)=null,                      
         @AgentId varchar(150)=null,                      
         @RiyaAgentID nvarchar(50)=null,                      
         @BookingReference varchar(150)=null,                                        
       --@ROEVAlue decimal=null,  --r                    
         @TotalCharges decimal=null,                      
       --@LeaderTitle varchar(6),                      
       --@LeaderFirstName varchar(150),                      
       --@LeaderLastName varchar(150),                      
       --@CurrencyCode varchar(10)=null,                      
       --@HotelName varchar(150)=null,                      
       --@CountryName varchar(150)=null,                      
      -- @CityId varchar(150)=null, --r                     
       --@HotelAddress1 varchar(650)=null,                      
         @CurrentStatus varchar(150)=null,                      
       --@ExpirationDate datetime=null,                      
       --@TotalAdults varchar(10)=null,                      
       --@TotalChildren varchar(10)=null,                      
      -- @TotalRooms varchar(10)=null,                      
       --@HotelAddress2 varchar(650)=null,                      
       --@ServiceDate { get; set; }                      
       --@CheckInDate datetime=null,                      
       --@CheckOutDate datetime=null,                      
         @AgentRate decimal=null,                      
       --@HotelPhone varchar(50)=null,                      
       --@HotelRating varchar(20)=null,                      
         @SelectedNights varchar(20)=null,                      
     --  @roomType varchar(100)=null, --r                     
     --  @CommentContract varchar(max)=null,                      
     --  @orderId varchar(30)=null,                      
      -- @CancelHours int=null,                      
         @AgentRefNo varchar(30)=null,                      
         @IsBooked int=0,                      
         @book_pk_id bigint,                      
     --  @SupplierName varchar(200)=null   --r                   
     -- ,@SupplierPhoneNo varchar(100)=null                      
         @SupplierReferenceNo varchar(50)=null                      
      --,@SupplierCurrencyCode varchar(10)=null                      
        ,@SupplierRate varchar(20)=null                                       
  ,@QtechTotalCharges numeric(18,2)                      
  ,@QtechAppliedAgentcharges numeric(18,2)=null                      
  ,@QtechAgentRate numeric(18,2)                      
      --,@BufferCancelDate Datetime=null                      
  ,@DisplayDisountRate nvarchar(500)=null                      
  ,@CancellationDeadLine nvarchar(500)=null                      
  ,@MainAgentID nvarchar(500)=null                      
  ,@PaymentType varchar(100)=null --added Altamash for insert history status                      
      --,@cancelcharge int=0                      
       ,@PolicyCode varchar(50)=NULL  --added by ketan to check if cancel allowed in amadeus                        
       ,@QtechStatus varchar(100)=null                      
       ,@CommentContract varchar(max)=null                    
                      
as                      
begin                      
                                       
  update [dbo].[Hotel_BookMaster]                      
           set     
    --  [orderId]=@orderId                                    
           [book_Id] =@book_Id                      
           ,[AgentId]=@AgentId                                
           ,[book_message]=@Message                      
           ,[BookingReference]=@BookingReference                                        
           ,[TotalCharges]=@TotalCharges                      
         --,[LeaderTitle]=@LeaderTitle                      
       --  ,[LeaderFirstName]=@LeaderFirstName                      
       --  ,[LeaderLastName]=@LeaderLastName                      
       --  ,[CurrencyCode]=@CurrencyCode                      
       --  ,[HotelName]=@HotelName              
      --   ,[CountryName]=@CountryName                      
      --   ,[CityId]=@CityId                      
       --  ,[HotelAddress1]=@HotelAddress1                      
           ,[CurrentStatus]=@CurrentStatus                      
       --  ,[ExpirationDate]=@ExpirationDate                      
           --,[TotalAdults]=@TotalAdults                      
           --,[TotalChildren]=@TotalChildren                      
           --,[TotalRooms]=@TotalRooms                      
        -- ,[HotelAddress2]=@HotelAddress2                                       
           --,[CheckInDate]=@CheckInDate                      
           --,[CheckOutDate]=@CheckOutDate                      
           ,[AgentRate]=@AgentRate                      
         --,[HotelPhone]=@HotelPhone                      
         --,[HotelRating]=@HotelRating                      
           ,[SelectedNights]=@SelectedNights                      
         ,[CancellationPolicy]=@CommentContract                      
           ,[AgentRefNo]=@AgentRefNo                                       
           ,[IsBooked]=@IsBooked                      
         --,[CancelHours]=@CancelHours                      
         --  ,[SupplierName]=@SupplierName                      
        -- ,[SupplierPhoneNo]=@SupplierPhoneNo                      
           ,[SupplierReferenceNo]=@SupplierReferenceNo                      
         --,[SupplierCurrencyCode]=@SupplierCurrencyCode                      
           ,[SupplierRate]=@SupplierRate                      
         --,[ROEVAlue]=  @ROEVAlue                      
         --,CancellationCharge=@cancelcharge                      
           ,[QtechTotalCharges]=@QtechTotalCharges                      
           ,[QtechAppliedAgentCharges]=@QtechAppliedAgentcharges                      
         --,[DisplayDiscountRate]=@DisplayDisountRate //Please never uncomment this                                      
     ,CancellationDeadLine=@CancellationDeadLine                      
     ,[QtechAppliedAgentRate]=@QtechAgentRate                      
         --,BufferCancelDate=@BufferCancelDate                      
      where pkId=@book_pk_id                      
                       
                      
                      
  UPDATE [dbo].[Hotel_Room_master]                      
  SET   -- [orderId] = @orderId                      
        [IsBooked] = @IsBooked                      
       -- ,RoomTypeDescription=@roomType                      
         WHERE book_fk_id=@book_pk_id                      
                      
                      
                      
 UPDATE [dbo].[Hotel_Pax_master]                      
  SET     
     --[orderId] = @orderId                      
       [IsBooked] = @IsBooked                      
  WHERE book_fk_id=@book_pk_id                      
                      
                      
  --//created by shivkumar                      
                      
  Declare @CurrentstatusID nvarchar(50)                      
  set @CurrentstatusID=( select Id from  Hotel_Status_Master where lower([Status])=lower(@CurrentStatus))                  
                        
                      
  --Altamash (Booking After Qutech Booking Sucsess Then Update Booking Status Below Table)                    
  update Hotel_Status_History set IsActive=0 where FKHotelBookingId=@book_pk_id                    
                    
  if(@QtechStatus='vouchered')                      
  begin                      
     insert into Hotel_Status_History                      
    (                      
     FKHotelBookingId                      
    ,FkStatusId                      
    ,CreateDate                      
    ,CreatedBy                      
    ,ModifiedDate                      
    ,IsActive                      
    )                      
    values        
    (                      
     @book_pk_id                      
    ,@PaymentType                      
    ,SYSDATETIME()                      
    ,@RiyaAgentID                      
    ,null                      
    ,1                      
    )                      
   End         
  else if(@QtechStatus='on_request')                      
  Begin                      
      insert into Hotel_Status_History                      
    (                      
     FKHotelBookingId                      
    ,FkStatusId                      
    ,CreateDate                      
    ,CreatedBy                      
    ,ModifiedDate                      
    ,IsActive                      
    )                      
    values                      
    (                      
     @book_pk_id                      
    ,1                      
    ,SYSDATETIME()                      
    ,@RiyaAgentID                      
    ,null                      
    ,1                      
    )                      
  End                 
                  
    else if(@QtechStatus='Failed')                      
  Begin                      
      insert into Hotel_Status_History                      
    (                      
     FKHotelBookingId                      
    ,FkStatusId                      
    ,CreateDate                      
    ,CreatedBy                      
    ,ModifiedDate                      
    ,IsActive                      
    )                      
    values                      
    (                      
     @book_pk_id                      
    ,11                    
    ,SYSDATETIME()                      
    ,@RiyaAgentID                      
    ,null                      
    ,1                      
    )                      
  End                      
  else if(@QtechStatus='Cancelled')                      
  Begin                      
      insert into Hotel_Status_History                      
    (                      
     FKHotelBookingId                      
    ,FkStatusId                      
    ,CreateDate                      
    ,CreatedBy                      
    ,ModifiedDate               
    ,IsActive                      
    )                      
    values                      
    (                      
     @book_pk_id                      
    ,7                    
    ,SYSDATETIME()                      
    ,@RiyaAgentID                      
    ,null                      
    ,1                      
    )                      
  End               
                      
  -----Created By Altamash Khan [Description]. For SelfBalance Revercal Functionality                      
 if(@PaymentType=4)                      
  Begin                      
 insert into RY_Hotel_SelfBalance_Reversal              
  (                      
  fk_pkId,                      
  booking_status,                      
  isactive,                      
  createdby                      
  )                      
  values                      
  (                      
   @book_pk_id,                      
   1,                      
   1,                      
   @MainAgentID                      
  )                      
  End                      
                      
  --//end by shivkumar                      
  --//end by altamash --[Discription]= add FkHotelBookingId on Hotel_Status_Master Table                      
                               
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[updateallBookDetailsDemo] TO [rt_read]
    AS [dbo];


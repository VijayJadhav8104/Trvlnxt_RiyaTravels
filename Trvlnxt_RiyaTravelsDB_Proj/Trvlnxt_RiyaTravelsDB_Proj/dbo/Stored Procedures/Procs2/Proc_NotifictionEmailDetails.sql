--Created By :-Ketan Marade  
--Date:- 17022022  
CREATE procedure Proc_NotifictionEmailDetails  
@PkId varchar(50),  
@BookingRefID varchar(150)  
As  
Begin  
Declare @IsCancelled Varchar(10),  
  @BookingReference Varchar(150),  
  @CurrentStatus Varchar(50),  
  @FkStatusid Varchar(50),  
  @emailSendFlag Varchar(50)  
 select @IsCancelled=IsCancelled,@BookingReference=BookingReference,@CurrentStatus=CurrentStatus  from Hotel_BookMaster  WHERE pkId=@PkId and BookingReference=@BookingRefID  
  
 select top 1 @FkStatusid=FkStatusid from Hotel_Status_History where FKHotelBookingId=@PkId and IsActive=0 order by ModifiedDate desc  
  
 select @emailSendFlag=emailSendFlag from UserEmaildReminder_Data  WHERE fk_pkid=@PkId  
  
 Declare @OldStatus Varchar(70)  
 IF(@FkStatusid=1)  
 Begin  
  Set @OldStatus='On Request'  
 END  
 else if(@FkStatusid=2)  
 Begin  
  Set @OldStatus='Sold Out'  
 END  
 else if(@FkStatusid=3)  
 Begin  
  Set @OldStatus='Confirmed'  
 END  
 else if(@FkStatusid=4)  
 Begin  
  Set @OldStatus='Vouchered'  
 END  
 else if(@FkStatusid=5)  
 Begin  
  Set @OldStatus='Reject'  
 END  
 else if(@FkStatusid=6)  
 Begin  
  Set @OldStatus='InProcess Cancel'  
 END  
 else if(@FkStatusid=7)  
 Begin  
  Set @OldStatus='Cancelled'  
 END  
 else if(@FkStatusid=8)  
 Begin  
  Set @OldStatus='Voucherd Cancelled'  
 END  
 else if(@FkStatusid=9)  
 Begin  
  Set @OldStatus='InProcess'  
 END  
 else if(@FkStatusid=10)  
 Begin  
  Set @OldStatus='Pending'  
 END  
 else if(@FkStatusid=11)  
 Begin  
  Set @OldStatus='Failed'  
 END  
 Else  
 Begin  
  Set @OldStatus=''  
 END  
  
 Declare @EmailReminder varchar(10)='NO'  
 if(@emailSendFlag=1)  
 BEGIN  
 set @EmailReminder='YES'  
 END  
  
 Declare @AutoCancel varchar(10)='NO'  
 if(@IsCancelled=1)  
 BEGIN  
 set @AutoCancel='YES'  
 END  
  
 Select @BookingReference As BookingId,@OldStatus As OldStatus, @CurrentStatus As NewStatus, @EmailReminder As EmailReminder, @AutoCancel AS AutoCancel  
End  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_NotifictionEmailDetails] TO [rt_read]
    AS [dbo];


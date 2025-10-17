-- =============================================  
-- Author:  #Gajanan Kadam  
-- Create date: 18-Nov-2019  
-- Description:   
-- =============================================  
CREATE PROCEDURE [dbo].[sp_getBookedHotelDataOfUser]  
 -- Add the parameters for the stored procedure here  
 @bookingid int  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
 if exists(select * from Hotel_BookMaster WITH(NOLOCK)  where book_Id=@bookingid)  
 begin  
  
 select HM.HotelName  
 ,HM.HotelRating  
 ,HM.book_Id,  
 CONVERT( VARCHAR(20),(HM.CheckInDate),101) AS CheckInDate,  
 DATEDIFF(DAY,HM.CheckInDate,HM.CheckOutDate) AS Night,  
 CONVERT( VARCHAR(20),(HM.CheckOutDate),101) AS CheckOutDate,  
 HM.TotalAdults,  
 HM.TotalChildren,  
 (CAST(TotalAdults AS INT) + CAST(TotalChildren AS INT)) TotalPass  
 ,HM.CancellationPolicy  
 ,isnull(HM.CancellationCharge,0 ) as CancellationCharge  
 ,HM.AppliedAgentCharges as  TotalCharges  
 --,HM.TotalCharges  
 ,CONVERT (VARCHAR(11),(HM.ExpirationDate),106) AS CancellDate  
 ,(DATENAME(weekday,HM.inserteddate) +','+ CONVERT (VARCHAR(11),(HM.inserteddate),106)+' at '+ CONVERT(varchar(10),HM.inserteddate,108)+' hrs') AS BookedOn    
 ,HM.HotelAddress1 AS HotelAddress   
 ,DATENAME(weekday,CheckInDate) 'DayIn'  
 ,DATENAME(weekday,CheckOutDate) 'DayOut'  
 ,(HP.Salutation+'. '+HP.FirstName+' '+HP.LastName) AS OccupantsName  
 ,HR.RoomTypeDescription  
 ,(UL.FirstName +' '+ UL.LastName) as Bookedby  
 ,HM.riyaPNR   
   
  
 from Hotel_BookMaster HM WITH(NOLOCK) jOIN Hotel_Pax_master HP WITH(NOLOCK) oN HM.pkId=HP.book_fk_id  
 JOIN Hotel_Room_master HR WITH(NOLOCK) ON HR.book_fk_id=HM.pkId AND HR.Room_Id=HP.room_fk_id  
 LEFT JOIN UserLogin UL WITH(NOLOCK) ON UL.UserName=HM.PassengerEmail  
 where hm.book_Id=@bookingid  
  
  
  
  
 --select * from Hotel_BookMaster where book_Id=2007  
 --select * from  Hotel_Pax_master where book_fk_id=5  
 --select * from  Hotel_Room_master where book_fk_id=5  
  
 --SELECT * FROM UserLogin WHERE UserName ='qa@riya.travel'  
 --SELECT * FROM Hotel_BookMaster WHERE PassengerEmail='qa@riya.travel'  
  
  
 end  
END  
  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getBookedHotelDataOfUser] TO [rt_read]
    AS [dbo];


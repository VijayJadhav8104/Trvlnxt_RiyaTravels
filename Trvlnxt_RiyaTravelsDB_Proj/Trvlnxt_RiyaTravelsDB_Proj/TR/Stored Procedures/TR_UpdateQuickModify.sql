-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [TR].[TR_UpdateQuickModify]  
 -- Add the parameters for the stored procedure here  
   
 @Id int=0,  
 @TRAddress nvarchar(max)='',  
 @TRPhoneNo nvarchar(500)='',  
 @ExpirationDate nvarchar(200)='',  
 @CancellationPolicy nvarchar(max)='',  
 @AdminNote nvarchar(200)=''  
  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
 update TR.TR_BookingMaster set  
  CityName = @TRAddress,  
  PassengerPhone = @TRPhoneNo,  
  CancellationDate = @ExpirationDate,  
  CancellationPolicyText = @CancellationPolicy,  
  CancellationRemark=@AdminNote  
  where BookingId=@Id  
  
  
END  

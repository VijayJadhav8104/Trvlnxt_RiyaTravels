CREATE PROCEDURE [TR].[UpdatePostCancellationRate]    
 -- Add the parameters for the stored procedure here    
     
 @Id int,    
 @CancellationCharge nvarchar(max)=null,    
 @CancellationRemark nvarchar(500)=null    
     
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    -- Insert statements for procedure here    
    
 update TR.TR_BookingMaster set PostCancellationCharges=@CancellationCharge,    
 CancellationRemark=@CancellationRemark    
 where BookingId=@Id    
     
END    

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_InsertNRITravelEnquire]  
 -- Add the parameters for the stored procedure here  
@namenri varchar(50),  
@reasonnri varchar(50),  
@emailnri varchar(100),  
@phonenri varchar(12),
@msgnri varchar(500)
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 INSERT INTO tbl_NRIEnquire 
           ([NameNri]  
           ,[EmailNri]  
           ,[PhoneNri] 
		   ,[ReasonNri]
		   ,[MessageNri]
           ,[InsertedDate])  
     VALUES  
           (@namenri 
           ,@emailnri  
           ,@phonenri 
		   ,@reasonnri
		   ,@msgnri
           ,GETDATE())  
END  

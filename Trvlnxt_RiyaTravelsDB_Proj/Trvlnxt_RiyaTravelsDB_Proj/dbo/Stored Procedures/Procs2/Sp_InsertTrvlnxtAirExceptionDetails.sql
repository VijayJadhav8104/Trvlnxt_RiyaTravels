CREATE PROCEDURE [dbo].[Sp_InsertTrvlnxtAirExceptionDetails]  
 @PageName varchar(100)=null,  
 @MethodName varchar(100)=null,  
 @RiyaPNR varchar(50)=null,  
 @ExceptionMessage varchar(max)=null,  
 @StackTrace varchar(max)=null,  
 @Details varchar(max)=null,
 @Source varchar(50)=null
AS  
BEGIN  
 Insert into [AllAppLogs].[dbo].TrvlnxtAir_mExceptionDetails(PageName,MethodName,RiyaPNR,ExceptionMessage,StackTrace,Details,ExceptionDate,Source)  
 values(@PageName,@MethodName,@RiyaPNR,@ExceptionMessage,@StackTrace,@Details,GetDate(),@Source)  
END  
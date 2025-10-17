
CREATE PROCEDURE [dbo].[Sp_Insertb2cExceptionDetails]
 @PageName varchar(100)=null,  
 @MethodName varchar(100)=null,  
 @ParameterList varchar(max)=null,  
 @GDSPNR varchar(50)=null,  
 @ExceptionMessage varchar(max)=null,  
 @StackTrace varchar(max)=null,  
 @Details varchar(max)=null  
AS  
BEGIN  
 Insert into [AllAppLogs].[dbo].b2cExceptionDetails(PageName,MethodName,ParameterList,GDSPNR,ExceptionMessage,StackTrace,Details,ExceptionDate)  
 values(@PageName,@MethodName,@ParameterList,@GDSPNR,@ExceptionMessage,@StackTrace,@Details,GetDate())  
END

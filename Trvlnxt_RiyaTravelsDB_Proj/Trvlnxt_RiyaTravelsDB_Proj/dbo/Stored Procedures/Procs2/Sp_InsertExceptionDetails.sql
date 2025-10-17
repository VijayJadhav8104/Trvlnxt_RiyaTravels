CREATE PROCEDURE [dbo].[Sp_InsertExceptionDetails]    
 @PageName varchar(100)=null,    
 @MethodName varchar(100)=null,    
 @ParameterList varchar(max)=null,    
 @GDSPNR varchar(50)=null,    
 @ExceptionMessage varchar(max)=null,    
 @StackTrace varchar(max)=null,    
 @Details varchar(max)=null,
 @Source varchar(50)=null 
AS    
BEGIN    
 Insert into [AllAppLogs].[dbo].mExceptionDetails(PageName,MethodName,ParameterList,GDSPNR,ExceptionMessage,StackTrace,Details,ExceptionDate,Source)    
 values(@PageName,@MethodName,@ParameterList,@GDSPNR,@ExceptionMessage,@StackTrace,@Details,GetDate(),@Source)    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_InsertExceptionDetails] TO [rt_read]
    AS [dbo];


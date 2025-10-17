CREATE PROCEDURE [dbo].[sp_tbltrackErrorLog]                 
 @ControllerName varchar(max)='',                 
 @ActionName varchar(max)='',                 
 @ErrorMessage varchar(max)='',                
 @StackTrace varchar(max)='',                 
 @ParameterList varchar(max)='',      
 @GDSPNR varchar(20) = '',     
 @Cid varchar(max)=null      
AS                
BEGIN                
                 
 Insert Into [AllAppLogs].[Dbo].tbltrackErrorLog (ControllerName,ActionName,ErrorMessage,StackTrace,ParameterList,UpdatedDate,Cid)                
Values  (@ControllerName,@ActionName,@ErrorMessage,@StackTrace,@ParameterList,GetDate(),@Cid)                
              
--added by bhavika              
Insert into [AllAppLogs].[Dbo].mExceptionDetails(PageName,MethodName,ParameterList,GDSPNR,ExceptionMessage,StackTrace,Details,ExceptionDate)              
 values(@ControllerName,@ControllerName,@ParameterList,@GDSPNR,@ErrorMessage,@StackTrace,'Amadeus',GetDate())              
                
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_tbltrackErrorLog] TO [rt_read]
    AS [dbo];


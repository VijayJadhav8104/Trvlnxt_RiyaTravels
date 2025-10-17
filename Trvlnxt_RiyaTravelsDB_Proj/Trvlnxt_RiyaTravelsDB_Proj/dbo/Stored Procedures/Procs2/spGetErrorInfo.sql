Create Proc [dbo].[spGetErrorInfo]
as
begin
insert into ExceptionLog(  
ErrorLine, ErrorMessage, ErrorNumber,  
ErrorProcedure, ErrorSeverity, ErrorState,  
DateErrorRaised  
)  
SELECT  
ERROR_LINE () as ErrorLine,  
Error_Message() as ErrorMessage,  
Error_Number() as ErrorNumber,  
Error_Procedure() as 'Proc',  
Error_Severity() as ErrorSeverity,  
Error_State() as ErrorState,  
GETDATE () as DateErrorRaised 
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetErrorInfo] TO [rt_read]
    AS [dbo];


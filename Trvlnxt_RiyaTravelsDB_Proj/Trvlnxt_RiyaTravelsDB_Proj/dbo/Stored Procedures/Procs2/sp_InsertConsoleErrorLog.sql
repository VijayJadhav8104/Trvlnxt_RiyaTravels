CREATE PROCEDURE sp_InsertConsoleErrorLog      
 @PageName varchar(100)=null,      
 @MethodName varchar(100)=null,  
 @GDSPNR varchar(50)=null,      
 @ExceptionMessage varchar(max)=null,   
 @Message varchar(max)=null,   
 @StackTrace varchar(max)=null,      
 @Details varchar(max)=null      
AS      
BEGIN      
 Insert into ConsoleErrorLog(PageName,MethodName,GDSPNR,ExceptionMessage,Message,StackTrace,Details,InsertedDate)      
 values(@PageName,@MethodName,@GDSPNR,@ExceptionMessage,@Message,@StackTrace,@Details,GetDate())      
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_InsertConsoleErrorLog] TO [rt_read]
    AS [dbo];


CREATE Procedure SP_InsertKibanaExceptionLog  
@TrackId varchar(255)=null,  
@MethodName varchar(255)=null,  
@LogType varchar(255)=null,  
@FlightKey varchar(255)=null,  
@ErrorMessage Varchar(255)=null,  
@StackTrace varchar(255)=null,  
@MethodRequest varchar(max)  
AS  
BEGIN  
  
INSERT INTO KibanaExceptions(TrackId,MethodName,LogType,FlightKey,ErrorMessage,StackTrace,InsertedDate,MethodRequest)   
Values(ISNULL(@TrackId,''),ISNULL(@MethodName,''),ISNULL(@LogType,''),ISNULL(@FlightKey,''),ISNULL(@ErrorMessage,''),ISNULL(@StackTrace,''),getdate(),ISNULL(@MethodRequest,''))  
  
END 
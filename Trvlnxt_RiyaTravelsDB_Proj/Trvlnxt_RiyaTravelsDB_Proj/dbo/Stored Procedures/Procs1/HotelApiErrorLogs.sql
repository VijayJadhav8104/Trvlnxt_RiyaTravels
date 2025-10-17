  
CREATE PROCEDURE [dbo].[HotelApiErrorLogs]      
 -- Add the parameters for the stored procedure here                
 @API_Name VARCHAR(50) = NULL      
 ,@Controller_Name VARCHAR(50) = NULL      
 ,@Method_Name VARCHAR(50) = NULL      
 ,@Supplier_Name VARCHAR(50) = NULL      
 ,@Api_RequestUrl VARCHAR(max) = NULL      
 ,@Api_Response VARCHAR(max) = NULL      
 ,@Search_Request VARCHAR(max) = NULL      
 ,@Id INT OUTPUT      
 ,@Action VARCHAR(50) = NULL      
 ,@LoginSessionID VARCHAR(100) = NULL      
 ,@UniqueSearchID VARCHAR(100) = NULL      
 ,@AgentID VARCHAR(50) = NULL      
 ,@MainAgentID VARCHAR(50) = NULL      
AS      
BEGIN      
 IF (@Action = 'Insert')      
 BEGIN      
  INSERT INTO [AllAppLogs].[dbo].HotelB2BRequestResponseLogs (      
   API_Name      
   ,Controller_Name      
   ,Method_Name      
   ,Supplier_Name      
   ,Api_RequestUrl      
   ,Api_Response      
   ,Search_Request      
   --,UniqueSearchID          
   ,LoginSessionID         
   ,AgentID  
   ,MainAgentID  
   )      
  VALUES (      
   @API_Name      
   ,@Controller_Name      
   ,@Method_Name      
   ,@Supplier_Name      
   ,@Api_RequestUrl      
   ,@Api_Response      
   ,@Search_Request      
   --,@UniqueSearchID 
   ,@MainAgentID
   ,@AgentID       
   ,@MainAgentID   
   )      
      
  SET @Id = SCOPE_IDENTITY()      
      
  RETURN @Id      
 END   
 
 ELSE IF (@Action = 'Update')      
 BEGIN      
  UPDATE [AllAppLogs].[dbo].HotelB2BRequestResponseLogs      
  SET Api_Response = @Api_Response       
   ,UniqueSearchID=@UniqueSearchID     
  WHERE Id = @Id      
 END      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelApiErrorLogs] TO [rt_read]
    AS [dbo];


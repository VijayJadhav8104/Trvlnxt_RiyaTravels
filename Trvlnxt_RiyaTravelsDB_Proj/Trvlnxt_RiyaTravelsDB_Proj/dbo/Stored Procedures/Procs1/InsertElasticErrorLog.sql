
CREATE PROCEDURE [dbo].[InsertElasticErrorLog]  
    @ErrorMsg VARCHAR(max) =null,  
    @LogDate DATETIME =null,  
    @ApiCallInfo VARCHAR(max)=null,  
    @LogStatus BIT=null ,
	@RequestData varchar(max)=null,
	@ResponseData varchar(max)=null,
	@ProjectName varchar(100)=null
AS  
BEGIN  
    -- Insert the data into the ElasticErrorLogs table  
    INSERT INTO ElasticErrorLogs (ErrorMsg, LogDate, ApiCallInfo, LogStatus,RequestData,ResponseData, ProjectName)  
    VALUES (@ErrorMsg, getdate(), @ApiCallInfo, @LogStatus,@RequestData,@ResponseData,@ProjectName);  
  
    -- Optionally, you can return the Id of the newly inserted record (if needed)  
   -- SELECT SCOPE_IDENTITY() AS NewRecordId;  
END  
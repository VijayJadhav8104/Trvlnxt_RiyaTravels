-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Hotel].[sp_insertCachingApiLogs] 

@PNR varchar(50),
           @requestURL varchar(max),
           @inputString varchar(max),
           @outputString varchar(max),
           @MethodName varchar(50),
           @startTime datetime,
           @endTime datetime
        
AS
BEGIN
	
INSERT INTO [Hotel].[CachingApiLogs]
           ([PNR]
           ,[requestURL]
           ,[inputString]
           ,[outputString]
           ,[MethodName]
           ,[startTime]
           ,[endTime]
           ,[CreatedDate])
     VALUES
           (
		   @PNR,
           @requestURL,
           @inputString,
           @outputString,
           @MethodName,
           @startTime ,
           @endTime,
		   GETDATE()
		   )

		    Select SCOPE_IDENTITY()


END

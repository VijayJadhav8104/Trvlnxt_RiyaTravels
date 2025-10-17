CREATE PROCEDURE [dbo].[GetPNRRetrivalFromAudit_TJQFailed]  --'01-May-2023','22-May-2023','4','DXBAD3359,DXBDN3110'
	@fromDate varchar(50) = '' --'2022-06-03'                                                        
	, @todate varchar(50) ='' --'2022-06-04'                                                        
	, @Status varchar(10) = ''                                   
	, @OfficeIDList varchar(max)=''                    
AS
BEGIN
	SELECT ID
			, GDSPNR
			, OfficeID
			, ICust
			, InsertedOn
			, FORMAT(CONVERT(DATE, IssueDate), 'dd-MMM-yyyy') AS IssueDate
			, IsBookMasterInserted
			, IsBookMasterInsertedOn
			, AirLineNumber
			, TicketNumber
			, ErrorMessage
			, EmpID
			, (SELECT EmployeeNo 
					FROM mUser WITH(NOLOCK)
					WHERE Convert(varchar(10), id) = aud.MainAgentId) AS PushedBy
			, QueueNo
			, (SELECT GroupId 
					FROM agentLogin WITH(NOLOCK)
					WHERE UserID IN (SELECT TOP 1 FKUserID 
										FROM B2BRegistration WITH(NOLOCK)
										WHERE ICust=AUD.ICust ORDER BY PKID DESC)
										) AS Groupid        
	FROM PNRRetrivalFromAudit AS aud WITH(NOLOCK)
	WHERE IsBookMasterInserted != 1 AND (ErrorMessage != null OR ErrorMessage != '')                  
	AND CONVERT(DATE, IssueDate) BETWEEN @fromDate AND @todate              
	AND ((@OfficeIDList = '') OR (OfficeID IN  ( SELECT Data FROM sample_split(@OfficeIDList, ','))))                   
	AND ErrorMessage != 'AlreadyExistInDB'
	AND ErrorMessage != 'WNS PNR'              
	AND SUBSTRING(TicketNumber, 1, 10) NOT IN (              
	
	Select SUBSTRING(pass.TicketNumber, 1, 10)
	FROM tblPassengerBookDetails AS pass WITH(NOLOCK) 
	INNER JOIN tblBookMaster AS book WITH(NOLOCK) on pass.fkBookMaster = book.pkId                   
	WHERE book.BookingStatus = '1'
	AND book.IsBooked = '1'
	AND book.GDSPNR = aud.GDSPNR                   
	AND SUBSTRING(pass.TicketNumber, 1, 10) = SUBSTRING(aud.TicketNumber, 1, 10)                  
 )                 
               
 --SELECT ID,GDSPNR,OfficeID,ICust,InsertedOn,IsBookMasterInserted,IsBookMasterInsertedOn,AirLineNumber,TicketNumber,ErrorMessage,EmpID                            
 --FROM PNRRetrivalFromAudit as aud WHERE IsBookMasterInserted != 1 AND (ErrorMessage != null OR ErrorMessage != '')                  
 --AND CONVERT(DATE,InsertedOn) BETWEEN @fromDate AND @todate                      
 --AND ((@OfficeIDList = '') OR (OfficeID IN  ( SELECT Data FROM sample_split(@OfficeIDList,','))))                   
 --AND ErrorMessage != 'AlreadyExistInDB'                  
 --AND SUBSTRING(TicketNumber,1,10) NOT IN (                  
                  
 --Select SUBSTRING(pass.TicketNumber,1,10) From tblPassengerBookDetails as pass inner join tblBookMaster as book on pass.fkBookMaster = book.pkId                   
 -- WHERE book.BookingStatus = '1'AND book.IsBooked = '1'AND book.GDSPNR = aud.GDSPNR                   
 --    AND SUBSTRING(pass.TicketNumber,1,10) = SUBSTRING(aud.TicketNumber,1,10)                  
 --)                  
 --declare @temp1 table (ID int identity(1,1) ,GDSPNR varchar(10),OfficeID  varchar(50),ICust varchar(50),InsertedOn datetime,IsBookMasterInserted int,IsBookMasterInsertedOn datetime,AirLineNumber varchar(10),TicketNumber varchar(50),ErrorMessage varchar(MAX));                  
 --declare @temp2 table (ID int,GDSPNR varchar(10),OfficeID  varchar(50),ICust varchar(50),InsertedOn datetime,IsBookMasterInserted int,IsBookMasterInsertedOn datetime,AirLineNumber varchar(10),TicketNumber varchar(50),ErrorMessage varchar(MAX));         
  
    
      
        
         
                  
 --insert @temp1                  
 --SELECT GDSPNR,OfficeID,ICust,InsertedOn,IsBookMasterInserted,IsBookMasterInsertedOn,AirLineNumber,TicketNumber,ErrorMessage                            
 --FROM PNRRetrivalFromAudit  WHERE IsBookMasterInserted != 1 AND (ErrorMessage != null OR ErrorMessage != '')                  
 --AND CONVERT(DATE,InsertedOn) BETWEEN @fromDate AND @todate                      
 --AND ((@OfficeIDList = '') OR (OfficeID IN  ( SELECT Data FROM sample_split(@OfficeIDList,','))))                   
                  
 --DECLARE @cnt INT = 1;                  
 --WHILE @cnt <= (SELECT count(*) FROM @temp1)                  
 --BEGIN                  
                     
 --   declare @GDSPNR varchar(10);                  
 --   declare @TicketNumber varchar(50);                  
 --   declare @riyaPNR varchar(10);                  
 --   SELECT @GDSPNR = GDSPNR,@TicketNumber = TicketNumber FROM @temp1 WHERE ID = @cnt         
                    
 --    set @riyaPNR = (Select top 1 isnull(riyaPNR,'') From tblPassengerBookDetails AS pass inner join tblBookMaster AS book on pass.fkBookMaster = book.pkId                   
 -- WHERE book.BookingStatus = '1'AND book.IsBooked = '1'AND book.GDSPNR = @GDSPNR                   
 --    AND (pass.TicketNumber like '%'+@TicketNumber+'%' OR pass.ticketNum like '%'+@TicketNumber+'%'))                  
                    
                  
 --   if @riyaPNR = '' OR @riyaPNR = 'NULL' OR @riyaPNR is null OR @riyaPNR = NULL                  
 --   begin                  
 --      insert into @temp2                  
 --   SELECT * FROM @temp1 WHERE ID = @cnt                  
 --   end                  
 --   SET @cnt = @cnt + 1;                  
 --END                  
 -- SELECT * FROM @temp2                  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPNRRetrivalFromAudit_TJQFailed] TO [rt_read]
    AS [dbo];


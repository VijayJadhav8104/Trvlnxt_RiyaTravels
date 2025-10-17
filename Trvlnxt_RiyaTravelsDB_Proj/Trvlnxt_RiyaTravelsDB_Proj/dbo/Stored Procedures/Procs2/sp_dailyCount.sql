-- =============================================
-- Author:		<Jishaan.S>
-- Create date: <13-12-2022>
-- Description:	<Daily Count Report>
-- =============================================
CREATE PROCEDURE [dbo].[sp_dailyCount]
AS
BEGIN
		select Count(PB.TicketNumber) as 'USA Count', 'Retrive PNR' as 'Names' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'Retrive PNR'
		and AL.Country = 'USA'
		and AL.userTypeID=2
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'TJQ Count', 'GDS' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'GDS'
		and AL.userTypeID=2
		and AL.Country = 'USA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'Book Count', 'Web' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'Web'
		and AL.userTypeID=2
		and AL.Country = 'USA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'Book Count', 'Retrive PNR accounting' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and AL.userTypeID=2
		and LOWER(BM.BookingSource) = 'retrive pnr accounting'
		and AL.Country = 'USA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1

		-------------------------------------------------------------------------------------

		select Count(PB.TicketNumber) as 'CANADA Count', 'Retrive PNR' as 'Names' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'Retrive PNR'
		and AL.Country = 'CANADA'
		and AL.userTypeID=2
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'TJQ Count', 'GDS' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'GDS'
		and AL.userTypeID=2
		and AL.Country = 'CANADA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'Book Count', 'Web' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and BM.BookingSource = 'Web'
		and AL.userTypeID=2
		and AL.Country = 'CANADA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1
		union
		select Count(PB.TicketNumber) as 'Book Count', 'Retrive PNR accounting' as 'Name' from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PB on PB.fkBookMaster = BM.pkId
		LEFT JOIN agentLogin AL on AL.UserID = BM.AgentID
		where IsBooked = 1 
		and BM.totalFare > 0
		and AL.userTypeID=2
		and LOWER(BM.BookingSource) = 'retrive pnr accounting'
		and AL.Country = 'CANADA'
		and DATEDIFF(day, CONVERT(date,IssueDate), CONVERT(date,GETDATE())) = 1

		---------------------------------------------------------------------------------
				SELECT COUNT(PRFA.TicketNumber) AS NoOfTickets    
		   ,'USA' as Country    
		   ,'2' as UserTypeId
		   ,'GDS Fail' as Remark
		   from PNRRetrivalFromAudit as PRFA
		   where PRFA.IsBookMasterInserted != 1
		   AND (PRFA.ErrorMessage != null or PRFA.ErrorMessage != '')  
		   AND (CONVERT(DATE, PRFA.IssueDate) >= convert(DATE, GETDATE()-1))    
		   AND (CONVERT(DATE, PRFA.IssueDate) <= convert(DATE, GETDATE()-1))
		   AND PRFA.ErrorMessage != 'AlreadyExistInDB'
		   AND PRFA.OfficeID IN ('DFW1S212A','A1FH')
		   AND SUBSTRING(TicketNumber,1,10) not in (        
		Select SUBSTRING(pass.TicketNumber,1,10) From tblPassengerBookDetails as pass inner join tblBookMaster as book on pass.fkBookMaster = book.pkId            
		where book.BookingStatus = '1'and book.IsBooked = '1'and book.GDSPNR = PRFA.GDSPNR            
		and SUBSTRING(pass.TicketNumber,1,10) = SUBSTRING(PRFA.TicketNumber,1,10))          

		   union

		   SELECT COUNT(PRFA.TicketNumber) AS NoOfTickets    
		   ,'CANADA' as Country    
		   ,'2' as UserTypeId
		   ,'GDS Fail' as Remark
		   from PNRRetrivalFromAudit as PRFA
		   where PRFA.IsBookMasterInserted != 1
		   AND (PRFA.ErrorMessage != null or PRFA.ErrorMessage != '')  
		   AND (CONVERT(DATE, PRFA.IssueDate) >= convert(DATE, GETDATE()-1))    
		   AND (CONVERT(DATE, PRFA.IssueDate) <= convert(DATE, GETDATE()-1))
		   AND PRFA.ErrorMessage != 'AlreadyExistInDB'
		   AND PRFA.OfficeID IN ('YWGC4211G','C0KH')
		   AND SUBSTRING(TicketNumber,1,10) not in (        
		Select SUBSTRING(pass.TicketNumber,1,10) From tblPassengerBookDetails as pass inner join tblBookMaster as book on pass.fkBookMaster = book.pkId            
		where book.BookingStatus = '1'and book.IsBooked = '1'and book.GDSPNR = PRFA.GDSPNR            
		and SUBSTRING(pass.TicketNumber,1,10) = SUBSTRING(PRFA.TicketNumber,1,10))  
             
       
		   union

		   SELECT COUNT(PB.TicketNumber) AS NoOfTickets    
		   ,AL.Country    
		   ,AL.UserTypeId  
		   ,'Trvlnxt Fail' as Remark
		  FROM [RiyaTravels].[dbo].tblPassengerBookDetails PB    
		  LEFT JOIN [RiyaTravels].[dbo].tblBookMaster BM ON PB.fkBookMaster = BM.pkId    
		  LEFT JOIN [RiyaTravels].[dbo].agentLogin AL ON BM.AgentID = AL.UserID    
		  LEFT JOIN [RiyaTravels].[dbo].PNRRetriveDetails PR ON PR.OrderID = BM.orderId    
		  WHERE BM.AgentID != 'B2C'    
		   AND BM.IsBooked = 0  and (TicketIssuanceError != '' OR TicketIssuanceError != null )
		   AND BM.totalFare > 0    
		   AND (CONVERT(DATE, BM.IssueDate) >= convert(DATE, GETDATE()-1))    
		   AND (CONVERT(DATE, BM.IssueDate) <= convert(DATE, GETDATE()-1))    
		   AND (    
			AL.Country = 'CANADA'
			OR AL.Country = 'USA'    
			)    
		AND AL.UserTypeId = 2  
		and BM.BookingSource IN ('GDS')  
		  GROUP BY AL.Country    
		   ,AL.UserTypeId
END




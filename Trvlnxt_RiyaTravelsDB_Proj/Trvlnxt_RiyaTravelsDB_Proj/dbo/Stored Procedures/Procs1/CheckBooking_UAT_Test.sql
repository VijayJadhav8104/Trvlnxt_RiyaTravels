CREATE proc [dbo].[CheckBooking_UAT_Test]  
@FlightNo varchar(10)  
,@Airline varchar(10)  
,@PassangerFName nvarchar(20)  
,@PassangerLName nvarchar(20)  
,@Passport_No nvarchar(50)=null  
,@DateOfTravel Datetime  
,@FromSector  nvarchar(10)  
,@ToSectore nvarchar(10)  
,@FlightNumWithStop varchar(MAX) = ''
  
  
As  
Begin  
   DECLARE @Counter INT = 1
   DECLARE @FlightNum VARCHAR(30)
   DECLARE @sQeury VARCHAR(MAX)
   Declare @strCounter varchar(5)
   Declare @fkMainId varchar(30)


	DECLARE CUR_CheckBookingDetails CURSOR 
	FOR SELECT data FROM sample_split(@FlightNumWithStop,',')
	OPEN CUR_CheckBookingDetails;
	FETCH NEXT FROM CUR_CheckBookingDetails INTO @FlightNum    
	WHILE @@FETCH_STATUS = 0
	    BEGIN	
		SET @strCounter = CONVERT(VARCHAR(5),@Counter)
			
			IF(@Counter = 1)
			BEGIN
				set @sQeury = 'SELECT vw_s1.fkBookMaster FROM (select tbi.fkBookMaster from tblBookItenary tbi inner join tblbookmaster tbm on tbi.fkBookMaster=tbm.pkid 
				where LTRIM(RTRIM(tbi.flightNo)) ='''+ LTRIM(RTRIM(@FlightNum)) +''' and (tbm.BookingStatus=6 or tbm.BookingStatus=1)) AS vw_s1'
			END
			ELSE			
			BEGIN
				SET @sQeury = @sQeury +' inner join 
				(SELECT vw_s'+@strCounter+'.*
				FROM (select tbi.fkBookMaster from tblBookItenary tbi inner join tblbookmaster tbm on tbi.fkBookMaster=tbm.pkid
				where LTRIM(RTRIM(tbi.flightNo))='''+  LTRIM(RTRIM(@FlightNum)) +''' and (tbm.BookingStatus=6 or tbm.BookingStatus=1)) AS vw_s'+@strCounter+') as vw_p'+@strCounter+'
				on vw_s1.fkBookMaster=vw_p'+@strCounter+'.fkBookMaster'
			END
			SET @Counter = @Counter + 1
			FETCH NEXT FROM CUR_CheckBookingDetails INTO @FlightNum
	    END;

		
	print(@sQeury)
	CLOSE  CUR_CheckBookingDetails;
	DEALLOCATE CUR_CheckBookingDetails;

	DECLARE @MainRecord TABLE (fkBookId varchar(10))
	INSERT @MainRecord 
	EXEC (@sQeury)
	SET @fkMainId =(SELECT TOP 1 fkBookId FROM @MainRecord order by fkBookId desc)
	print(@fkMainId)
SELECT 
	CONCAT(PBD.paxFName,' ',PBD.paxLName,',',BI.frmSector,',',BI.toSector,',',BM.riyaPNR,',',BM.BookingSource) AS Details  
FROM 
	tblBookMaster BM 
	JOIN tblPassengerBookDetails PBD ON PBD.fkBookMaster = BM.pkId 
		AND PBD.paxFName = @PassangerFName  AND PBD.paxLName = @PassangerLName 
		AND (@Passport_No = '' OR @Passport_No is NULL OR PBD.passportNum=@Passport_No OR PBD.passportNum IS NULL) 
	JOIN tblBookItenary BI ON BI.fkBookMaster = BM.pkId
WHERE 
	--BM.pkId = @fkMainId AND
	(@FlightNumWithStop = '' OR LTRIM(RTRIM(BI.flightNo)) IN(select data from sample_split(@FlightNumWithStop,',')))
	AND BM.airCode = @Airline 
	AND BM.frmSector = @fromSector 
	AND BM.toSector = @ToSectore  
	AND CONVERT(DATETIME, CONVERT(VARCHAR(10), BM.depDate, 102)) = CONVERT(DATETIME,CONVERT(VARCHAR(10),@DateOfTravel,102))
	AND LTRIM(RTRIM(BM.flightNo)) = LTRIM(RTRIM(@FlightNo)) 
	AND (BM.BookingStatus=6 or BM.BookingStatus=1) 
	AND BM.GDSPNR IS NOT NULL



 --select CONCAT(p.paxFName,' ',p.paxLName,',',b.frmSector,',',b.toSector,',',b.GDSPNR) as 'Details' from   
 --tblBookMaster b   
 --join   
 --tblPassengerBookDetails p   
 --on b.pkId=p.fkBookMaster   
 --where  LTRIM(RTRIM(b.flightNo))= LTRIM(RTRIM(@FlightNo))
 --and b.airCode=@Airline   
 --and p.paxFName=@PassangerFName   
 --and p.paxLName=@PassangerLName   
 --and b.frmSector=@fromSector  
 --and b.toSector=@ToSectore  
 --and convert(datetime, convert(varchar(10), b.depDate, 102))  = convert(datetime,convert(varchar(10),@DateOfTravel,102))  
 --and (p.passportNum=@Passport_No or p.passportNum is null)  
 --and (b.IsBooked=1 or b.BookingStatus=2)  
 --and GDSPNR is not null  
  
End  
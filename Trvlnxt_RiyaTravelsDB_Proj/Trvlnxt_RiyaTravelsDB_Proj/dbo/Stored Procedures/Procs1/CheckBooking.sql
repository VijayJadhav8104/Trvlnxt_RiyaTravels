CREATE proc [dbo].[CheckBooking]    
@FlightNo varchar(10)    
,@Airline varchar(10)    
,@PassangerFName nvarchar(20)    
,@PassangerLName nvarchar(20)    
,@Passport_No nvarchar(50)=null    
,@DateOfTravel Datetime    
,@FromSector  nvarchar(10)    
,@ToSectore nvarchar(10)    
    
    
As    
Begin    
     
 select CONCAT(p.paxFName,' ',p.paxLName,',',b.frmSector,',',b.toSector,',',b.GDSPNR) as 'Details' from     
 tblBookMaster b     
 join     
 tblPassengerBookDetails p     
 on b.pkId=p.fkBookMaster     
 where  LTRIM(RTRIM(b.flightNo))= LTRIM(RTRIM(@FlightNo))     
 and b.airCode=@Airline     
 and p.paxFName=@PassangerFName     
 and p.paxLName=@PassangerLName     
 and b.frmSector=@fromSector    
 and b.toSector=@ToSectore    
 and convert(datetime, convert(varchar(10), b.depDate, 102))  = convert(datetime,convert(varchar(10),@DateOfTravel,102))    
 and (p.passportNum=@Passport_No)    
 and (b.IsBooked=1 or b.BookingStatus=2)  and GDSPNR is not null    
    
End  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckBooking] TO [rt_read]
    AS [dbo];


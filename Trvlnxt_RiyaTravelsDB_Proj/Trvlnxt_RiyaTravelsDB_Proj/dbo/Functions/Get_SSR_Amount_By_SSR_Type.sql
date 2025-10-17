--select (dbo.Get_SSR_Amount_By_SSR_Type ('XM2E61','Baggage',123,'ADULT','TEST ADT','TEST'))    
--select (dbo.Get_SSR_Amount_By_SSR_Type ('M81W3H','Seat',882,'ADULT','ARUN VIVIAN','CRASTA'))    
--select (dbo.Get_SSR_Amount_By_SSR_Type ('N12AS5','Baggage',0,'ADULT','TEST ADT','TEST'))    
    
CREATE FUNCTION  [dbo].[Get_SSR_Amount_By_SSR_Type] (    
 @RiyaPNR varchar(50),    
 @SSRType Varchar(50),    
 @TotalFare Decimal(18,2),    
 @paxType Varchar(20),    
 @paxFname Varchar(500),    
 @paxLname Varchar(500),
 @TicketNumber Varchar(200)
)    
RETURNS Decimal(18,2) AS    
BEGIN    
     
 Declare @SSRAmount decimal(18,2)    
    
 if(@TotalFare>0)    
 BEGIN    
  if(exists(select 1 from tblBookMaster where riyaPNR=@RiyaPNR and totalFare = 0))    
  BEGIN    
   select @SSRAmount = sum(SSR_Amount)    
   from tblSSRDetails s    
   inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid --and p.pid=pax.pid    
   inner join tblBookMaster b on b.pkId= p.fkBookMaster    
   where b.riyaPNR=@RiyaPNR     
   and SSR_Type=@SSRType     
   and s.SSR_Status=1     
   and SSR_Amount>0     
   and paxType=@paxType     
   and paxFName=@paxFname    
   and paxLName=@paxLname     
   --group by p.fkBookMaster, fkPassengerid, SSR_Type    
  END    
  ELSE     
  BEGIN    
   select @SSRAmount = sum(SSR_Amount)    
   from tblSSRDetails s    
   inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid --and p.pid=pax.pid    
   inner join tblBookMaster b on b.pkId= p.fkBookMaster    
   where b.riyaPNR=@RiyaPNR     
   and SSR_Type=@SSRType     
   and s.SSR_Status=1     
   and SSR_Amount>0     
   and paxType=@paxType     
   and paxFName=@paxFname    
   and paxLName=@paxLname
   and p.TicketNumber = @TicketNumber
   group by p.fkBookMaster, fkPassengerid, SSR_Type,p.TicketNumber    
  END    
 END    
 ELSE    
 BEGIN    
  select @SSRAmount = --CASE WHEN @TotalFare > 0 THEN max(SSR_Amount) ELSE sum(SSR_Amount) END    
  sum(SSR_Amount)     
  from tblSSRDetails s    
  inner join tblPassengerBookDetails p on p.pid=s.fkPassengerid --and p.pid=pax.pid    
  inner join tblBookMaster b on b.pkId= p.fkBookMaster    
  where b.riyaPNR=@RiyaPNR     
  and SSR_Type=@SSRType     
  and s.SSR_Status=1     
  and SSR_Amount>0     
  and paxType=@paxType     
  and paxFName=@paxFname    
  and paxLName=@paxLname 
  and p.TicketNumber = @TicketNumber
  group by p.paxType,p.paxFName,p.paxLName,p.TicketNumber    
 END    
    RETURN @SSRAmount    
END
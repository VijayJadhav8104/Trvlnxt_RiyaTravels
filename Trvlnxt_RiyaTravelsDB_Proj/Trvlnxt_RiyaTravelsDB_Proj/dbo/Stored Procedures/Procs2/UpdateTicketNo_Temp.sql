CREATE PROCEDURE [dbo].[UpdateTicketNo_Temp] --exec UpdateTicketNo 433762 , '0983906290519C1' , '','','0' ,'1'                           
@PaxId      int,                             
@ticketNum varchar(80),                             
@FullTicketNumber varchar(80)=null,                             
@VendorCommission   varchar(80)=null,                             
@VendorCommissionText  varchar(80)=null,                             
@IsSabre bit =0 ,                             
@IsGalileo bit =0,                             
@McoTicketNumber varchar(20)=null,                             
@MCOAmount decimal(18,0)=0.0,                              
@baggage varchar(300)=null,                    
@IssueDate datetime= null,                        
@AirlineName varchar(100) = null,
@PaxFMCommission decimal(18,2)=0.0 ,
@IsUpdateFMCommission bit =0      
AS                             
BEGIN                               
 declare @newticketno varchar(50)            
 if(@FullTicketNumber is null or @FullTicketNumber='' or @FullTicketNumber = 'null')      
 begin      
  set @FullTicketNumber=@ticketNum      
 end      
      
IF(@IsGalileo =1)                          
 BEGIN                          
 declare @spltticketno varchar(50)                       
  set @newticketno=SUBSTRING(@ticketNum,4,13)                             
  set @spltticketno=SUBSTRING(@ticketNum,1,3)                             
  set @ticketNum= @spltticketno +'-'+  @newticketno                         
 END                          
 ELSE IF(@IsSabre =0)                              
 BEGIN                              
  if(len(@ticketNum) > 20)                               
  begin                               
   set @newticketno=SUBSTRING(@ticketNum,9,10)                               
  end                              
  else if(len(@ticketNum)=15 or len(@ticketNum)=13)                               
  begin                               
  set @newticketno=SUBSTRING(@ticketNum,4,10)      
        
   IF(@AirlineName = 'FlyEgypt') --FlyEgypt      
   BEGIN      
    --SET @ticketNum = @ticketNum      
    SET @newticketno = SUBSTRING(@ticketNum,4,13)                               
    SET @spltticketno = SUBSTRING(@ticketNum,1,3)                               
    SET @ticketNum = @spltticketno + '-' +  @newticketno      
   END      
   ELSE IF(@AirlineName = 'FitsAir')      
   BEGIN      
    SET @newticketno = SUBSTRING(@ticketNum,4,13)                               
    SET @spltticketno = SUBSTRING(@ticketNum,1,3)                               
    SET @ticketNum = @spltticketno + '-' +  @newticketno      
   END      
   ELSE      
   BEGIN      
    set @ticketNum=SUBSTRING(@ticketNum,4,10)      
   END      
  end                              
  else if(len(@ticketNum)=14)                               
  begin                               
  set @newticketno=SUBSTRING(@ticketNum,5,10)                                  
  end                              
  else if(len(@ticketNum)=17)                               
  begin                               
  set @newticketno=SUBSTRING(@ticketNum,5,13)                                  
  end               
  else            
  begin                               
  set @newticketno=@ticketNum                               
  end            
 END                              
 ELSE                              
 BEGIN                              
  set @newticketno=@ticketNum                              
 END     
  
if (@IsUpdateFMCommission=1)
begin
UPDATE tblPassengerBookDetails 
SET ticketNum = @FullTicketNumber,TicketNumber=@newticketno,MCOAmount=@MCOAmount,   MCOTicketNo=@McoTicketNumber,FMCommission=@PaxFMCommission
, baggage = case when @baggage is not null AND @baggage <> '' then @baggage else baggage end   WHERE pid = @PaxId   
       
end
else
begin
UPDATE tblPassengerBookDetails 
SET ticketNum = @FullTicketNumber,TicketNumber=@newticketno,MCOAmount=@MCOAmount,   MCOTicketNo=@McoTicketNumber
, baggage = case when @baggage is not null AND @baggage <> '' then @baggage else baggage end   WHERE pid = @PaxId   
       
end
    
                        
declare @BookingId int      
       
Select @BookingId = [fkBookMaster] from tblPassengerBookDetails WITH (NOLOCK) where pid = @PaxId       
       
declare @mainAgentID int        
       
Select @mainAgentID = MainAgentId  from tblBookMaster  WITH (NOLOCK) where pkId = @BookingId           
         
if exists(select * from tblBookMaster WITH (NOLOCK) where (BookingSource like '%Retrive%' OR BookingSource = 'GDS') and pkId=@BookingId)                     
begin    
 IF(@IssueDate IS NULL)          
 BEGIN           
  set @IssueDate=(select inserteddate from tblBookMaster WITH (NOLOCK) where pkId=@BookingId)          
 END          
end            
else           
begin           
 set @IssueDate=GETDATE()           
end         
           
DECLARE @InsertedDateYear Int      
      
SELECT @InsertedDateYear = DATEPART(YEAR, inserteddate) FROM tblBookMaster WHERE pkId = @BookingId        
      
IF (@InsertedDateYear >= DATEPART(YEAR, GETDATE()))      
BEGIN      
 Update tblBookMaster set IsBooked = 1,VendorCommissionPercent=@VendorCommission,   VendorCommissionText= @VendorCommissionText, BookingStatus=1,      
 IssueDate=@IssueDate,IssueBy=@mainAgentID where pkId = @BookingId        
  END      
END
CREATE PROCEDURE [dbo].[API_UpdateTicketNo] --exec UpdateTicketNo 433762 , '0983906290519C1' , '','','0' ,'1'                           
@PaxId int,      
@ticketNumber varchar(80) = '',         
@ticketNum varchar(80) = '',                             
@VendorCommission varchar(80)= '',                             
@VendorCommissionText varchar(80)= '',                             
@VendorName varchar(80)= '',      
@McoTicketNumber varchar(20)= '',                             
@MCOAmount decimal(18,0)=0.0,                  
@IssueDate datetime= null      
                            
AS                             
BEGIN       
      
 declare @newticketno varchar(50)         
       
 IF(@VendorName = 'Amadeus')      
  BEGIN                              
    if(len(@ticketNumber) > 20)                               
    begin                               
   set @newticketno=SUBSTRING(@ticketNumber,9,10)                               
    end           
     else if(len(@ticketNumber)=14)                               
    begin                               
   set @newticketno=SUBSTRING(@ticketNumber,5,10)                                  
    end       
    else if(len(@ticketNumber)=15 or len(@ticketNumber)=13)                               
    begin                               
   set @newticketno=SUBSTRING(@ticketNumber,4,10)                               
   set @ticketNumber=SUBSTRING(@ticketNumber,4,10)                               
    end                         
    else if(len(@ticketNumber)=17)                               
    begin                               
   set @newticketno=SUBSTRING(@ticketNumber,5,13)                                  
    end               
    else            
    begin                               
   set @newticketno=@ticketNumber                               
    end            
    END                              
   ELSE                              
    BEGIN                              
    set @newticketno=@ticketNumber                              
    END            
          
 UPDATE tblPassengerBookDetails SET ticketNum = @ticketNum,TicketNumber=@newticketno,MCOAmount=@MCOAmount,MCOTicketNo=@McoTicketNumber  WHERE pid = @PaxId             
                      
 declare @BookingId int                     
 Select @BookingId = [fkBookMaster] from tblPassengerBookDetails with (nolock) where pid = @PaxId        
       
  declare @AgentID int                               
   Select @AgentID = AgentID  from tblBookMaster with (nolock) where pkId = @BookingId       
              
 Update tblBookMaster set IsBooked = 1,BookingStatus=1,IssueDate=@IssueDate,HoldBookingDate = @IssueDate ,
 VendorCommissionPercent=@VendorCommission,   VendorCommissionText= @VendorCommissionText,IssueBy=@AgentID   where pkId = @BookingId                             
        
 END 
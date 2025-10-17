CREATE PROCEDURE [dbo].[UpdateTicketNoB2C] --exec UpdateTicketNo 433762 , '0983906290519C1' , '','','0' ,'1'                     
@PaxId      int,                       
@ticketNum varchar(80),                       
@VendorCommission   varchar(80)=null,                       
@VendorCommissionText  varchar(80)=null,                       
@IsSabre bit =0 ,                       
@IsGalileo bit =0,                       
@McoTicketNumber varchar(20)=null,                       
@MCOAmount decimal(18,0)=0.0,                        
@baggage varchar(300)=null,              
@IssueDate datetime= null                  
                      
AS                       
BEGIN                         
 declare @newticketno varchar(50)                        
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
  set @ticketNum=SUBSTRING(@ticketNum,4,10)                         
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
   UPDATE tblPassengerBookDetails SET ticketNum = @ticketNum,TicketNumber=@newticketno,MCOAmount=@MCOAmount,   MCOTicketNo=@McoTicketNumber, baggage = case when @baggage <> null AND @baggage <> '' then @baggage else baggage end   WHERE pid = @PaxId       
                
   declare @BookingId int               
   Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId                         
   declare @mainAgentID int                         
   Select @mainAgentID = MainAgentId  from tblBookMaster where pkId = @BookingId     
     
 --  declare @UserType int    
 --  declare @AgentID int    
 --  Select @AgentID = AgentID  from tblBookMaster where pkId = @BookingId 
   
 -- -- IF(@AgentID!='B2C')    
 -- --BEGIN 
	--select @UserType = userTypeID from agentLogin where UserID = @AgentID    

	--if(@UserType != 3)    
	--begin    
	--set @IssueDate=@IssueDate           
	--end    
	----END
	Update tblBookMaster set IsBooked = 1,VendorCommissionPercent=@VendorCommission,   VendorCommissionText= @VendorCommissionText,
	BookingStatus=1,IssueDate=@IssueDate,
	 IssueBy=@mainAgentID  where pkId = @BookingId  
   


   END
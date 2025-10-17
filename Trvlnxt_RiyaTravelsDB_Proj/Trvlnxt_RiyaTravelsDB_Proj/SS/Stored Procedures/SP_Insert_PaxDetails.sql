CREATE PROCEDURE [SS].[SP_Insert_PaxDetails]    
  @ActivityId int= null,     
  @BookingId int= null,     
  @Titel varchar(10)= null,     
  @Name varchar(50)= null,     
  @Surname varchar(50)= null,     
  @Age varchar(50)= null,     
  @Type varchar(50)= null,    
  @PancardNo varchar(50)= null,     
  @PassportNumber varchar(50)= null,     
  @DateOfBirth datetime= null,    
  @PassportIssueDate datetime= null,    
  @PassportExpirationDate datetime= null,     
  @Nationality int= null,    
  @IssuingCountry int= null,    
  @LeadPax int = null  ,  
  @totalPax int = null,
  @PanCardName varchar (50) = null
AS    
BEGIN    
 SET NOCOUNT ON;    
     
 DECLARE @PaxId INT     
    
 INSERT INTO [SS].[SS_PaxDetails]    
  (ActivityId, BookingId, Titel, Name, Surname, Age,Type, PancardNo,     
   PassportNumber, DateOfBirth, PassportIssueDate, PassportExpirationDate, Nationality,IssuingCountry,LeadPax,totalPax,PanCardName)    
     VALUES    
  (@ActivityId, @BookingId, @Titel, @Name, @Surname, @Age,@Type, @PancardNo,     
   @PassportNumber, @DateOfBirth, @PassportIssueDate, @PassportExpirationDate, @Nationality,@IssuingCountry,@LeadPax,@totalPax, @PanCardName)    
    
 SET @PaxId  =(select  SCOPE_IDENTITY())      
    
 SELECT @PaxId    
END
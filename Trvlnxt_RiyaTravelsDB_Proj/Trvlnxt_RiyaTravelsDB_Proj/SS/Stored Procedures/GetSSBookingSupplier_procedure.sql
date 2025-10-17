


-- =============================================      
-- Author:Shivkumar Prajapati      
-- Create date: 23-Nov-2019      
-- Description: Procedure is created for Get Supplier Name      
-- [dbo].[GetBookingSupplier_procedure] 'RT1004281'      
-- [dbo].[GetBookingSupplier_procedure] '4225'      
-- =============================================      
CREATE PROCEDURE [SS].[GetSSBookingSupplier_procedure]      
 -- Add the parameters for the stored procedure here      
 @bookingid nvarchar(50)      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
      
 Declare @SuppliersName nvarchar(100)      
 Declare @BookID nvarchar(100)      
 Declare @RiyaAgentId int     
 Declare @correlationId nvarchar(100)        
 Declare @AccountId nvarchar(100)        
 Declare @ChannelId nvarchar(100)   
  
      
      
 IF(@bookingid is not null or @bookingid!='')      
 BEGIN      
  set @SuppliersName=(select top 1(providerName) from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))      
  set @BookID=(select top 1 BookingId from  SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))      
  set @RiyaAgentId=(select top 1 AgentID from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @correlationId=(select top 1 CorrelationId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @AccountId=(select top 1 providerId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @ChannelId=(select top 1 ChannelId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))   
  
    
      
  IF( @SuppliersName is null or @SuppliersName='' and @correlationId is null or @correlationId='')      
  BEGIN      
          
   set @SuppliersName=(select top 1(providerName) from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))      
  set @BookID=(select top 1 BookingId from  SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))      
  set @RiyaAgentId=(select top 1 AgentID from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @correlationId=(select top 1 CorrelationId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @AccountId=(select top 1 providerId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))        
  set @ChannelId=(select top 1 ChannelId from SS.SS_BookingMaster where ltrim(rtrim(BookingRefId))=ltrim(rtrim(@bookingid)))   
  
    
  END      
      
  ELSE IF(@SuppliersName is null or @SuppliersName='' and @correlationId is null or @correlationId='')      
  BEGIN          
   set @SuppliersName=('Supplier not found')      
   set @correlationId=('ApiId not found')      
      
  END      
 END      
      
       
      
 select @SuppliersName as 'SuppliersName',@BookID as bookid ,@RiyaAgentId as RiyaAgentId       
       ,@correlationId as correlationId , @AccountId as 'AccountId', @ChannelId as 'ChannelId'        
       
       
END      
      
      
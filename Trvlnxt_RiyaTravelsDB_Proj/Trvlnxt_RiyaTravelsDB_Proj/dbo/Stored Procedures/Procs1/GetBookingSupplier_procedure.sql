-- =============================================    
-- Author:Shivkumar Prajapati    
-- Create date: 23-Nov-2019    
-- Description: Procedure is created for Get Supplier Name    
-- [dbo].[GetBookingSupplier_procedure] 'RT1004281'    
-- [dbo].[GetBookingSupplier_procedure] '4225'    
-- =============================================    
CREATE PROCEDURE [dbo].[GetBookingSupplier_procedure]    
 -- Add the parameters for the stored procedure here    
 @bookingid nvarchar(50)    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
    
 Declare @SuppliersName nvarchar(100)    
 Declare @SearchApiId nvarchar(100)    
 Declare @BookID nvarchar(100)    
 Declare @RiyaAgentId int   
 Declare @correlationId nvarchar(100)      
 Declare @AccountId nvarchar(100)      
 Declare @ChannelId nvarchar(100) 
  Declare @BookingNames nvarchar(100)

    
    
 IF(@bookingid is not null or @bookingid!='')    
 BEGIN    
  set @SuppliersName=(select top 1(SupplierName) from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))    
  set @SearchApiId=(select top 1 searchApiId from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))    
  set @BookID=(select top 1 book_Id from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))    
  set @RiyaAgentId=(select top 1 RiyaAgentID from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))      
  set @correlationId=(select top 1 searchApiId from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))      
  set @AccountId=(select top 1 AccountId from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))      
  set @ChannelId=(select top 1 ChannelId from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid))) 
  set @BookingNames=(select top 1 BookingPortal from Hotel_BookMaster where ltrim(rtrim(book_id))=ltrim(rtrim(@bookingid)))    

      
  --print '1 condition'    
  --print @SuppliersName+','+@SearchApiId    
  --print '1 condition end'    
    
  IF( @SuppliersName is null or @SuppliersName='' and @SearchApiId is null or @SearchApiId='')    
  BEGIN    
        
   set @SuppliersName=(select top 1(SupplierName) from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))    
   set @SearchApiId=(select top 1 searchApiId from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))    
   set @BookID=(select top 1 book_Id from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))    
   set @RiyaAgentId=(select top 1 RiyaAgentID from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))      
   set @correlationId=(select top 1 searchApiId from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))      
   set @AccountId=(select top 1 AccountId from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))      
   set @ChannelId=(select top 1 ChannelId from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid)))
   set @BookingNames=(select top 1 BookingPortal from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid))) 

      
    
  --print '2 condition'    
   --print @SuppliersName+','+@SearchApiId    
   --print '2 condition end'    
  END    
    
  ELSE IF(@SuppliersName is null or @SuppliersName='' and @SearchApiId is null or @SearchApiId='')    
  BEGIN        
   set @SuppliersName=('Supplier not found')    
   set @SearchApiId=('ApiId not found')    
   --print '3 condition'    
   --print @SuppliersName+','+@SearchApiId    
   --print '3 condition end'    
  END    
 END    
    
     
    
 select @SuppliersName as 'SuppliersName',@SearchApiId as 'SearchApiId',@BookID as bookid ,@RiyaAgentId as RiyaAgentId     
       ,@correlationId as correlationId , @AccountId as 'AccountId', @ChannelId as 'ChannelId',@BookingNames as 'BookingPort'       
     
     
END    
    
    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBookingSupplier_procedure] TO [rt_read]
    AS [dbo];


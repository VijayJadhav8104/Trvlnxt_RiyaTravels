CREATE Procedure [dbo].[GetPNRDetailByPaxId] 
@PaxId  varchar(20)=''
AS

BEGIN

Select Country,VendorName,BookingSource from 
tblBookMaster where pkid in (select fkbookmaster from tblPassengerBookDetails where pid= @PaxId)
   
END


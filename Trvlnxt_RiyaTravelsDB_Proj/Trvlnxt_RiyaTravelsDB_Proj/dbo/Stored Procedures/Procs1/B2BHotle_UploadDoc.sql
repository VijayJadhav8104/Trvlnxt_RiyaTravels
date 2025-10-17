Create proc B2BHotle_UploadDoc
@fkid int,
@FileType varchar(100),
@Path varchar(100),
@Description varchar(200),
@CreatedBy varchar(50)

AS

BEGIN

         Insert into B2BHotel_Document (fkid,FileType,Path,Description,CreatedBy,CreatedDate)
         values (@fkid,@FileType,@Path,@Description,@CreatedBy,GetDate())

END 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BHotle_UploadDoc] TO [rt_read]
    AS [dbo];


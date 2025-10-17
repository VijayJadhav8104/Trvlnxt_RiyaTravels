-- =============================================
-- Author:		<Altamash Khan>
-- Create date: <Create Date,,>
-- Description:	<Insert image when hotel image not availabe,,>
-- =============================================
CREATE PROCEDURE UpdateImagesSpacificHotelStaticData
	-- Add the parameters for the stored procedure here
	@Image nvarchar(max),
	@Id int

AS
BEGIN
	if not exists(select FkHotelListId from Hotel_Image_List_Master where FkHotelListId=@Id)
	begin
			insert into Hotel_Image_List_Master (FkHotelListId,Image) 
									values(@Id,@Image)
	End
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateImagesSpacificHotelStaticData] TO [rt_read]
    AS [dbo];


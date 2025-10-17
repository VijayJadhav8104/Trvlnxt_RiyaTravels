-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Insert_CountryInfo]
	@CountryCode varchar(50),
	@CountryName varchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from Hotel_CountryMaster where [CountryCode]=@CountryCode and [CountryName]=@CountryName)
	begin
    INSERT INTO Hotel_CountryMaster
          ( 
              CountryCode,
			  CountryName
			         
          ) 
     VALUES 
          ( 
				@CountryCode,
				@CountryName
			

            
          ) 
end
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Insert_CountryInfo] TO [rt_read]
    AS [dbo];


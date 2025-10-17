-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Insert_NationalityInfo]
	@NationalityCode varchar(50),
	@Nationality varchar(max),
	@ISOCode varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from Hotel_Nationality_Master where [Code]=@NationalityCode and [Nationality]=@Nationality and [ISOCode]=@ISOCode)
	begin
    INSERT INTO Hotel_Nationality_Master
          ( 
              [Code],
			  [Nationality],
			  [ISOCode]
			         
          ) 
     VALUES 
          ( 
				@NationalityCode,
				@Nationality,
				@ISOCode
			

            
          ) 
end
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Insert_NationalityInfo] TO [rt_read]
    AS [dbo];


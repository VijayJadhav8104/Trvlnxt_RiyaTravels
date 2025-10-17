




CREATE PROCEDURE [dbo].[InsertMobileAgent]
@Data1		varchar(50),
@Data2		varchar(4000),
@IP			varchar(50),
@url		varchar(50)

AS BEGIN

	INSERT INTO [dbo].[MobileAgent] (Data1, Data2, IP, URL)
	VALUES(@Data1, @Data2, @IP, @url)

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertMobileAgent] TO [rt_read]
    AS [dbo];


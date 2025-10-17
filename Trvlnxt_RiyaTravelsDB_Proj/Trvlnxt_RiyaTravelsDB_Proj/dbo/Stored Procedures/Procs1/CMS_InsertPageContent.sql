
CREATE proc [dbo].[CMS_InsertPageContent]
@OperationType varchar(30),
@PageName varchar(500),
@Content nvarchar(max),
@Country varchar(200)
AS
BEGIN
		BEGIN
			IF @OperationType='Create'
			BEGIN
				INSERT INTO CMS_PageContent(PageName,Content,Country,CreatedDate,IsActive)
				VALUES(@PageName,@Content,@Country,GETDATE(),1)
			END

			IF @OperationType='Update'
			BEGIN
				UPDATE CMS_PageContent
				SET
				Content=@Content
				where
					PageName=@PageName
					and
					Country=@Country
			END
		END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertPageContent] TO [rt_read]
    AS [dbo];


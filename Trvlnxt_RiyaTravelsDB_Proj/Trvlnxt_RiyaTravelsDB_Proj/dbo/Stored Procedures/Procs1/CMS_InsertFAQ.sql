
CREATE proc [dbo].[CMS_InsertFAQ]
@Operation varchar(50)=null,
@Id int=null,
@Question nvarchar(max)=null,
@Answer nvarchar(max)=null,
@Country varchar(100)=null
AS
BEGIN
		BEGIN
		if @Operation='Create'
		begin
			INSERT INTO CMS_FAQ(Question,Answer,Country,CreatedDate,IsActive)
			VALUES(@Question,@Answer,@Country,GETDATE(),1)
		end

		if @Operation='Update'
		begin
			update CMS_FAQ
			set
			Question=@Question,
			Answer=@Answer
			where
				Country=@Country
				and 
				Id=@Id
		end
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertFAQ] TO [rt_read]
    AS [dbo];


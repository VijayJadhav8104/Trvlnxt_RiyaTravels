-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VisaPromoCode]
	-- Add the parameters for the stored procedure here
	  @Id int = 0,
	  @PromoCode nvarchar(max) = null,
	  @Discount int = null,
	  @UserId int = null,
	  @IP nvarchar(max) = null,
	  @UpdatedOn datetime = null,
	  @UpdatedBy int = null,
	  @Action varchar(50) = null, 
	  @Message varChar(200) OUTPUT 
      
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF(@Action='Insert')
	BEGIN	
		IF NOT EXISTS(SELECT LOWER(PromoCode) FROM tblVisaPromoCode WHERE PromoCode= LOWER(@PromoCode) and  IsActive=1)
			BEGIN
				insert into tblVisaPromoCode
									(PromoCode,
									 Discount,
									 UserId,
									 IP)
							values( @PromoCode,
									@Discount,
									@UserId,
									@IP)

			SET @Message = 'Promo Code Insert Sucsessfull!'
			END

		ELSE
			BEGIN
				SET @Message ='Promo code already exists!'
			END 
	
	END

	IF(@Action='Update')
	BEGIN
	IF NOT EXISTS(SELECT LOWER(PromoCode) FROM tblVisaPromoCode WHERE PromoCode= LOWER(@PromoCode) and  IsActive=1 and @Id!=Id)
		Begin
			UPDATE tblVisaPromoCode set
								PromoCode = @PromoCode,
								Discount = @Discount,
								UpdatedBy = @UserId,
								UpdatedOn = @UpdatedOn
								where Id=@Id

			set @Message = 'Promo Code Update Sucsessfull!' 
		End
		ELSE
			BEGIN
				SET @Message ='Promo code already exists!'
			END
	END
	
	IF(@Action='Delete')
	BEGIN
		UPDATE tblVisaPromoCode set
								UpdatedBy = @UpdatedBy,
								UpdatedOn = @UpdatedOn,
								IsActive = 0
								where Id = @Id

	SET @Message = 'Promo Code Delete Sucsessfull!' 
	
	END

	IF(@Action='GetData')
	BEGIN
		IF(@Id != 0)
		BEGIN
			select * from tblVisaPromoCode
			where Id=@Id and IsActive=1
		END
		ELSE
			BEGIN
				select * from tblVisaPromoCode
				where  IsActive=1
			END
	
	END

	select @Message AS Message
END

-- VisaPromoCode null,'GetData',NULL 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[VisaPromoCode] TO [rt_read]
    AS [dbo];


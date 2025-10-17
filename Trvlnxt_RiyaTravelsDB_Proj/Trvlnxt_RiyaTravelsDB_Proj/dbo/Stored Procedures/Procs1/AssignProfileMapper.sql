-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AssignProfileMapper]
	-- Add the parameters for the stored procedure here
	@Id INT = 0
	,@AgentId INT = 0
	,@ProfileId INT = 0
	,@SupplierId INT = 0
	,@CancellationHours INT = 0
	,@Action VARCHAR(20) = ''
	,@OldProfileId INT = 0
	,@SupplierPKID INT = 0
	,@IsActive BIT = 0
	,@createdBy int=0
	,@ModifiedBy int=0
	,@ddlPriceOptimization varchar(200)=''
	,@CombinationNumber int=0
	,@BasedOnSupplier int=0
	,@IsCheck bit=0
	,@CombinationCount int=0
AS
BEGIN
	IF (@Action = 'Assign')
	 if not exists(select AgentId,ProfileId from AgentProfileMapper where AgentId=@AgentId)
		BEGIN
			INSERT INTO AgentProfileMapper (
				AgentId
				,ProfileId
				,CreatedBy
				)
			VALUES (
				@AgentId
				,@ProfileId
				,@CreatedBy
				)

			SELECT SCOPE_IDENTITY();
		END
	  Else
		BEGIN
			if not exists(select AgentId,ProfileId from AgentProfileMapper where AgentId=@AgentId AND ProfileId =@ProfileId)
			BEGIN
				UPDATE AgentProfileMapper 
				SET ProfileId=@ProfileId ,ModifiedBy=@createdBy,ModifiedOn=GETDATE()  --#@createdBy (becose values get @createdby then use @createdby)
				WHERE AgentId=@AgentId
			END
		END

	IF (@Action = 'UpdateAssign')
	BEGIN
		IF EXISTS (
				SELECT AgentId
					,ProfileId
				FROM AgentProfileMapper
				WHERE AgentId = @AgentId
					AND ProfileId = @OldProfileId
				)
		BEGIN
			UPDATE AgentProfileMapper
			SET ProfileId = @ProfileId,
				ModifiedBy = @ModifiedBy,
				ModifiedOn = GETDATE()
			WHERE Id = @Id
				
		END
		else
		 begin		
			UPDATE AgentProfileMapper
			SET ProfileId = @ProfileId,
				ModifiedBy = @ModifiedBy,
				ModifiedOn = GETDATE()
			WHERE Id = @Id
		end
	END

	IF (@Action = 'Supplier')
	if not exists(select AgentId,SupplierId from AgentSupplierProfileMapper where AgentId=@AgentId and SupplierId=@SupplierId)
	BEGIN

		INSERT INTO AgentSupplierProfileMapper (
			AgentId
			,SupplierId
			,CancellationHours
			,ProfileId				--added by Altamash [Requirement change from b.a]
			,PriceOptimizationOn
			)
		VALUES (
			@AgentId
			,@SupplierId
			,@CancellationHours
			,@ProfileId
			,@ddlPriceOptimization
			)
	END

	IF (@Action = 'UpdateSupplier')
	BEGIN
		
		IF (@SupplierPKID != 0)
		BEGIN
			UPDATE AgentSupplierProfileMapper
			SET IsActive = @IsActive,CancellationHours=@CancellationHours, ProfileId = @ProfileId
			WHERE Id = @SupplierPKID
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT Id
						,AgentId
					FROM AgentSupplierProfileMapper
					WHERE SupplierId = @SupplierId 
						AND AgentId = @AgentId
					)
			BEGIN
				UPDATE AgentSupplierProfileMapper
				SET IsActive = 1,CancellationHours=@CancellationHours , ProfileId = @ProfileId
				WHERE SupplierId = @SupplierId 
						AND AgentId = @AgentId

			END
			ELSE
			BEGIN
				INSERT INTO AgentSupplierProfileMapper (
					AgentId
					,SupplierId
					,CancellationHours
					,ProfileId
					)
				VALUES (
					@AgentId
					,@SupplierId
					,@CancellationHours
					,@ProfileId
					)
			END
		END
	END

	IF (@Action = 'DeletePriceProfile')
	BEGIN
		UPDATE AgentProfileMapper
		SET IsActive = 0
		WHERE Id = @Id
	END

	IF (@Action = 'DeleteSupplier')
	BEGIN
		UPDATE AgentSupplierProfileMapper
		SET IsActive = 0
		WHERE Id = @Id
	END

	IF (@Action = 'BasedOnSupplier')
	 if not exists(select AgentId,BasedOnSupplier,CombinationNo from BasedOnSupplierMapping where AgentId=@AgentId and BasedOnSupplier=@BasedOnSupplier and CombinationNo=@CombinationNumber)
		BEGIN

			INSERT INTO BasedOnSupplierMapping(
				 AgentId
				,CombinationNo
				,BasedOnSupplier
				,CreatedBy
				,IsCheck
				,CombinationCount
				)
			VALUES (
				 @AgentId
				,@CombinationNumber
				,@BasedOnSupplier
				,@CreatedBy
				,@IsCheck
				,@CombinationCount
				)

				update AgentSupplierProfileMapper set PriceOptimizationOn='Based On Suppliers'
				where AgentId=@AgentId and IsActive=1

		END
	  Else
		BEGIN
			--if not exists(select AgentId,BasedOnSupplier from BasedOnSupplierMapping where AgentId=@AgentId AND BasedOnSupplier =@BasedOnSupplier)
			BEGIN
				UPDATE BasedOnSupplierMapping 
				SET BasedOnSupplier=@BasedOnSupplier ,ModifiedBy=@createdBy,ModifiedDate=GETDATE()  --#@createdBy (becose values get @createdby then use @createdby)
				WHERE AgentId=@AgentId and CombinationNo=@CombinationNumber and BasedOnSupplier =@BasedOnSupplier

				update AgentSupplierProfileMapper set PriceOptimizationOn='Based On Suppliers'
				where AgentId=@AgentId and IsActive=1
			END
		END

	IF (@Action = 'DeleteSupplierMap')
	BEGIN
		delete from AgentSupplierProfileMapper where AgentId=@AgentId
	END
	IF (@Action = 'DeleteBasedSupp')
	BEGIN
		delete from BasedOnSupplierMapping where AgentId=@AgentId
	END

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AssignProfileMapper] TO [rt_read]
    AS [dbo];


CREATE PROC UpdateTFSupplierMappingSector
	@TFSupplierMappingSector TFSupplierMappingSector READONLY,
	@SupplierID BIGINT,
	@SupplierName VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRANSACTION;

	
	--DELETE FROM TF_SupplierSectorMapping
	--WHERE SupplierId=@SupplierID
	
	INSERT INTO TF_SupplierSectorMapping
	(SupplierId,SupplierName,Sector,Inserted_On,Status)
	Select @SupplierID,@SupplierName,Sector,GETDATE(),1 
	FROM @TFSupplierMappingSector

	--DELETE FROM tblAirlineSectors
	--WHERE ISNULL(SupplierId,0)=@SupplierID  AND Carrier='TF'

	INSERT INTO tblAirlineSectors (SupplierId,fromSector, toSector, Carrier, IsActive)
    SELECT @SupplierID,S.fromSector, S.toSector, 'TF', 1
    FROM @TFSupplierMappingSector AS S
    --WHERE NOT EXISTS (
    --    SELECT 1
    --    FROM tblAirlineSectors AS ASector
    --    WHERE ASector.Carrier = 'TF' AND ASector.fromSector = S.fromSector AND ASector.toSector=S.toSector 
    --);

	COMMIT TRANSACTION;

	--DECLARE @fromSector Varchar(50),@toSector Varchar(50)


	--DECLARE TFMapping CURSOR FOR SELECT fromSector,toSector FROM @TFSupplierMappingSector

	---- NOW OPEN CURSOR
	--OPEN TFMapping;

	---- HERE FETCH ROW FROM CITY MASTER TABLE
	--FETCH NEXT FROM TFMapping INTO @fromSector,@toSector

	---- STARTING OF WHILE LOOP
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
   
	--	IF NOT EXISTS(Select * from tblAirlineSectors WHERE fromSector=@fromSector AND toSector=@toSector AND Carrier='TF')
	--	BEGIN
	--		INSERT INTO tblAirlineSectors
	--		(fromSector,toSector,Carrier,IsActive)
	--		VALUES
	--		(@fromSector,@toSector,'TF',1)
	--	END


	--	-- AGAIN FETCH NEXT ROW FROM CURSOR
	--	FETCH NEXT FROM TFMapping INTO @fromSector,@toSector
	--END;

	---- CLOSE CURSOR OF CITY MASTER
	--CLOSE TFMapping;

	---- DEALLOCATE CURSOR OF CITY MASTER
	--DEALLOCATE TFMapping;

	

	
END

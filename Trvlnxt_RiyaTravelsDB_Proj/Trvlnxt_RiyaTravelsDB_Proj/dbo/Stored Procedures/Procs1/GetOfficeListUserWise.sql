CREATE PROCEDURE [dbo].[GetOfficeListUserWise]   
	@CompanyName VARCHAR(10) = NULL   
	, @VendorName VARCHAR(50) = NULL  
	, @userId varchar(10)   
AS     
BEGIN    

	SET @VendorName = (CASE WHEN @VendorName = 'AirIndiaExpress' then 'aiexpress' else @VendorName end);
   
	IF EXISTS(SELECT * FROM mUserOfficeIdMapping WITH(NOLOCK) WHERE UserId = @userId AND isActive = 1)   
	BEGIN  
		IF EXISTS(SELECT o.ID FROM mUserOfficeIdMapping O WITH(NOLOCK)  
		INNER JOIN mVendorCredential C WITH(NOLOCK) ON o.OfficeId = c.OfficeId    
		INNER JOIN mVendor V WITH(NOLOCK) ON V.ID = O.FKmVendor   
		WHERE REPLACE(UPPER(C.FieldName), ' ', '') = 'DisplayName' AND c.IsActive = 1    
		AND UserId = @userId AND REPLACE(UPPER(V.VendorName), ' ', '') = REPLACE(UPPER(@VendorName), ' ', ''))  
		BEGIN  
			SELECT o.ID  
			, REPLACE(REPLACE(O.OfficeId, CHAR(10), ''), CHAR(13), '') OfficeId  
			, C.Value As 'OfficeIdName'   
			FROM mUserOfficeIdMapping O WITH(NOLOCK)  
			INNER JOIN mVendorCredential C WITH(NOLOCK) ON REPLACE(REPLACE(o.OfficeId, CHAR(10) , ''), CHAR(13), '') = REPLACE(REPLACE(c.OfficeId, CHAR(10), ''), CHAR(13), '')   
			INNER JOIN mVendor V WITH(NOLOCK) ON V.ID = O.FKmVendor AND v.ID = c.VendorId AND V.IsDeleted = 0 AND V.IsActive = 1   
			WHERE REPLACE(UPPER(C.FieldName), ' ', '') = 'DisplayName' AND c.IsActive = 1 AND O.IsActive = 1   
			AND UserId = @userId AND REPLACE(UPPER(V.VendorName), ' ', '') = REPLACE(UPPER(@VendorName), ' ', '')   
			ORDER BY OfficeId asc  
		END   
	END   
	ELSE   
	BEGIN
		SELECT C.ID  
		, REPLACE(REPLACE(C.OfficeId, CHAR(10), ''), CHAR(13), '') OfficeId  
		, C.Value As 'OfficeIdName'   
		FROM mVendor V WITH(NOLOCK)  
		INNER JOIN mVendorCredential C WITH(NOLOCK) ON V.ID = C.VendorId   
		WHERE REPLACE(UPPER(C.FieldName), ' ', '') = 'DisplayName' AND c.IsActive = 1 AND V.IsDeleted = 0 AND V.IsActive = 1   
		AND REPLACE(UPPER(V.VendorName), ' ', '') = REPLACE(UPPER(@VendorName), ' ', '')   
		ORDER BY OfficeId ASC  
	END

	--IF @CompanyName = '1A'   
	--BEGIN   
   
	--IF(REPLACE(UPPER(@VendorName), ' ', '') = 'GOAIR')   
	--BEGIN   
	--set @VendorName = 'GO FIRST'   
	--END  
	--WHERE FieldName = 'DisplayName' AND c.IsActive = 1 AND UserId = @userId AND V.VendorName = 'Amadeus'   
    
	--END   
	--ELSE IF @CompanyName = '1S'   
	--BEGIN   
	--SELECT o.ID, O.OfficeId, C.Value As 'OfficeIdName' FROM mUserOfficeIdMapping O    
	--INNER JOIN mVendorCredential C ON o.OfficeId = c.OfficeId   
	--INNER JOIN mVendor V ON V.ID = O.FKmVendor   
	--WHERE FieldName = 'DisplayName' AND c.IsActive = 1 AND UserId = @userId AND V.VendorName = 'SABRE'   
    
	--END   
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetOfficeListUserWise] TO [rt_read]
    AS [dbo];


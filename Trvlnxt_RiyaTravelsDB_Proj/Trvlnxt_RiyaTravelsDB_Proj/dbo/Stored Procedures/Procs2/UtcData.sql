
CREATE proc [dbo].[UtcData] --'Select',null,null,null,null,null
@operationType varchar(100)=null,
@CODE  varchar(20)=null,
@Name nvarchar(max)=null,
@SearchName varchar(max)=null,
@Country varchar(50)=null,
@Utc nvarchar(max)=null
AS
BEGIN
		BEGIN
			IF @operationType='Select'
			BEGIN
				IF @CODE IS NULL
				BEGIN
					SELECT TOP 100 ROW_NUMBER() OVER (Order by Name) AS RowNumber,
					CODE,	
					(
						Select     
							SubString(
								NAME, 
									CharIndex ('-', NAME, 1) + 1,
									Len(NAME) - CharIndex ('-', NAME, 1)
									)
					)as NAMES,
					SEARCHNAME,
					COUNTRY,
					ISNULL (UTC,'null') as UTC
					From tblAirportCity 
					WHERE UTC IS NULL
					ORDER BY NAME ASC
				END
				ELSE
				BEGIN
					SELECT TOP 100 ROW_NUMBER() OVER (Order by Name) AS RowNumber,
					CODE,	
					(
						Select     
							SubString(
								NAME, 
									CharIndex ('-', NAME, 1) + 1,
									Len(NAME) - CharIndex ('-', NAME, 1)
									)
					)as NAMES,
					SEARCHNAME,
					COUNTRY,
					ISNULL (UTC,'null') as UTC
					From tblAirportCity 
					WHERE CODE=@CODE
					ORDER BY NAME ASC
				END
			END

			IF @operationType='Update'
			BEGIN
				IF @CODE IS NOT NULL
				BEGIN
					UPDATE tblAirportCity
					SET
					NAME=@Name,
					SEARCHNAME=@SearchName,
					COUNTRY=UPPER(@Country),
					UTC=@Utc
					WHERE
						CODE=LTRIM(RTRIM(@CODE))

				END
			END

			IF @operationType='Search'
			BEGIN
				SELECT TOP 100 ROW_NUMBER() OVER (Order by Name) AS RowNumber,
					CODE,	
					(
						Select     
							SubString(
								NAME, 
									CharIndex ('-', NAME, 1) + 1,
									Len(NAME) - CharIndex ('-', NAME, 1)
									)
					)as NAMES,
					SEARCHNAME,
					COUNTRY,
					ISNULL (UTC,'null') as UTC
					From tblAirportCity 
					WHERE CODE=@CODE
					ORDER BY NAME ASC
			END
		END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UtcData] TO [rt_read]
    AS [dbo];


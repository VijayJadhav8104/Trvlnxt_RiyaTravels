CREATE PROC GetAllmFareRule        
 @UserType varchar(20),        
 @Country varchar(20),    
 @AirportType varchar(20) ,  
 @Vendorname varchar(max)  
AS        
BEGIN        
 SET NOCOUNT ON ;        
        
 SELECT F.Id,UserType,Country,V.VendorName,F.FareName,F.Officeid,F.OriginValue,F.DestinationValue,U.UserName AS CreatedBy,F.CreatedOn,F.CreatedOn,        
 UM.UserName AS ModifiedBy,F.ModifiedOn,F.IsActive,ISNULL(F.IsDelete,0) AS IsDelete        
 FROM mFareRule F WITH(NOLOCK)        
 LEFT JOIN mVendor V WITH(NOLOCK) ON F.VendorID=V.ID        
 LEFT JOIN mUser U WITH(NOLOCK) ON F.CreatedBy=U.ID        
 LEFT JOIN mUser UM WITH(NOLOCK) ON F.ModifiedBy=UM.ID        
 WHERE (@UserType='' OR UserType=@UserType)        
 AND (@Country='' OR Country=@Country)     
 AND ((@AirportType = '') or (AirportType=@AirportType))   
  AND ((@Vendorname = '') or (V.VendorName=@Vendorname))    
 AND ISNULL(F.IsDelete,0)=0        
END
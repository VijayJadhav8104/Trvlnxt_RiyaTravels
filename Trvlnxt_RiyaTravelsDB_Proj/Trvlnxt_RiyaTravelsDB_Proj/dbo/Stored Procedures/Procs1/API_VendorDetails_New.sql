CREATE procedure API_VendorDetails_New             
@VendorName varchar(255) = ''                
,@OfficeIDList varchar(MAX) = ''                        
as                        
begin                 
                
DECLARE @test AS VARCHAR(MAX);          
          
SET @test = 'select vc.FieldName,vc.Value,vc.OfficeId,REPLACE(v.VendorName, '' '', '''') as VendorName';          
SET @test += ' from mVendor v';          
SET @test += ' inner join mVendorCredential vc on v.ID=vc.VendorId';          
SET @test += ' where v.IsDeleted=0 AND VC.IsActive=1';          
          
IF (@OfficeIDList IS NOT NULL AND @OfficeIDList <> '' AND @OfficeIDList <> 'null')          
BEGIN          
    SET @test += ' AND vc.OfficeId IN (SELECT Data FROM sample_split(''' + @OfficeIDList + ''', '','')) ';          
END          
          
IF (@VendorName IS NOT NULL AND @VendorName <> '' AND @VendorName <> 'null')          
BEGIN          
 SET @test += ' AND REPLACE(UPPER(v.VendorName), '' '', '''') = REPLACE(UPPER(''' + @VendorName + '''), '' '', '''')';          
END        
        
EXEC(@test);                   
                
End 
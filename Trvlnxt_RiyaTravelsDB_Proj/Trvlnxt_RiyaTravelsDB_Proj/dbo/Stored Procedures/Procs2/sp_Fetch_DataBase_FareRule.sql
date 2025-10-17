  
  
      
--exec sp_Fetch_DataBase_FareRule 'IN','Indigo','KMBOM0002','Marine Fare'      
      
      
CREATE Procedure [dbo].[sp_Fetch_DataBase_FareRule]      
@Country varchar(10),      
@VendorName varchar(50),      
@OfficeId varchar(100),      
@FareName varchar(50),      
@UserType varchar(50) = '',    
@AirportType varchar(5) = ''      
AS      
BEGIN      
 IF(@VendorName = 'Indigo')      
  BEGIN      
   SELECT      
   fd.ID,      
   fd.FareID AS Category,      
   fd.Header,      
   fd.[Description]      
   FROM mFareRuleDetails fd      
   join mFareRule fr ON fr.ID = fd.FareID      
   WHERE fr.Country = @Country      
   and LOWER(fr.VendorName) = @VendorName      
   and LOWER(fr.Officeid) = @OfficeId      
   and LOWER(fr.FareName) = @FareName      
  -- and LOWER(fr.UserType) = @UserType     
   and LOWER(fr.AirportType) = @AirportType      
   and fr.IsActive = 1      
   and fr.IsDelete = 0      
  END      
 ELSE      
  BEGIN      
   SELECT      
   fd.ID,      
   fd.FareID AS Category,      
   fd.Header,      
   fd.[Description]      
   FROM mFareRuleDetails fd      
   join mFareRule fr ON fr.ID = fd.FareID      
   WHERE fr.Country = @Country      
   and LOWER(fr.VendorName) = @VendorName      
   and LOWER(fr.Officeid) = @OfficeId      
   and LOWER(fr.FareName) = @FareName       
   --and LOWER(fr.UserType) = @UserType    
   and fr.IsActive = 1      
   and fr.IsDelete = 0      
  END      
END
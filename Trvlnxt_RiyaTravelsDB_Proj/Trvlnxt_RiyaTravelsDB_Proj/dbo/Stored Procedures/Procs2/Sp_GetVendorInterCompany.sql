-- ================================================  
-- Template generated from Template Explorer using:  
-- Create Procedure (New Menu).SQL  
-- =============================================  
-- Author:  bhaivka kawa  
-- Description: to get vendor inter company details  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_GetVendorInterCompany]  
@VendorName varchar(50)=null,  
@Country varchar(10)=null  
AS  
BEGIN  
 select * from mVendorInterCompany  vi  
 inner join mVendor v on v.ID=vi.VendorId  
 inner join mCountry c on c.ID=vi.CountryId  
 where REPLACE(UPPER(v.VendorName), ' ', '')=REPLACE(UPPER(@VendorName), ' ', '') and c.CountryCode=@Country   and vi.IsActive=1
END  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorInterCompany] TO [rt_read]
    AS [dbo];


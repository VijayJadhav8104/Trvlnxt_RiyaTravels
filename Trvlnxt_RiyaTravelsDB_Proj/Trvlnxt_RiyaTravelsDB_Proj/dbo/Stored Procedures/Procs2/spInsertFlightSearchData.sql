
CREATE proc [dbo].[spInsertFlightSearchData]

	@fk_CacheMast bigint  = NULL,
	@flightdeptdate varchar(15) = NULL,
	@flightdepttime varchar(15) = NULL,
	@flightarrivaldate varchar(15) = NULL,
	@flightarrivaltime varchar(15) = NULL,
	@fromlocation varchar(200) = NULL,
	@fromterminal varchar(50) = NULL,
	@tolocation varchar(200) = NULL,
	@toterminal varchar(50) = NULL,
	@flightnum varchar(10) = NULL,
	@carrier varchar(5) = NULL,
	@airname varchar(50) = NULL,
	@fromairport varchar(200) = NULL,
	@toairport varchar(200) = NULL,
	@taxdesc varchar(100) = NULL,
	@sector varchar(100) = NULL,
	@comission varchar(100) = NULL,
	@equipment varchar(100) = NULL,
	@servicecharge varchar(100) = NULL,
	@operatingcarrier varchar(100) = NULL,
	@corporateID varchar(100) = NULL,
	@bookingclass varchar(100) = NULL,
	@rbd varchar(100) = NULL,
	@cabin varchar(100) = NULL,
	@tax_descreturn varchar(1000) = NULL,
	@onewaynetamount varchar(200) = NULL,
	@returnnetamount varchar(50) = NULL,
	@taxdescsingle varchar(1000) = NULL,
	@YQsingle varchar(100) = NULL,
	@YQreturn varchar(100) = NULL,
	@inflightservice varchar(500) = NULL,
	@ServiceTaxOnDiscount varchar(20) = NULL,
	@SBConDiscount varchar(20) = NULL,
	@KKConDiscount varchar(20) = NULL,
	@SBConDiscountreturn varchar(20) = NULL,
	@KKConDiscountreturn varchar(20) = NULL,
	@tax_desc varchar(200) = NULL,
	@YQ varchar(200) = NULL,
	@company varchar(200) = NULL,
	@Class varchar(200) = NULL,
	@GDStotaltax varchar(200) = NULL,
	@GDSbasicfare varchar(200) = NULL,
	@GDStotaltaxreturn varchar(200) = NULL,
	@GDSbasicfareretur varchar(200) = NULL,
	@totaltax varchar(200) = NULL,
	@basicfare varchar(200) = NULL,
	@baggagenumber varchar(200) = NULL,
	@weight varchar(200) = NULL,
	@unit varchar(200) = NULL,
	@code varchar(200) = NULL,
	@totaltaxreturn varchar(200) = NULL,
	@basicfarereturn varchar(200) = NULL,
	@weightreturn varchar(200) = NULL,
	@codereturn varchar(200) = NULL,
	@FareSellKey varchar(200) = NULL,
	@JourneySellKey varchar(200) = NULL,
	@Signature varchar(200) = NULL,
	@RuleNumber varchar(200) = NULL,
	@FareClassOfService varchar(200) = NULL,
	@totalprice varchar(50) = NULL,
	@totaldiscount varchar(50) = NULL,
	@totalservicetax varchar(50) = NULL,
	@totaldiscountreturn varchar(50) = NULL,
	@totalservicetaxreturn varchar(50) = NULL,
	@totalpricereturn varchar(50) = NULL,
	@GDStotalprice varchar(50) = NULL,
	@GDStotalpricereturn varchar(50) = NULL
	as
begin

INSERT INTO [dbo].[tblCacheFlightDetails]
           ([fk_CacheMast]
           ,[flightdeptdate]
           ,[flightdepttime]
           ,[flightarrivaldate]
           ,[flightarrivaltime]
           ,[fromlocation]
           ,[fromterminal]
           ,[tolocation]
           ,[toterminal]
           ,[flightnum]
           ,[carrier]
           ,[airname]
           ,[fromairport]
           ,[toairport]
           ,[taxdesc]
           ,[sector]
           ,[comission]
           ,[equipment]
           ,[servicecharge]
           ,[operatingcarrier]
           ,[corporateID]
           ,[bookingclass]
           ,[rbd]
           ,[cabin]
           ,[tax_descreturn]
           ,[onewaynetamount]
           ,[returnnetamount]
           ,[taxdescsingle]
           ,[YQsingle]
           ,[YQreturn]
           ,[inflightservice]
           ,[ServiceTaxOnDiscount]
           ,[SBConDiscount]
           ,[KKConDiscount]
           ,[SBConDiscountreturn]
           ,[KKConDiscountreturn]
           ,[tax_desc]
           ,[YQ]
           ,[company]
           ,[Class]
           ,[GDStotaltax]
           ,[GDSbasicfare]
           ,[GDStotaltaxreturn]
           ,[GDSbasicfareretur]
           ,[totaltax]
           ,[basicfare]
           ,[baggagenumber]
           ,[weight]
           ,[unit]
           ,[code]
           ,[totaltaxreturn]
           ,[basicfarereturn]
           ,[weightreturn]
           ,[codereturn]
           ,[FareSellKey]
           ,[JourneySellKey]
           ,[Signature]
           ,[RuleNumber]
           ,[FareClassOfService]
          ,[totalprice]
           ,[totaldiscount]
           ,[totalservicetax]
           ,[totaldiscountreturn]
           ,[totalservicetaxreturn]
           ,[totalpricereturn]
           ,[GDStotalprice]
           ,[GDStotalpricereturn])
     VALUES
           (@fk_CacheMast
           ,@flightdeptdate
           ,@flightdepttime
           ,@flightarrivaldate
           ,@flightarrivaltime
           ,@fromlocation
           ,@fromterminal
           ,@tolocation
           ,@toterminal
           ,@flightnum
           ,@carrier
           ,@airname
           ,@fromairport
           ,@toairport
           ,@taxdesc
           ,@sector
           ,@comission
           ,@equipment
           ,@servicecharge
           ,@operatingcarrier
           ,@corporateID
           ,@bookingclass
           ,@rbd
           ,@cabin
           ,@tax_descreturn
           ,@onewaynetamount
           ,@returnnetamount
           ,@taxdescsingle
           ,@YQsingle
           ,@YQreturn
           ,@inflightservice
           ,@ServiceTaxOnDiscount
           ,@SBConDiscount
           ,@KKConDiscount
           ,@SBConDiscountreturn
           ,@KKConDiscountreturn
           ,@tax_desc
           ,@YQ
           ,@company
           ,@Class
           ,@GDStotaltax
           ,@GDSbasicfare
           ,@GDStotaltaxreturn
           ,@GDSbasicfareretur
           ,@totaltax
           ,@basicfare
           ,@baggagenumber
           ,@weight
           ,@unit
           ,@code
           ,@totaltaxreturn
           ,@basicfarereturn
           ,@weightreturn
           ,@codereturn
           ,@FareSellKey
           ,@JourneySellKey
           ,@Signature
           ,@RuleNumber
           ,@FareClassOfService
           ,@totalprice
           ,@totaldiscount
           ,@totalservicetax
           ,@totaldiscountreturn
           ,@totalservicetaxreturn
           ,@totalpricereturn
           ,@GDStotalprice
           ,@GDStotalpricereturn)
end








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertFlightSearchData] TO [rt_read]
    AS [dbo];


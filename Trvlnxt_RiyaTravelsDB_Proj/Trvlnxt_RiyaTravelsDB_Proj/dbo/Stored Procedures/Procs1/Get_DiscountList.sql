



create proc [dbo].[Get_DiscountList]

as
begin

SELECT
ID,
MarketPoint,
SerivceType,
PaxType,
AgencyName,
AgencyID,
AirlineType,
AirlineCode,
Cabin,
RBD_Include,
RBD_Exclude,
FareBasis_Include,
FareBasis_Exclude,
FlightSeries,
FlightSeries_From,
FlightSeries_To,
Origin_Include,
Origin_exclude,
Destination_Include,
Destination_Exclude,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
SOTO,
Remark,
InsertedDate


from mstDiscount



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_DiscountList] TO [rt_read]
    AS [dbo];


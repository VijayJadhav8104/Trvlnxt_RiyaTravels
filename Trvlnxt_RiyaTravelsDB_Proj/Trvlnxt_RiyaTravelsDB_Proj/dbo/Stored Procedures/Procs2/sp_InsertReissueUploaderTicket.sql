CREATE procedure [dbo].[sp_InsertReissueUploaderTicket] 
@GDSPNR varchar(255),                                      
@TicketNumber varchar(255),                                      
@BasicFare decimal(18,2), 
@Tax  decimal(18,2), 
@TotalFare decimal(18,2), 
@YQ decimal(18,2), 
@YrTax decimal(18,2), 
@InTax decimal(18,2), 
@JnTax decimal(18,2), 
@OCTax decimal(18,2), 
@ExtraTax decimal(18,2), 
@YMTax decimal(18,2), 
@WOTax decimal(18,2), 
@OBTax decimal(18,2), 
@RFTax decimal(18,2), 
@DiscriptionTax varchar(255),
@Status varchar(255)
as                                      
begin

insert into tblReissueUploaderTicketDetails
(
GDSPNR
,TicketNumber
,BasicFare
,Tax
,TotalFare
,YQ
,YrTax
,InTax
,JnTax
,OCTax
,ExtraTax
,YMTax
,WOTax
,OBTax
,RFTax
,DiscriptionTax
,Status
,InsertedDate
)
values
(
@GDSPNR
,@TicketNumber
,@BasicFare
,@Tax
,@TotalFare
,@YQ
,@YrTax
,@InTax
,@JnTax
,@OCTax
,@ExtraTax
,@YMTax
,@WOTax
,@OBTax
,@RFTax
,@DiscriptionTax
,@Status
,GETDATE()
)

select SCOPE_IDENTITY();             
end



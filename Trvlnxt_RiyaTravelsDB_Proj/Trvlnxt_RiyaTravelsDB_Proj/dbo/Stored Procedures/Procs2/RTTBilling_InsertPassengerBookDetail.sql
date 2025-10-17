CREATE PROCEDURE [dbo].[RTTBilling_InsertPassengerBookDetail]
	@fkBookMaster BigInt
	,@paxFName Varchar(50)
	,@YQ Varchar(50) = NULL
	,@airPNR Varchar(50) = NULL
	,@totalFare decimal(18,4)
	,@basicFare decimal(18,4)
	,@totalTax decimal(18,4)
	,@isReturn Bit
	,@YRTax decimal(18,2)
	,@INTax decimal(18,2)
	,@JNTax decimal(18,2)
	,@ExtraTax decimal(18,2)
	,@DiscriptionTax Varchar(1000) = NULL
	,@ticketnumber Varchar(200) = NULL -- Field for ticketNum
	,@ticketnumber2 Varchar(200) = NULL -- Field for TicketNumber
	,@PLBCommission decimal(18,2)
	,@GST decimal(18,2)
	,@ServiceFee decimal(18,2)
	,@TDSonPLB decimal(18,2) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO tblPassengerBookDetails (fkBookMaster
	,paxFName
	,inserteddate
	,YQ
	,airPNR
	,totalFare
	,basicFare
	,totalTax
	,isReturn
	,YRTax
	,INTax
	,JNTax
	,ExtraTax
	,DiscriptionTax
	,BookingStatus
	,ticketNum
	,TicketNumber
	,PLBCommission
	,GST
	,ServiceFee
	,TDSonPLB)
	VALUES (@fkBookMaster
	,@paxFName
	,GETDATE()
	,ISNULL(@YQ,'0')
	,@airPNR
	,@totalFare
	,@basicFare
	,@totalTax
	,@isReturn
	,@YRTax
	,@INTax
	,@JNTax
	,@ExtraTax
	,@DiscriptionTax
	,1 --@BookingStatus
	,@ticketnumber
	,(CASE WHEN @ticketnumber2 IS NULL OR @ticketnumber2 = '' THEN @ticketnumber ELSE @ticketnumber2 END)
	,@PLBCommission
	,@GST
	,@ServiceFee
	,@TDSonPLB)

	SELECT SCOPE_IDENTITY();
END
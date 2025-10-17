CREATE PROCEDURE [dbo].[ManualTicketing_InsertPassengerBookDetail]
	@fkBookMaster BigInt
	,@paxType Varchar(50)
	,@paxFName Varchar(50)
	,@paxLName Varchar(50)
	,@title Varchar(10)
	,@dateOfBirth DateTime = NULL
	,@gender Varchar(20) = NULL
	,@YQ Varchar(50) = NULL
	,@airPNR Varchar(50) = NULL
	,@totalFare decimal(18,4)
	,@basicFare decimal(18,4)
	,@totalTax decimal(18,4)
	,@isReturn Bit
	,@YRTax decimal(18,2)
	,@INTax decimal(18,2)
	,@JNTax decimal(18,2)
	,@OCTax decimal(18,2)
	,@ExtraTax decimal(18,2)
	,@DiscriptionTax Varchar(1000) = NULL
	,@B2BMarkup decimal(18,4) = NULL
	,@YMTax decimal(18,2)
	,@WOTax decimal(18,2)
	,@OBTax decimal(18,2)
	,@RFTax decimal(18,2)
	,@ticketnumber Varchar(200) = NULL -- Field for ticketNum
	,@ticketnumber2 Varchar(200) = NULL -- Field for TicketNumber
	,@IATACommission decimal(18,2)
	,@PLBCommission decimal(18,2)
	,@DropnetCommission decimal(18,2)
	,@BFC decimal(18,2)
	,@GST decimal(18,2)
	,@ServiceFee decimal(18,2)
	,@Baggage Varchar(200) = NULL
	,@TDSonIATA decimal(18,2) = NULL
	,@GSTonPLB decimal(18,2) = NULL
	,@TDSonPLB decimal(18,2) = NULL
	,@PanNumber varchar(20)=''
    ,@Nationalty varchar(20)=''
	,@PanCardValidation varchar(100)='' 
	,@MarkOn Varchar(20) = NULL
	,@FrequentFlyerNumber Varchar(20) = NULL
	,@K7Tax decimal(18,2) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO tblPassengerBookDetails (fkBookMaster
	,paxType
	,paxFName
	,paxLName
	,inserteddate
	,title
	,dateOfBirth
	,gender
	,YQ
	,airPNR
	,totalFare
	,basicFare
	,totalTax
	,isReturn
	,YRTax
	,INTax
	,JNTax
	,OCTax
	,ExtraTax
	,DiscriptionTax
	,B2BMarkup
	,BookingStatus
	,YMTax
	,WOTax
	,OBTax
	,RFTax
	,ticketNum
	,TicketNumber
	,baggage
	,IATACommission
	,PLBCommission
	,DropnetCommission
	,BFC
	,GST
	,ServiceFee
	,TDSonIATA
	,GSTonPLB
	,TDSonPLB
	,PanNumber
	,nationality
	,PanCardValidation
	,MarkOn
	,FrequentFlyNo
	,K7Tax)
	VALUES (@fkBookMaster
	,@paxType
	,@paxFName
	,@paxLName
	,GETDATE()
	,@title
	,@dateOfBirth
	,@gender
	,ISNULL(@YQ,'0')
	,@airPNR
	,@totalFare
	,@basicFare
	,@totalTax
	,@isReturn
	,@YRTax
	,@INTax
	,@JNTax
	,@OCTax
	,@ExtraTax
	,@DiscriptionTax
	,@B2BMarkup
	,NULL --@BookingStatus
	,@YMTax
	,@WOTax
	,@OBTax
	,@RFTax
	,@ticketnumber
	,(CASE WHEN @ticketnumber2 IS NULL OR @ticketnumber2 = '' THEN @ticketnumber ELSE @ticketnumber2 END)
	,@Baggage
	,@IATACommission
	,@PLBCommission
	,@DropnetCommission
	,@BFC
	,@GST
	,@ServiceFee
	,@TDSonIATA
	,@GSTonPLB
	,@TDSonPLB
	,@PanNumber
	,@Nationalty
	,@PanCardValidation
	,@MarkOn
	,@FrequentFlyerNumber
	,@K7Tax)

	SELECT SCOPE_IDENTITY();
END
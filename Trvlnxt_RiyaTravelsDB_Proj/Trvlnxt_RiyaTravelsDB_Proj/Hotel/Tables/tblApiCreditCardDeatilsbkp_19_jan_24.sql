CREATE TABLE [Hotel].[tblApiCreditCardDeatilsbkp_19_jan_24] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [BookingId]      VARCHAR (80)  NULL,
    [Email]          VARCHAR (100) NULL,
    [Phone]          VARCHAR (50)  NULL,
    [BillingAddress] VARCHAR (MAX) NULL,
    [NameOnCard]     VARCHAR (100) NULL,
    [number]         VARCHAR (200) NULL,
    [ExpiryMonth]    INT           NULL,
    [ExpiryYear]     INT           NULL,
    [Cvv]            INT           NULL,
    [IsUser]         VARCHAR (50)  NULL,
    [InsertedDate]   DATETIME      NULL,
    [Amount]         VARCHAR (100) NULL,
    [Currency]       VARCHAR (50)  NULL,
    [CardType]       VARCHAR (150) NULL
);


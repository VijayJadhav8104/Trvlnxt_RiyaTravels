CREATE TABLE [dbo].[mCardDetailsHistory] (
    [ID]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Action]           VARCHAR (10)   NOT NULL,
    [BankName]         VARCHAR (200)  NULL,
    [CardType]         VARCHAR (50)   NULL,
    [CardNumber]       VARCHAR (1000) NULL,
    [ExpiryDate]       VARCHAR (500)  NULL,
    [CardTypeCode]     VARCHAR (10)   NULL,
    [ModifiedBy]       INT            NOT NULL,
    [ModifiedOn]       DATETIME       CONSTRAINT [DF_mCardDetailsHistory_ModifiedOn] DEFAULT (getdate()) NOT NULL,
    [MarketPoint]      VARCHAR (30)   NULL,
    [UserType]         VARCHAR (10)   NULL,
    [StreetAddress]    VARCHAR (250)  NULL,
    [City]             VARCHAR (30)   NULL,
    [State]            VARCHAR (30)   NULL,
    [Country]          VARCHAR (30)   NULL,
    [PostalCode]       INT            NULL,
    [CardHolderName]   VARCHAR (100)  NULL,
    [VerificationCode] VARCHAR (500)  NULL,
    [MaskCardNumber]   VARCHAR (1000) NULL,
    [Configuration]    VARCHAR (30)   NULL,
    CONSTRAINT [PK_mCardDetailsHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


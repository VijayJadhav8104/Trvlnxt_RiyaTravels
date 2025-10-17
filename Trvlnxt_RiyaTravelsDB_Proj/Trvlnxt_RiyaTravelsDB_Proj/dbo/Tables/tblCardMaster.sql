CREATE TABLE [dbo].[tblCardMaster] (
    [pkid]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BankName]     VARCHAR (200) NULL,
    [CardType]     VARCHAR (50)  NULL,
    [CardNumber]   VARCHAR (20)  NULL,
    [ExpiryDate]   VARCHAR (10)  NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_tblCardMaster_InsertedDate] DEFAULT (getdate()) NULL,
    [InsertedBy]   INT           NULL,
    [UpdatedDate]  DATETIME      NULL,
    [UpdatedBy]    INT           NULL,
    [Status]       BIT           CONSTRAINT [DF_tblCardMaster_Status] DEFAULT ((1)) NULL,
    [CardTypeCode] NCHAR (10)    NULL,
    [MarketPoint]  VARCHAR (50)  NULL,
    [UserType]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblCardMaster] PRIMARY KEY CLUSTERED ([pkid] ASC)
);


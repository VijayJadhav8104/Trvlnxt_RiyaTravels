CREATE TABLE [dbo].[mCardMasterHistory] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Action]       VARCHAR (10)  NOT NULL,
    [BankName]     VARCHAR (200) NULL,
    [CardType]     VARCHAR (50)  NULL,
    [CardNumber]   VARCHAR (20)  NULL,
    [ExpiryDate]   VARCHAR (10)  NULL,
    [CardTypeCode] VARCHAR (10)  NULL,
    [ModifiedBy]   INT           NOT NULL,
    [ModifiedOn]   DATETIME      CONSTRAINT [DF_mCardMasterHistory_ModifiedOn] DEFAULT (getdate()) NOT NULL,
    [MarketPoint]  VARCHAR (50)  NULL,
    [UserType]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_mCardMasterHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


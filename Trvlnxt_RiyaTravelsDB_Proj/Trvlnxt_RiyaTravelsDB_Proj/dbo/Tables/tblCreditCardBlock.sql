CREATE TABLE [dbo].[tblCreditCardBlock] (
    [ID]          BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeID]    VARCHAR (50) NULL,
    [AirlineCode] VARCHAR (50) NULL,
    [Status]      BIT          CONSTRAINT [DF_tblCreditCardBlock_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblCreditCardBlock] PRIMARY KEY CLUSTERED ([ID] ASC)
);


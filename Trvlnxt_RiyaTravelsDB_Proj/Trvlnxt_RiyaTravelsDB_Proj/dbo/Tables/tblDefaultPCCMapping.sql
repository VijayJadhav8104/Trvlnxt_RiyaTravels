CREATE TABLE [dbo].[tblDefaultPCCMapping] (
    [ID]           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PCC]          VARCHAR (50) NULL,
    [UserType]     VARCHAR (10) NULL,
    [CountryCode]  VARCHAR (10) NULL,
    [Country]      VARCHAR (50) NULL,
    [intercompany] BIT          NULL,
    CONSTRAINT [PK_tblDefaultPCCMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


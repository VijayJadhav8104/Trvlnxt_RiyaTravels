CREATE TABLE [dbo].[tblactionCodes_EY] (
    [ID]               BIGINT       IDENTITY (1, 1) NOT NULL,
    [Code]             VARCHAR (30) NOT NULL,
    [Inseterddatetime] DATETIME     CONSTRAINT [DF_tblactionCodes_EY_Inseterddatetime] DEFAULT (getdate()) NOT NULL,
    [GDSPnr]           VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_tblactionCodes_EY] PRIMARY KEY CLUSTERED ([ID] ASC)
);


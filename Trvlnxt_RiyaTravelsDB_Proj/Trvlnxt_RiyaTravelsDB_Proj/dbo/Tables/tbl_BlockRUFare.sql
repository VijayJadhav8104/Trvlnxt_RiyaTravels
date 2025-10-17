CREATE TABLE [dbo].[tbl_BlockRUFare] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]    VARCHAR (50) NULL,
    [CountryCode] VARCHAR (50) NULL,
    [OfficeID]    VARCHAR (50) NULL,
    [AirLineCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_BlockRUFare] PRIMARY KEY CLUSTERED ([ID] ASC)
);


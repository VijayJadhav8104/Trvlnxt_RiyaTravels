CREATE TABLE [dbo].[tblFareTypeFilter] (
    [ID]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fltFareName]   VARCHAR (50) NULL,
    [FareType]      VARCHAR (50) NULL,
    [IsActive]      BIT          NULL,
    [ProductClass]  VARCHAR (40) NULL,
    [FareIndicator] VARCHAR (10) NULL,
    [FareColor]     VARCHAR (20) NULL,
    [OfficeId]      VARCHAR (20) NULL,
    [Carrier]       VARCHAR (5)  NULL,
    CONSTRAINT [PK_tblFareTypeFilter] PRIMARY KEY CLUSTERED ([ID] ASC)
);


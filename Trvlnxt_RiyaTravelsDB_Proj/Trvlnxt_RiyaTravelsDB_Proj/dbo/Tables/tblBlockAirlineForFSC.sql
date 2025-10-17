CREATE TABLE [dbo].[tblBlockAirlineForFSC] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [AirlineCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblBlockAirlineForFSC] PRIMARY KEY CLUSTERED ([ID] ASC)
);


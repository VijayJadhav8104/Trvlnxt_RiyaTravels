CREATE TABLE [dbo].[mstFareTye] (
    [ID]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FareType]      VARCHAR (10) NULL,
    [FareIndicator] VARCHAR (50) NULL,
    CONSTRAINT [PK_mstFareTye] PRIMARY KEY CLUSTERED ([ID] ASC)
);


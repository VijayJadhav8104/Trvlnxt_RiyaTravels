CREATE TABLE [dbo].[mFareBasisMapping] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [FareBaisLetter]    VARCHAR (50)    NULL,
    [FareBasisPosition] NUMERIC (18, 2) NULL,
    [SameAirline]       NUMERIC (18, 2) NULL,
    [CoreshareAirline]  NUMERIC (18, 2) NULL,
    [DealMappingID]     INT             NULL,
    [CreatedOn]         DATETIME        NULL,
    CONSTRAINT [PK_mFareBasisMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


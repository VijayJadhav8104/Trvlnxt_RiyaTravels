CREATE TABLE [dbo].[mFareBasisMappingHistory] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [FareBaisLetter]    VARCHAR (50)    NULL,
    [FareBasisPosition] NUMERIC (18, 2) NULL,
    [SameAirline]       NUMERIC (18, 2) NULL,
    [CoreshareAirline]  NUMERIC (18, 2) NULL,
    [DealMappingID]     INT             NULL,
    [ModifiedDate]      DATETIME        NULL,
    [ModifiedBy]        INT             NULL,
    CONSTRAINT [PK_mFareBasisMappingHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


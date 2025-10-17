CREATE TABLE [dbo].[mRBDMappingHistory] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [RBD]                 VARCHAR (50)    NULL,
    [FareBaisLetter]      VARCHAR (50)    NULL,
    [FareBasisPercentage] NUMERIC (18, 2) NULL,
    [FareBasisPosition]   NUMERIC (18, 2) NULL,
    [RBDPerentage]        NUMERIC (18, 2) NULL,
    [DealMappingID]       INT             NULL,
    [ModifiedDate]        DATETIME        NULL,
    [ModifiedBy]          INT             NULL,
    [FareBasisPositionB]  NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_mRBDMappingHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


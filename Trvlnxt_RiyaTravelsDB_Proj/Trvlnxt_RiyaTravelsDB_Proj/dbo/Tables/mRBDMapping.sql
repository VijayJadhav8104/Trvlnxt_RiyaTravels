CREATE TABLE [dbo].[mRBDMapping] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [RBD]                 VARCHAR (50)    NULL,
    [FareBaisLetter]      VARCHAR (50)    NULL,
    [FareBasisPercentage] NUMERIC (18, 2) NULL,
    [FareBasisPosition]   NUMERIC (18, 2) NULL,
    [RBDPerentage]        NUMERIC (18, 2) NULL,
    [DealMappingID]       INT             NULL,
    [CreatedOn]           DATETIME        NULL,
    [FareBasisPositionB]  NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_mRBDMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250623-173251]
    ON [dbo].[mRBDMapping]([DealMappingID] ASC)
    INCLUDE([ID], [RBD], [FareBaisLetter], [FareBasisPercentage], [FareBasisPosition], [RBDPerentage], [CreatedOn], [FareBasisPositionB]);


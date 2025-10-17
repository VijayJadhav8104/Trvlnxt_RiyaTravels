CREATE TABLE [dbo].[mROEAgencyMapping] (
    [ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ROEId]       INT           NOT NULL,
    [AgencyId]    INT           NULL,
    [IsAllAgency] BIT           CONSTRAINT [DF_mROEAgencyMapping_IsAllAgency] DEFAULT ((0)) NOT NULL,
    [CreatedOn]   DATETIME      CONSTRAINT [DF_mROEAgencyMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedOn]  DATETIME      CONSTRAINT [DF_mROEAgencyMapping_ModifiedOn] DEFAULT (getdate()) NULL,
    [CreatedBy]   INT           NOT NULL,
    [ModifiedBy]  INT           NULL,
    [IsActive]    BIT           CONSTRAINT [DF_mROEAgencyMapping_IsActive] DEFAULT ((1)) NOT NULL,
    [AgencyName]  VARCHAR (MAX) NULL,
    CONSTRAINT [PK_mROEAgencyMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250610-123132]
    ON [dbo].[mROEAgencyMapping]([AgencyId] ASC, [IsAllAgency] ASC, [ROEId] ASC, [IsActive] ASC);


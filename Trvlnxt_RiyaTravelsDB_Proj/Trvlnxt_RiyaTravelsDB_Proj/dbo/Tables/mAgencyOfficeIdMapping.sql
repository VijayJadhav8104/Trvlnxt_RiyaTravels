CREATE TABLE [dbo].[mAgencyOfficeIdMapping] (
    [ID]        INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]   INT          NOT NULL,
    [OfficeId]  VARCHAR (50) NULL,
    [FKmVendor] INT          NULL,
    [CreatedOn] DATETIME     CONSTRAINT [DF_mAgencyOfficeIdMapping_CreatedOn] DEFAULT (getdate()) NULL,
    [IsActive]  BIT          CONSTRAINT [DF_mAgencyOfficeIdMapping_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_mAgencyOfficeIdMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


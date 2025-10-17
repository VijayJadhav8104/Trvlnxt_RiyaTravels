CREATE TABLE [dbo].[mUserCountryMapping_bkp7april2022] (
    [ID]           INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]       INT             NULL,
    [CountryId]    INT             NULL,
    [CreatedOn]    DATETIME        CONSTRAINT [DF_mUserCountryMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT             NULL,
    [ModifiedOn]   DATETIME2 (7)   CONSTRAINT [DF_mUserCountryMapping_ModifiedOn] DEFAULT (getdate()) NULL,
    [ModifiedBy]   INT             NULL,
    [isActive]     BIT             CONSTRAINT [DF_mUserCountryMapping_isActive] DEFAULT ((1)) NULL,
    [AgentBalance] DECIMAL (18, 3) NULL,
    CONSTRAINT [PK_mUserCountryMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);


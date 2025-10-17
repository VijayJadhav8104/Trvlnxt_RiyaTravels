CREATE TABLE [dbo].[mUserCountryMapping] (
    [ID]           INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]       INT             NULL,
    [CountryId]    INT             NULL,
    [CreatedOn]    DATETIME        CONSTRAINT [DF_mUserCountryMapping_CreatedOnnew] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    INT             NULL,
    [ModifiedOn]   DATETIME2 (7)   CONSTRAINT [DF_mUserCountryMapping_ModifiedOnnew] DEFAULT (getdate()) NULL,
    [ModifiedBy]   INT             NULL,
    [isActive]     BIT             CONSTRAINT [DF_mUserCountryMapping_isActivenew] DEFAULT ((1)) NULL,
    [AgentBalance] DECIMAL (18, 3) NULL,
    CONSTRAINT [PK_mUserCountryMappingnew] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [mUserCountryMapping_CountryId]
    ON [dbo].[mUserCountryMapping]([CountryId] ASC);


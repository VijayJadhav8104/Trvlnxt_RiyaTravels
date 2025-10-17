CREATE TABLE [dbo].[tblAgencySearchHistory] (
    [ID]             INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SearchBy]       INT      NULL,
    [AgencyID]       INT      NULL,
    [SearchDateTime] DATETIME CONSTRAINT [DF_tblAgencySearchHistory_SearchDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblAgencySearchHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);


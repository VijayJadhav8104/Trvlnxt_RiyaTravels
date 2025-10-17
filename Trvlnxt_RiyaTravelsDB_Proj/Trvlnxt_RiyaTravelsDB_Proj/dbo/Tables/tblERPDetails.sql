CREATE TABLE [dbo].[tblERPDetails] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OwnerID]      VARCHAR (50)  NULL,
    [OwnerCountry] VARCHAR (2)   NULL,
    [AgentCountry] VARCHAR (2)   NULL,
    [ERPCountry]   VARCHAR (2)   NULL,
    [VendorCode]   VARCHAR (50)  NULL,
    [CustomerCode] VARCHAR (50)  NULL,
    [UserTypeID]   INT           NULL,
    [VendorName]   VARCHAR (100) NULL,
    CONSTRAINT [PK_tblERPDetails] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tblERPDetails_OwnerID]
    ON [dbo].[tblERPDetails]([OwnerID] ASC);


GO
CREATE NONCLUSTERED INDEX [tblERPDetails_AgentCountry]
    ON [dbo].[tblERPDetails]([AgentCountry] ASC);


GO
CREATE NONCLUSTERED INDEX [tblERPDetails_ERPCountry]
    ON [dbo].[tblERPDetails]([ERPCountry] ASC);


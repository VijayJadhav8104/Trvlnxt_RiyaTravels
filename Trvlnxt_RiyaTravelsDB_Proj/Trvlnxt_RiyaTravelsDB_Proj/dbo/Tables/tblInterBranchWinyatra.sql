CREATE TABLE [dbo].[tblInterBranchWinyatra] (
    [Id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkStateId]  INT           NULL,
    [State]      VARCHAR (100) NULL,
    [Icust]      VARCHAR (100) NULL,
    [HotelIcust] VARCHAR (100) NULL,
    [RH Ledgers] VARCHAR (100) NULL,
    [BranchId]   VARCHAR (100) NULL,
    [SubLed]     VARCHAR (5)   NULL,
    [createdOn]  DATETIME      CONSTRAINT [DF_tblInterBranchWinyatra_createdOn] DEFAULT (getdate()) NULL,
    [IsActive]   INT           NULL,
    [Country]    VARCHAR (10)  NULL,
    CONSTRAINT [PK_tblInterBranchWinyatra] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Icust]
    ON [dbo].[tblInterBranchWinyatra]([Icust] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Country]
    ON [dbo].[tblInterBranchWinyatra]([Country] ASC);


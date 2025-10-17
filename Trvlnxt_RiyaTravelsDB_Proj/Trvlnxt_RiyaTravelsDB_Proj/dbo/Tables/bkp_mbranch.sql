CREATE TABLE [dbo].[bkp_mbranch] (
    [ID]               INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Code]             VARCHAR (10) NULL,
    [ServiceTax_RegNo] VARCHAR (50) NULL,
    [State_Code]       VARCHAR (5)  NULL,
    [GST_RegNo]        VARCHAR (50) NULL,
    [BranchCode]       VARCHAR (20) NULL,
    [Name]             VARCHAR (50) NULL,
    [Division]         VARCHAR (15) NULL
);


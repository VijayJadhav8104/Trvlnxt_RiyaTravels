CREATE TABLE [dbo].[tblAgentLimitAlert] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [ERPCode]          VARCHAR (50)    NULL,
    [EntityNameOnTool] VARCHAR (250)   NULL,
    [Country]          VARCHAR (50)    NULL,
    [BillCurrency]     VARCHAR (10)    NULL,
    [PCC]              VARCHAR (20)    NULL,
    [Limit]            DECIMAL (18, 2) NULL,
    [ToEmail]          VARCHAR (2000)  NULL,
    [CcEmail]          VARCHAR (2000)  NULL
);


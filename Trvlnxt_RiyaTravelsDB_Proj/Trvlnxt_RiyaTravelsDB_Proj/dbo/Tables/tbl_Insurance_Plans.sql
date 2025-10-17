CREATE TABLE [dbo].[tbl_Insurance_Plans] (
    [PKID]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Plan]         VARCHAR (50)  NOT NULL,
    [PlanID]       VARCHAR (250) NOT NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_tbl_Insurance_Plans_InsertedDate] DEFAULT (getdate()) NOT NULL,
    [Status]       BIT           CONSTRAINT [DF_tbl_Insurance_Plans_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tbl_Insurance_Plans] PRIMARY KEY CLUSTERED ([PKID] ASC)
);


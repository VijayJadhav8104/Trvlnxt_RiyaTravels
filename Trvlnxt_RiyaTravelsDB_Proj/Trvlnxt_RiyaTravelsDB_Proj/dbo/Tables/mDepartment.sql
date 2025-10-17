CREATE TABLE [dbo].[mDepartment] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DepartmentName] VARCHAR (100) NULL,
    [Status]         BIT           CONSTRAINT [DF_mDepartment_Status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_mDepartment] PRIMARY KEY CLUSTERED ([ID] ASC)
);


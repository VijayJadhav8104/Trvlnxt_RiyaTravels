CREATE TABLE [dbo].[EventUser] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EmployeeCode] INT           NULL,
    [EmployeeName] VARCHAR (250) NOT NULL,
    [Email]        VARCHAR (250) NOT NULL,
    [Password]     VARCHAR (250) NOT NULL,
    [RoleCode]     VARCHAR (15)  NULL,
    [DepartmentID] INT           NULL,
    [Status]       BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


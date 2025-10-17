CREATE TABLE [dbo].[muser_backup13042020] (
    [ID]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FullName]        VARCHAR (50)  NULL,
    [UserName]        VARCHAR (100) NULL,
    [Password]        VARCHAR (128) NULL,
    [MobileNo]        VARCHAR (15)  NULL,
    [EmailID]         VARCHAR (100) NULL,
    [LocationID]      INT           NULL,
    [DepartmentID]    INT           NULL,
    [CountryID]       INT           NULL,
    [EmployeeNo]      INT           NULL,
    [RoleID]          INT           NULL,
    [CreatedOn]       DATETIME      NOT NULL,
    [CreatedBy]       INT           NOT NULL,
    [ModifiedOn]      DATETIME      NULL,
    [ModifiedBy]      INT           NULL,
    [isActive]        BIT           NOT NULL,
    [isResetPassword] BIT           NOT NULL,
    [SessionID]       VARCHAR (50)  NULL
);


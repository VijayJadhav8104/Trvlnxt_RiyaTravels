CREATE TABLE [dbo].[tblResumeMaster] (
    [Id]              INT            NOT NULL,
    [Title]           VARCHAR (50)   NULL,
    [FirstName]       VARCHAR (300)  NULL,
    [LastName]        VARCHAR (300)  NULL,
    [Gender]          VARCHAR (50)   NULL,
    [CurrentCompany]  VARCHAR (800)  NULL,
    [NetSalary]       VARCHAR (800)  NULL,
    [GrossSalary]     VARCHAR (800)  NULL,
    [CurrentLocation] VARCHAR (800)  NULL,
    [PreferredLoc]    VARCHAR (800)  NULL,
    [ExpectedSal]     VARCHAR (800)  NULL,
    [Resumes]         NVARCHAR (MAX) NULL,
    [FullName]        VARCHAR (800)  NULL,
    [Email]           VARCHAR (MAX)  NULL,
    [Phone]           VARCHAR (800)  NULL,
    [LinkedInURL]     VARCHAR (MAX)  NULL,
    [PortfolioURL]    VARCHAR (MAX)  NULL,
    [COVERINGLETTER]  VARCHAR (MAX)  NULL,
    [CreatedDate]     DATETIME       NULL,
    CONSTRAINT [PK_tblResumeMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);


CREATE TABLE [Hotel].[BillingContact] (
    [Id]         INT          NOT NULL,
    [type]       VARCHAR (50) NOT NULL,
    [title]      VARCHAR (50) NULL,
    [firstName]  VARCHAR (50) NULL,
    [middleName] VARCHAR (50) NULL,
    [lastName]   VARCHAR (50) NULL,
    [suffix]     VARCHAR (50) NULL,
    [age]        INT          NULL,
    [phone]      VARCHAR (50) NULL,
    [email]      VARCHAR (50) NULL,
    [line1]      VARCHAR (50) NULL,
    [line2]      VARCHAR (50) NULL,
    [CityCode]   VARCHAR (50) NULL,
    [City]       VARCHAR (50) NULL,
    [Statename]  VARCHAR (50) NULL,
    [Statecode]  VARCHAR (50) NULL,
    [Conname]    VARCHAR (50) NULL,
    [Concode]    VARCHAR (50) NULL,
    [PostalCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_BillingContact] PRIMARY KEY CLUSTERED ([Id] ASC)
);


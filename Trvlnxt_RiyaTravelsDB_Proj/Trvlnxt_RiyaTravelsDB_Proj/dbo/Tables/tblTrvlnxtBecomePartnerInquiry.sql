CREATE TABLE [dbo].[tblTrvlnxtBecomePartnerInquiry] (
    [ID]                        INT              IDENTITY (1, 1) NOT NULL,
    [AgencyName]                VARCHAR (50)     NULL,
    [EmailID]                   VARCHAR (50)     NULL,
    [MobileNo]                  VARCHAR (50)     NULL,
    [Message]                   VARCHAR (MAX)    NULL,
    [CreatedDate]               DATETIME         NULL,
    [ContactPersonName]         VARCHAR (50)     NULL,
    [TypeOfEstablishment]       VARCHAR (50)     NULL,
    [DirectorsName]             VARCHAR (50)     NULL,
    [CompanyRegistrationNumber] VARCHAR (30)     NULL,
    [Address]                   VARCHAR (200)    NULL,
    [Country]                   VARCHAR (20)     NULL,
    [City]                      VARCHAR (30)     NULL,
    [State]                     VARCHAR (30)     NULL,
    [PinCode]                   VARCHAR (10)     NULL,
    [InquiryGuid]               UNIQUEIDENTIFIER NULL,
    [PanCardNo]                 VARCHAR (10)     NULL,
    [CountryCode]               NVARCHAR (30)    NULL,
    [Source]                    VARCHAR (20)     CONSTRAINT [DF_tblTrvlnxtBecomePartnerInquiry_Source] DEFAULT ('TrvlNxt') NULL,
    [UpdatedDate]               DATETIME         NULL,
    CONSTRAINT [PK__tblTrvln__3214EC27015ADBCF] PRIMARY KEY CLUSTERED ([ID] ASC)
);


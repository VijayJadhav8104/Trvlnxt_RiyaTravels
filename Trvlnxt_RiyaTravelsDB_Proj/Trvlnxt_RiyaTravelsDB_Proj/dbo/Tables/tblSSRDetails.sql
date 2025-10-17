CREATE TABLE [dbo].[tblSSRDetails] (
    [pkid]              BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fkBookMaster]      BIGINT          NULL,
    [fkPassengerid]     BIGINT          NULL,
    [fkItenary]         BIGINT          NULL,
    [SSR_Type]          VARCHAR (25)    NULL,
    [SSR_Name]          VARCHAR (MAX)   NULL,
    [SSR_Code]          VARCHAR (50)    NULL,
    [SSR_Amount]        DECIMAL (18, 2) NULL,
    [SSR_Status]        TINYINT         NULL,
    [createdDate]       DATETIME        NULL,
    [createdBy]         INT             NULL,
    [updatedDate]       DATETIME        NULL,
    [updatedBy]         INT             NULL,
    [ERPTicketNum]      VARCHAR (100)   NULL,
    [ParentOrderId]     VARCHAR (50)    NULL,
    [ERPPushStatus]     BIT             NULL,
    [CancERPPuststatus] BIT             NULL,
    [ERPResponseID]     VARCHAR (100)   NULL,
    [CancERPResponseID] VARCHAR (100)   NULL,
    [SSR_Request]       VARCHAR (MAX)   NULL,
    [SSR_Response]      VARCHAR (MAX)   NULL,
    [SSR_CanRequest]    VARCHAR (MAX)   NULL,
    [SSR_CanResponse]   VARCHAR (MAX)   NULL,
    [EMDTicketNumber]   VARCHAR (50)    NULL,
    [TrackID]           VARCHAR (MAX)   NULL,
    [ROE]               DECIMAL (18, 8) NULL,
    [ssrBookingType]    VARCHAR (50)    NULL,
    [EMDAirLineCode]    VARCHAR (50)    NULL,
    CONSTRAINT [PK_tblSSRDetails] PRIMARY KEY CLUSTERED ([pkid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tblSSRDetails_fkPassengerid]
    ON [dbo].[tblSSRDetails]([fkPassengerid] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-fkbookmaster-20230713-151700]
    ON [dbo].[tblSSRDetails]([fkBookMaster] ASC);


GO
CREATE NONCLUSTERED INDEX [Noncluster_composite_Index_1212]
    ON [dbo].[tblSSRDetails]([SSR_Type] ASC, [SSR_Status] ASC, [SSR_Amount] ASC)
    INCLUDE([fkBookMaster], [fkPassengerid]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-ERPTicketNum]
    ON [dbo].[tblSSRDetails]([ERPTicketNum] ASC);


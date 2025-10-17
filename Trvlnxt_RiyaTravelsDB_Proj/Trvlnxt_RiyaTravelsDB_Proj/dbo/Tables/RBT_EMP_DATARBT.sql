CREATE TABLE [dbo].[RBT_EMP_DATARBT] (
    [COMPANY]                                                          NVARCHAR (255) NULL,
    [SUBUNIT]                                                          NVARCHAR (255) NULL,
    [TRAVELER_TYPE]                                                    FLOAT (53)     NULL,
    [FIRST_NAME]                                                       NVARCHAR (255) NULL,
    [MIDDLE_NAME]                                                      NVARCHAR (255) NULL,
    [LAST_NAME]                                                        NVARCHAR (255) NULL,
    [UNIQUE ID]                                                        FLOAT (53)     NULL,
    [PERNR]                                                            FLOAT (53)     NULL,
    [WORK_EMAIL_ADDRESS]                                               NVARCHAR (255) NULL,
    [COST_CENTER]                                                      NVARCHAR (255) NULL,
    [COMPANY_CODE]                                                     FLOAT (53)     NULL,
    [BU_LOCATION_CODE]                                                 NVARCHAR (255) NULL,
    [DATE_OF_BIRTH]                                                    FLOAT (53)     NULL,
    [GENDER]                                                           NVARCHAR (255) NULL,
    [AUTHORIZER_UNIQUE_ID]                                             FLOAT (53)     NULL,
    [CONCUR_LOGIN_ID]                                                  NVARCHAR (255) NULL,
    [BAND_CODE                                                       ] NVARCHAR (MAX) NULL
);


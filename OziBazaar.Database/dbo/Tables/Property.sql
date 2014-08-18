CREATE TABLE [dbo].[Property](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[KeyName] [nvarchar](250) NOT NULL,
	[Title] [nvarchar](250)  NULL,
	[ControlType] [nvarchar](50) NULL,
	[DataType] [nvarchar](100) NULL,
	[LookupType] [nvarchar](150) NULL,
	[DependsOn] [nvarchar](150) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)
)




GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Property]
    ON [dbo].[Property]([PropertyID] ASC);

GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_DataType] CHECK  (([DataType]='Image' OR [DataType]='Lookup' OR [DataType]='bool' OR [DataType]='String'))
GO

ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_DataType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_ValidLookupType] CHECK  (([lookupType] IS NULL OR [dbo].[IsValidLookupType]([lookupType])=(1)))
GO

ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_ValidLookupType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_ControlType] CHECK  (([ControlType]='Image' OR [ControlType]='RadioButton' OR [ControlType]='CheckBox' OR [ControlType]='DropDown' OR [ControlType]='TextArea' OR [ControlType]='TextBox'))
GO

ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_ControlType]
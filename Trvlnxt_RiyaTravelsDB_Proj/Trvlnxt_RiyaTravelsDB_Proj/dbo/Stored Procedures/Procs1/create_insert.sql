  
CREATE procedure create_insert(@schema    varchar(200) = 'dbo',  
                                   @table     varchar(200),  
                                   @where     nvarchar(max) = null,  
                                   @top       int = null,  
                                   @insert    varchar(max) output)  
as  
begin  
  declare @insert_fields varchar(max),  
          @select        varchar(max),  
          @error         varchar(500),  
          @query         varchar(max);  
  
  declare @values table(description varchar(max));  
  
  set nocount on;  
  
  -- Get columns  
  select @insert_fields = isnull(@insert_fields + ', ', '') + c.name,  
         @select = case type_name(c.system_type_id)  
                      when 'varchar' then isnull(@select + ' + '', '' + ', '') + ' isnull('''''''' + cast(' + c.name + ' as varchar) + '''''''', ''null'')'  
                      when 'datetime' then isnull(@select + ' + '', '' + ', '') + ' isnull('''''''' + convert(varchar, ' + c.name + ', 121) + '''''''', ''null'')'  
                      else isnull(@select + ' + '', '' + ', '') + 'isnull(cast(' + c.name + ' as varchar), ''null'')'  
                    end  
    from sys.columns c with(nolock)  
         inner join sys.tables t with(nolock) on t.object_id = c.object_id  
         inner join sys.schemas s with(nolock) on s.schema_id = t.schema_id  
   where s.name = @schema  
     and t.name = @table;  
  
  -- If there's no columns...  
  if @insert_fields is null or @select is null  
  begin  
    set @error = 'There''s no ' + @schema + '.' + @table + ' inside the target database.';  
    raiserror(@error, 16, 1);  
    return;  
  end;  
  
  set @insert_fields = 'insert into ' + @schema + '.' + @table + '(' + @insert_fields + ')';  
  
  if isnull(@where, '') <> '' and charindex('where', ltrim(rtrim(@where))) < 1  
  begin  
    set @where = 'where ' + @where;  
  end  
  else  
  begin  
    set @where = '';  
  end;  
  
  set @query = 'select ' + isnull('top(' + cast(@top as varchar) + ')', '') + @select + ' from ' + @schema + '.' + @table + ' with (nolock) ' + @where;  
  
  insert into @values(description)  
  exec(@query);  
  
  set @insert = isnull(@insert + char(10), '') + '--' + upper(@schema + '.' + @table);  
  
  select @insert = @insert + char(10) + @insert_fields + char(10) + 'values(' + v.description + ');' + char(10) + 'go' + char(10)  
    from @values v  
   where isnull(v.description, '') <> '';  
end;  
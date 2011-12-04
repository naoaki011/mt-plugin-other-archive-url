# &lt;mt:OtherArchiveURL&gt;

A function tag which output archive url of non preffered template map in archive context.

    <ul>
        <MTArchiveList archive_type="Category">
            <li><a href="<$MTOtherArchiveURL label="Category Archives of SmartPhone"$>"><$MTArchiveTitle$></a></li>
        </MTArchiveList>
    </ul>

This plugin support all of Movable Type default archive type.

## Attributes

- id modifier
- identifier modifier
- label modifier
- map_id modifier

### id

    <$MTOtherArchiveURL id="24"$>

id is a template_id.

### identifier

    <$MTOtherArchiveURL identifier="category_listings_for_smartphone"$>

identifier is a template_identifier.

### label

    <$MTOtherArchiveURL label="Category Archives of SmartPhone"$>

label is a template_label.

### label

    <$MTOtherArchiveURL archive_file_name="%c/%f"$>

archive_file_name is a archive_file_name of archive_mapping.

> TIP:  
> 'id' and 'identifier' and 'label' and 'archive_file_name' is exclusive.  
> priority is 'id' &gt; 'identifier' &gt; 'label' &gt; 'archive_file_name'.  

### map_id

    <$MTOtherArchiveURL label="Category Archives of SmartPhone" map_id="30"$>

map_id is a template_map id  
If the template has multiple archive_mappings of same context.  
map_id is assign to the target archive mapping.  

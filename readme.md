&lt;mt:OtherArchiveURL&gt;

# A function tag which output archive url of non preffered template map in archive context.

    <ul>
        <MTArchiveList archive_type="Category">
            <li><a href="<$MTAnotherURL label="Category Archives of SmartPhone"$>"><$MTArchiveTitle$></a></li>
        </MTArchiveList>
    </ul>

## Attributes

- id modifier
- identifier modifier
- label modifier
- map_id modifier

### id

    <$MTAnotherURL id="24"$>

id is a template_id.

### identifier

    <$MTAnotherURL identifier="category_listings_for_smartphone"$>

identifier is a template_identifier.

### label

    <$MTAnotherURL label="Category Archives of SmartPhone"$>

label is a template_label.

### map_id

    <$MTAnotherURL label="Category Archives of SmartPhone" map_id="30"$>

map_id is a template_map id
If the template has multiple archive_mappings of same context.
map_id is assign to the target archive mapping.
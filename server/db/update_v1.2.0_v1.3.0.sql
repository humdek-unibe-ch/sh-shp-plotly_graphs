-- add plugin entry in the plugin table
UPDATE plugins
SET version = 'v1.3.0'
WHERE name = 'plotly-graphs';

UPDATE `fields`
SET id_type = get_field_type_id('json')
WHERE `name` = 'traces';
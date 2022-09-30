-- add plugin entry in the plugin table
UPDATE plugins
SET version = 'v1.1.0'
WHERE name = 'plotly-graphs';

INSERT IGNORE INTO `fieldType` (`id`, `name`, `position`) VALUES (NULL, 'dynamic_json', '15');

UPDATE `fields`
SET id_type = get_field_type_id('dynamic_json')
WHERE `name` = 'traces';
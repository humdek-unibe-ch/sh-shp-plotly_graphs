-- add plugin entry in the plugin table
INSERT IGNORE INTO plugins (name, version) 
VALUES ('plotly-graphs', 'v1.1.0');

INSERT IGNORE INTO `fieldType` (`id`, `name`, `position`) VALUES (NULL, 'dynamic_json', '15');

UPDATE `fields`
SET id_type = get_field_type_id('dynamic_json')
WHERE `name` = 'traces';
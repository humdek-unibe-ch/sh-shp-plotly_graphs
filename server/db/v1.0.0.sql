-- add plugin entry in the plugin table
INSERT IGNORE INTO plugins (name, version) 
VALUES ('plotly-graphs', 'v1.0.0');

-- add style graph and all its fields
INSERT IGNORE INTO `styleGroup` (`id`, `name`, `description`, `position`) VALUES (NULL, 'Graph', 'Graph styles allow to draw graps and diagrams based on static (uploaded assets) or dynamic (user input) data.', 55);

INSERT IGNORE INTO `styles` (`id`, `name`, `id_type`, `id_group`, `description`) VALUES (NULL, 'graph', '0000000002', (SELECT id FROM styleGroup WHERE `name` = 'Graph' LIMIT 1), 'The most general graph style which allows to render a vast variety of graphs but requires extensive configuration. All other graph styles are based on this style.');
SET @id_style = LAST_INSERT_ID();

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'traces', 8, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graph'), get_field_id('traces'), NULL, 'Define the data traces to be rendered. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'layout', 8, 1);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graph'), get_field_id('layout'), NULL, 'Define the layout of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'config', 8, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graph'), get_field_id('config'), NULL, 'Define the configuration of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'title');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graph'), get_field_id('title'), NULL, 'The title to be rendered on top of teh graph. This field is here purely for convenience as the title of a graph can also be defined in the field `layout`');

-- add style graphSankey and all its fields
INSERT IGNORE INTO `styles` (`id`, `name`, `id_type`, `id_group`, `description`) VALUES (NULL, get_style_id('graphSankey'), '0000000002', (SELECT id FROM styleGroup WHERE `name` = 'Graph' LIMIT 1), 'Create a Sankey diagram from user input data or imported static data.');
SET @id_style = LAST_INSERT_ID();

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'title');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), @id_field, NULL, 'The title of the Sankey diagram.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'form_field_names', 8, 1);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('form_field_names'), NULL, 'In order to create a Sankey diagram from a set of user input data two types of information are required:\n 1. the form field names defined here (think of it as the column headers of a table where each row holds the data of one subject)\n 2. the value types defined in `value_types` (the value entered by the subject).\n\nThe Sankey diagram consist of *nodes* and *links*. All possible combinations of form field names (1) and value types (2) define the nodes in a Sankey diagram. The links are computed by accumulating all values of the same type (2) when transitioning from one field name (1) to another.\n\nThis field expects an ordered list (`json` syntax) which specifies the form field names (1) to be used to generate the Sankey diagram. The order is important because two consecutive form field names (1) form a transition. Each list item is an object with the following fields:\n - `key`: the name of the field. Use the syntax `<form_name >#<field_name>` to refer to a specific input field `<field_name>` of a specific form `<form_name>`\n - `label`: A human-readable label which can be displayed on the diagram.\n\nAn Example\n```\n[\n  { "key": "my_form#field1", "label": "Field 1" },\n  { "key": "my_form#field2", "label": "Field 2" }\n]\n```');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'value_types', 8, 1);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('value_types'), NULL, 'In order to create a Sankey diagram from a set of user input data two types of information are required:\n 1. the form field names defined in `form_field_names` (think of it as the column headers of a table where each row holds the data of one subject)\n 2. the value types defined here (the value entered by the subject).\n\nThe Sankey diagram consist of *nodes* and *links*. All possible combinations of form field names (1) and value types (2) define the nodes in a Sankey diagram. The links are computed by accumulating all values of the same type (2) when transitioning from one field name (1) to another.\n\nThis field expects an ordered list (`json` syntax) which specifies the value types (2) to be used to generate the Sankey diagram. The order is important because it may be used for node placement. Each list item is an object with the following fields:\n - `key`: the value of the value type.\n - `label`: A human-readable label which can be displayed on the diagram.\n - `color`: A hex string definig the color of the node of this type. Use a string of the following from `"#FF0000"`\n\nAn Example\n```\n[\n  { "key": 1, "label": "Value Type 1", "color": "#FF0000" },\n  { "key": 2, "label": "Value Type 2", "color": "#00FF00" }\n]\n```');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'link_color', 1, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('link_color'), NULL, 'Define the color of the links. There are four options:\n - `source`: use the color of the source node\n - `target`: use the color of the target node\n - a hex string of the from `#FF0000` to define the same color for all links\n - the empty string to use the default translucent gray');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'link_alpha', 1, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('link_alpha'), NULL, 'Define the alpha value of the color of the links. There are two options:\n - `sum`: compute the alpha value based on the width of the link\n - any number from 0 to 1: the same alpha value for all links as defined');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'min');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('min'), 1, 'The minimal required item count to form a link. In other words: what is the minimal required link width for a link to be displayed');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'has_type_labels', 3, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('has_type_labels'), 0, 'If checked, the labels defined in `value_types` are displayed next to a node with the corresponding type');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'has_field_labels', 3, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('has_field_labels'), 1, 'If checked, the label defined in `form_field_names` is displayed on top of a grouped node column. This field only has an effect if `is_grouped` is enabled.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'is_grouped', 3, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('is_grouped'), 1, 'If checked, the nodes are positioned as follows:\n - each node with the same form field name is aligned vertically (same x coordinate)\n - within one column nodes are sorted by value types (by their indices as defined in `value_types`');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'data-source');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('data-source'), NULL, 'The source of the data to be used to draw the Sankey diagram.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'single_user', 3, 0);
SET @id_field = LAST_INSERT_ID();
INSERT  IGNORE  INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphSankey'), get_field_id('single_user'), 1, 'This option only takes effect when using **dynamic** data. If checked, only data from the current logged-in user is used. If unchecked, data form all users is used.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'raw', 1, 0);

-- add graphPie style
INSERT IGNORE INTO `styles` (`id`, `name`, `id_type`, `id_group`, `description`) VALUES (NULL, 'graphPie', '0000000002', (SELECT id FROM styleGroup WHERE `name` = 'Graph' LIMIT 1), 'Create a pie diagram from user input data or imported static data.');
SET @id_style = LAST_INSERT_ID();

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'data-source');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), @id_field, NULL, 'The source of the data to be used to render a pie diagram.');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'name');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), @id_field, NULL, 'The name of the table column or form field to use to render a pie diagram.');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'value_types');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), @id_field, NULL, 'Defines the label and color for each distinct data value. Use a JSON array where each item has the following keys:\n - `key`: the data value to which the color and label will be assigned\n - `label`: to the label of the data value\n - `color`: the color of the data value (optional)\n\nAn example:\n```\n[\n  { "key": "value_1", "label", "Label 1", "color": "#ff0000" },\n  { "key": "value_2", "label", "Label 2", "color": "#00ff00" }\n}\n```');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'layout');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), @id_field, NULL, 'Define the layout of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'config');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), @id_field, NULL, 'Define the configuration of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'hole', 5, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), get_field_id('hole'), 0, 'Use this to render a donut chart. Use a percentage from 0 to 100 where 0% means no hole and 100% a hole as big as the chart.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'hoverinfo', 1, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), get_field_id('hoverinfo'), NULL, 'Allows to define the information to be rendered in the hover box. Use "none" to disable the hover box. Refer to the [Plotly.js documentation](!https://plotly.com/javascript/reference/#pie-hoverinfo) for more information.');

INSERT IGNORE INTO `fields` (`id`, `name`, `id_type`, `display`) VALUES (NULL, 'textinfo', 1, 0);
SET @id_field = LAST_INSERT_ID();
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphPie'), get_field_id('textinfo'), NULL, 'Allows to define the information to be rendered on each pie slice. Use "none" to show no text. Refer to the [Plotly.js documentation](!https://plotly.com/javascript/reference/#pie-textinfo) for more information.');

-- add graphBar style
INSERT IGNORE INTO `styles` (`id`, `name`, `id_type`, `id_group`, `description`) VALUES (NULL, 'graphBar', '0000000002', (SELECT id FROM styleGroup WHERE `name` = 'Graph' LIMIT 1), 'Create a bar diagram from user input data or imported static data.');
SET @id_style = LAST_INSERT_ID();

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'data-source');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphBar'), @id_field, NULL, 'The source of the data to be used to render a pie diagram.');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'name');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphBar'), @id_field, NULL, 'The name of the table column or form field to use to render a pie diagram.');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'layout');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphBar'), @id_field, NULL, 'Define the layout of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'config');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphBar'), @id_field, NULL, 'Define the configuration of the graph. Refer to the documentation of [Plotly.js](https://plotly.com/javascript/) for more information');

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'value_types');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphBar'), @id_field, NULL, 'Defines the label and color for each distinct data value. Use a JSON array where each item has the following keys:\n - `key`: the data value to which the color and label will be assigned\n - `label`: to the label of the data value\n - `color`: the color of the data value (optional)\n\nAn example:\n```\n[\n  { "key": "value_1", "label", "Label 1", "color": "#ff0000" },\n  { "key": "value_2", "label", "Label 2", "color": "#00ff00" }\n}\n```');

-- add graphLegend style
INSERT IGNORE INTO `styles` (`id`, `name`, `id_type`, `id_group`, `description`) VALUES (NULL, 'graphLegend', '0000000001', (SELECT id FROM styleGroup WHERE `name` = 'Graph' LIMIT 1), 'Render colored list of items. This can be used to show one global legend for multiple graphs.');
SET @id_style = LAST_INSERT_ID();

SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'value_types');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graphLegend'), @id_field, NULL, 'Defines the label and color for each distinct data value. Use a JSON array where each item has the following keys:\n - `key`: the data value to which the color and label will be assigned\n - `label`: to the label of the data value\n - `color`: the color of the data value\n\nAn example:\n```\n[\n  { "key": "value_1", "label", "Label 1", "color": "#ff0000" },\n  { "key": "value_2", "label", "Label 2", "color": "#00ff00" }\n}\n```');


SET @id_style = (SELECT `id` FROM `styles` WHERE `name` = 'graphSankey');
SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'form_field_names');
UPDATE `styles_fields` SET `help` = 'In order to create a Sankey diagram from a set of user input data two types of information are required:\r\n 1. the form field names defined here (think of it as the column headers of a table where each row holds the data of one subject)\r\n 2. the value types defined in `value_types` (the value entered by the subject).\r\n\r\nThe Sankey diagram consist of *nodes* and *links*. All possible combinations of form field names (1) and value types (2) define the nodes in a Sankey diagram. The links are computed by accumulating all values of the same type (2) when transitioning from one field name (1) to another.\r\n\r\nThis field expects an ordered list (`json` syntax) which specifies the form field names (1) to be used to generate the Sankey diagram. The order is important because two consecutive form field names (1) form a transition. Each list item is an object with the following fields:\r\n - `key`: the name of the field. When using static data this refers to a column name from the table specified in the field `data-source`. When using dynamic data this refers to a user input field name of the form specified in the field `data-source`.\r\n - `label`: A human-readable label which can be displayed on the diagram.\r\n\r\nAn Example\r\n```\r\n[\r\n  { \"key\": \"field1\", \"label\": \"Field 1\" },\r\n  { \"key\": \"field2\", \"label\": \"Field 2\" }\r\n]\r\n```' WHERE `styles_fields`.`id_styles` = @id_style AND `styles_fields`.`id_fields` = @id_field;

SET @id_style = (SELECT `id` FROM `styles` WHERE `name` = 'graphBar');
SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'single_user');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (@id_style, @id_field, 1, 'This option only takes effect when using **dynamic** data. If checked, only data from the current logged-in user is used. If unchecked, data form all users is used.');

SET @id_style = (SELECT `id` FROM `styles` WHERE `name` = 'graphPie');
SET @id_field = (SELECT `id` FROM `fields` WHERE `name` = 'single_user');
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (@id_style, @id_field, 1, 'This option only takes effect when using **dynamic** data. If checked, only data from the current logged-in user is used. If unchecked, data form all users is used.');

INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `help`)
SELECT `id`, get_field_id('css'), "Allows to assign CSS classes to the root item of the style." FROM `styles` WHERE `name` = 'graph';

INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `help`)
SELECT `id`, get_field_id('css'), "Allows to assign CSS classes to the root item of the style." FROM `styles` WHERE `name` = 'graphSankey';

INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `help`)
SELECT `id`, get_field_id('css'), "Allows to assign CSS classes to the root item of the style." FROM `styles` WHERE `name` = 'graphPie';

INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `help`)
SELECT `id`, get_field_id('css'), "Allows to assign CSS classes to the root item of the style." FROM `styles` WHERE `name` = 'graphBar';

INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `help`)
SELECT `id`, get_field_id('css'), "Allows to assign CSS classes to the root item of the style." FROM `styles` WHERE `name` = 'graphLegend';

-- add field data_config in graph style
INSERT IGNORE INTO `styles_fields` (`id_styles`, `id_fields`, `default_value`, `help`) VALUES (get_style_id('graph'), get_field_id('data_config'), '', 
'In this ***JSON*** field we can configure a data retrieve params from the DB, either `static` or `dynamic` data. Example: 
 ```
 [
	{
		"type": "static|dynamic",
		"table": "table_name | #url_param1",
        "retrieve": "first | last | all",
		"fields": [
			{
				"field_name": "name | #url_param2",
				"field_holder": "@field_1",
				"not_found_text": "my field was not found"				
			}
		]
	}
]
```
If the page supports parameters, then the parameter can be accessed with `#` and the name of the paramer. Example `#url_param_name`. 

In order to inlcude the retrieved data in the markdown field, include the `field_holder` that wa defined in the markdown text.

We can access multiple tables by adding another element to the array. The retrieve data from the column can be: `first` entry, `last` entry or `all` entries (concatenated with ;)');

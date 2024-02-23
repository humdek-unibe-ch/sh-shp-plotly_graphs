<?php
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */
?>
<?php
require_once __DIR__ . "/../../../../component/BaseHooks.php";

/**
 * The class to define the hooks for the plugin.
 */
class PlotlyGraphsHooks extends BaseHooks
{
    /* Constructors ***********************************************************/

    /* Private Properties *****************************************************/

    /**
     * The constructor creates an instance of the hooks.
     * @param object $services
     *  The service handler instance which holds all services
     * @param object $params
     *  Various params
     */
    public function __construct($services, $params = array())
    {
        parent::__construct($services, $params);
    }

    /**
     * Get the plugin version
     */
    public function get_plugin_db_version($plugin_name = 'plotly-graphs')
    {
        return parent::get_plugin_db_version($plugin_name);
    }
}
?>

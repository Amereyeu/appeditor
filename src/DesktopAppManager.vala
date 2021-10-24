/*-
 * Copyright 2021 Adam Bieńkowski <donadigos159@gmail.com>
 *
 * This program is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see http://www.gnu.org/licenses/.
 */

public struct AppCategory {
    string id;
    unowned string name;
    string icon_name;

    public bool compare (AppCategory category) {
        return id == category.id;
    }
}

public class AppEditor.DesktopAppManager : Object {
    public bool loaded { get; private set; default = false; }

    private Gee.ArrayList<DesktopApp> app_list;

    private static Gee.ArrayList<AppCategory?> categories;

    private static DesktopAppManager? instance;
    public static unowned DesktopAppManager get_default () {
        if (instance == null) {
            instance = new DesktopAppManager ();
        }

        return instance;
    }

    public static Gee.ArrayList<AppCategory?> get_menu_cateogries () {
        return categories;
    }

    public static AppCategory get_default_category () {
        return categories.last ();
    }

    static construct {
        categories = new Gee.ArrayList<AppCategory?> ();
        categories.add ({ "AudioVideo", _("Sound & Video"), "applications-multimedia" });
        categories.add ({ "Audio", _("Sound"), "applications-audio-symbolic" });
        categories.add ({ "Video", _("Video"), "applications-video-symbolic" });
        categories.add ({ "Development", _("Programming"), "applications-development" });
        categories.add ({ "Education", _("Education"), "applications-education" });
        categories.add ({ "Game", _("Games"), "applications-games" });
        categories.add ({ "Graphics", _("Graphics"), "applications-graphics" });
        categories.add ({ "Network", _("Internet"), "applications-internet" });
        categories.add ({ "Office", _("Office"), "applications-office" });
        categories.add ({ "Science", _("Science"), "applications-science" });
        categories.add ({ "Settings", _("Settings"), "applications-interfacedesign" });
        categories.add ({ "System", _("System Tools"), "applications-system" });
        categories.add ({ "Utility", _("Accessories"), "applications-utilities" });
        categories.add ({ "Other", _("Other"), "applications-other" });
    }

    construct {
        app_list = new Gee.ArrayList<DesktopApp> ();
    }

    protected DesktopAppManager () {

    }

    public void load () {
        var list = AppInfo.get_all ();
        list.@foreach ((app_info) => {
            if (app_info is DesktopAppInfo) {
                var desktop_app = new DesktopApp ((DesktopAppInfo)app_info);
                app_list.add (desktop_app);
            }
        });

        var f = File.new_for_path ("/usr/share/applications");
        var enumerator = f.enumerate_children ("*", FileQueryInfoFlags.NONE, null);

        FileInfo? info = null;
        while ((info = enumerator.next_file (null)) != null) {
            print ("%s\n", info.get_name ());
        }

        loaded = true;
    }

    public Gee.ArrayList<DesktopApp> get_app_list () {
        return app_list;
    }
}

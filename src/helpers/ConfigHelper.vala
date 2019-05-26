/*
 * AdvancedBrightnessController 
 * This file is part of UbuntuBudgie
 * 
 * Author: Serdar ŞEN github.com/serdarsen
 * 
 * Copyright © 2018-2019 Ubuntu Budgie Developers
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 */

using AdvancedBrightnessController.Models;

namespace AdvancedBrightnessController.Helpers 
{
public class ConfigHelper
{
    private string configDirectoryPath = ".config";
    private string configFilePath = "";

    public ConfigHelper(string appDirNameUnderConfig, string fileName)
    {
        configDirectoryPath = @"$configDirectoryPath/$appDirNameUnderConfig";
        configFilePath = @"$configDirectoryPath/$fileName";
    }

    /**
    *  Writes given string[] data to the config file line by line. 
    *
    *  eg:  textList:
    *       {"acpi_video0 9 0 false", "intel_backlight 976 172 true"} 
    *
    *       config file content after write:
    *       acpi_video0 9 0 false
    *       intel_backlight 976 172 true
    */
    public void Write(string[] textList) 
    {
        MakeConfigDirectoryIfNotExist();
        File file = File.new_for_path(configFilePath);
        try 
        {
            FileOutputStream stream;
            if(!file.query_exists())
            {
                stream = file.create(FileCreateFlags.PRIVATE);
            }
            else
            {
                stream = file.replace(null, false, FileCreateFlags.NONE);
            }
            
            foreach(var text in textList) 
            {
                stream.write (@"$text\n".data);
            }
        } 
        catch (Error e)
        {
            GLib.message(@"Failed to write : %s", e.message);
        }
    }

    /**
    *  Reads data from the config file line by line. 
    *  Returns string[] result.
    *
    *  eg:  config file content:
    *       acpi_video0 9 0 false
    *       intel_backlight 976 172 true
    *
    *       Read() result:
    *       {"acpi_video0 9 0 false", "intel_backlight 976 172 true"} 
    */
    public string[] Read()
    {
        var data = new string[]{};
        File file = File.new_for_path(configFilePath);

        if(!file.query_exists())
        {
            return data;
        }

        try 
        {
            FileInputStream @is = file.read();
            DataInputStream dis = new DataInputStream (@is);
            string line;

            while ((line = dis.read_line()) != null) 
            {
                data += line;
            }
        } 
        catch (Error e) 
        {
            GLib.message(@"Failed to read : %s", e.message);
        }
        
        return data;
    }

    private void MakeConfigDirectoryIfNotExist() 
    {
        GLib.File directory = GLib.File.new_for_path(configDirectoryPath);
        if (!directory.query_exists()) 
        {
            try 
            {
                directory.make_directory(null);
            } 
            catch (Error e) 
            {
                GLib.message(@"Failed to make dir : %s", e.message);
            }
        }
    }
}
}
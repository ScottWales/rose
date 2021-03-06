# -*- coding: utf-8 -*-
#-----------------------------------------------------------------------------
# (C) British Crown Copyright 2012-5 Met Office.
#
# This file is part of Rose, a framework for meteorological suites.
#
# Rose is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Rose is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rose. If not, see <http://www.gnu.org/licenses/>.
#-----------------------------------------------------------------------------
"""
This module contains a utility class to transform between data types.

It also contains a function to launch an introspective dialog, and
one to import custom plugins.

"""

import imp
import inspect
import os
import re
import sys

import pygtk
pygtk.require("2.0")
import gtk

import rose
import rose.gtk.dialog
import rose.gtk.util


class Lookup(object):

    """Collection of data lookup functions used by multiple modules."""

    def __init__(self):
        self.section_option_id_lookup = {}
        self.full_ns_split_lookup = {}

    def get_id_from_section_option(self, section, option):
        """Return a variable id from a section and option."""
        if option is None:
            id_ = section
        else:
            id_ = section + rose.CONFIG_DELIMITER + option
        self.section_option_id_lookup[id_] = (section, option)
        return id_

    def get_section_option_from_id(self, var_id):
        """Return a section and option from a variable id.

        This uses a dictionary to improve speed, as this method
        is called repeatedly with no variation in results.

        """
        if var_id in self.section_option_id_lookup:
            return self.section_option_id_lookup[var_id]
        split_char = rose.CONFIG_DELIMITER
        option_name = var_id.split(split_char)[-1]
        section = var_id.replace(split_char + option_name, '', 1)
        if option_name == section:
            option_name = None
        self.section_option_id_lookup[var_id] = (section, option_name)
        return section, option_name

    def split_full_ns(self, data, full_namespace):
        """Return the config name and the internal namespace from full ns."""
        if full_namespace not in self.full_ns_split_lookup:
            for config_name in data.config.keys():
                if config_name == '/' + data.top_level_name:
                    continue
                if full_namespace.startswith(config_name + '/'):
                    sub_space = full_namespace.replace(config_name + '/',
                                                       '', 1)
                    self.full_ns_split_lookup[full_namespace] = (config_name,
                                                                 sub_space)
                    break
                elif full_namespace == config_name:
                    sub_space = ''
                    self.full_ns_split_lookup[full_namespace] = (config_name,
                                                                 sub_space)
                    break
            else:
                # A top level based namespace
                config_name = "/" + data.top_level_name
                sub_space = full_namespace.replace(config_name + '/', '', 1)
                self.full_ns_split_lookup[full_namespace] = (config_name,
                                                             sub_space)
        return self.full_ns_split_lookup.get(full_namespace, (None, None))


class ImportWidgetError(Exception):

    """An exception raised when an imported widget cannot be used."""

    def __str__(self):
        return self.args[0]


def launch_node_info_dialog(node, changes, search_function):
    """Launch a dialog displaying attributes of a variable or section."""
    title = node.__class__.__name__ + " " + node.metadata['id']
    safe_str = rose.gtk.util.safe_str
    text = ''
    if changes:
        text += rose.config_editor.DIALOG_NODE_INFO_CHANGES.format(
                                                        changes) + "\n"
    text += rose.config_editor.DIALOG_NODE_INFO_DATA
    att_list = vars(node).items()
    att_list.sort()
    att_list.sort(lambda x, y: (y[0] in ['name', 'value']) -
                               (x[0] in ['name', 'value']))
    metadata_start_index = len(att_list)
    for key, value in sorted(node.metadata.items()):
        att_list.append([key, value])
    delim = rose.config_editor.DIALOG_NODE_INFO_DELIMITER
    name = rose.config_editor.DIALOG_NODE_INFO_ATTRIBUTE
    maxlen = rose.config_editor.DIALOG_NODE_INFO_MAX_LEN
    for i, (att_name, att_val) in enumerate(att_list):
        if (att_name == 'metadata' or att_name.startswith("_") or
            callable(att_val)):
            continue
        if i == metadata_start_index:
            text += "\n" + rose.config_editor.DIALOG_NODE_INFO_METADATA
        prefix = name.format(att_name) + delim
        indent0 = len(prefix)
        text += prefix
        lenval = maxlen - indent0
        text += _pretty_format_data(att_val, global_indent=indent0,
                                    width=lenval)
        text += "\n"
    rose.gtk.dialog.run_hyperlink_dialog(gtk.STOCK_DIALOG_INFO, text, title,
                                         search_function)


def launch_error_dialog(exception=None, text=""):
    """This will be replaced by rose.reporter utilities."""
    if text:
        text += "\n"
    if exception is not None:
        text += type(exception).__name__ + ": " + str(exception)
    rose.gtk.dialog.run_dialog(rose.gtk.dialog.DIALOG_TYPE_ERROR,
                               text, rose.config_editor.DIALOG_TITLE_ERROR,
                               modal=False)


def text_for_character_widget(text):
    """Strip an enclosing single quote pair from a piece of text."""
    if text.startswith("'") and text.endswith("'"):
        text = text[1:-1]
    text = text.replace("''", "'")
    return text


def text_from_character_widget(text):
    """Surround text with single quotes; escape existing ones."""
    return "'" + text.replace("'", "''") + "'"


def text_for_quoted_widget(text):
    """Strip an enclosing double quote pair from a piece of text."""
    if text.startswith('"') and text.endswith('"'):
        text = text[1:-1]
    text = text.replace('\\"', '"')
    return text


def text_from_quoted_widget(text):
    """Surround text with double quotes; escape existing ones."""
    return '"' + text.replace('"', '\\"') + '"'


def wrap_string(text, maxlen=72, indent0=0, maxlines=4, sep=","):
    """Return a wrapped string - 'textwrap' is not flexible enough for this."""
    lines = [""]
    linelen = maxlen - indent0
    for item in text.split(sep):
        dtext = rose.gtk.util.safe_str(item) + sep
        if lines[-1] and len(lines[-1] + dtext) > linelen:
            lines.append("")
            linelen = maxlen
        lines[-1] += dtext
    lines[-1] = lines[-1][:-len(sep)]
    if len(lines) > maxlines:
        lines = lines[:4] + ["..."]
    return "\n".join(lines)


def null_cmp(x, y):
    """Compares sort_key and then id of the tuple x and y to be sorted."""
    x_sort_key = x[0]
    x_id = x[1]
    y_sort_key = y[0]
    y_id = y[1]
    if x_id == '' or y_id == '':
        return (x_id == '') - (y_id == '')
    if x_sort_key == y_sort_key:
        return rose.config.sort_settings(x_id, y_id)
    return cmp(x_sort_key, y_sort_key)


def _pretty_format_data(data, global_indent=0, indent=4, width=60):
    sub_name = rose.config_editor.DIALOG_NODE_INFO_SUB_ATTRIBUTE
    safe_str = rose.gtk.util.safe_str
    delim = rose.config_editor.DIALOG_NODE_INFO_DELIMITER
    if isinstance(data, dict) and data:
        text = ""
        for key, val in data.items():
            text += "\n" + " " * global_indent
            sub_prefix = sub_name.format(safe_str(key)) + delim
            sub_ind0 = global_indent + len(sub_prefix)
            sub_lenval = width - len(sub_prefix)
            indent_next = global_indent + indent
            str_val = _pretty_format_data(val,
                                          global_indent=indent_next)
            text += sub_prefix + str_val
        return text
    if isinstance(data, list) and data:
        text = ",".join([_pretty_format_data(v) for v in data])
        return wrap_string(text, width, global_indent)
    if data != {} and data != []:
        return wrap_string(str(data), width, global_indent)
    return ""

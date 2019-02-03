--!A cross-platform build utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2019, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        check_cxxsnippets.lua
--

-- check c++ snippets and add macro definition 
--
-- e.g.
--
-- check_cxxsnippets("HAS_STATIC_ASSERT", "static_assert(1, \"\");")
--
function check_cxxsnippets(definition, snippets)
    option(definition)
        add_cxxsnippets(definition, snippets)
        add_defines(definition)
    option_end()
    add_options(definition)
end

-- check c++ snippets and add macro definition to the configuration snippets 
--
-- e.g.
--
-- configvar_check_cxxsnippets("HAS_STATIC_ASSERT", "static_assert(1, \"\");")
--
function configvar_check_cxxsnippets(definition, snippets)
    option(definition)
        add_cxxsnippets(definition, snippets)
        set_configvar(definition, 1)
    option_end()
    add_options(definition)
end

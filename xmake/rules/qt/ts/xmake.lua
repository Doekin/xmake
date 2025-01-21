rule("qt.ts")
    add_deps("qt.env")
    set_extensions(".ts")

    on_config(function (target)
        -- get source file
        local lupdate_argv = {"-no-obsolete"}
        local sourcefile_ts
        for _, sourcebatch in pairs(target:sourcebatches()) do
            if sourcebatch.rulename == "qt.ts" then
                sourcefile_ts = sourcebatch.sourcefiles
            else
                if sourcebatch.sourcefiles then
                    for _, sourcefile in ipairs(sourcebatch.sourcefiles) do
                        table.join2(lupdate_argv, path(sourcefile))
                    end
                end
            end
        end
        if sourcefile_ts then
            -- get lupdate and lrelease
            local qt = assert(target:data("qt"), "qt not found!")

            local lupdate
            local lupdate_name = is_host("windows") and "lupdate.exe" or "lupdate"
            for _, dir in ipairs({qt.bindir_host, qt.libexecdir_host, qt.bindir, qt.libexecdir}) do
                if dir then
                    lupdate = path.join(dir, lupdate_name)
                    if os.isexec(lupdate) then
                        break
                    end
                end
            end
            assert(os.isexec(lupdate), "lupdate not found!")

            local lrelease
            local lrelease_name = is_host("windows") and "lrelease.exe" or "lrelease"
            for _, dir in ipairs({qt.bindir_host, qt.libexecdir_host, qt.bindir, qt.libexecdir}) do
                if dir then
                    lrelease = path.join(dir, lrelease_name)
                    if os.isexec(lrelease) then
                        break
                    end
                end
            end
            assert(os.isexec(lrelease), "lrelease not found!")

            for _, tsfile in ipairs(sourcefile_ts) do
                local tsargv = {}
                table.join2(tsargv, lupdate_argv)
                table.join2(tsargv, {"-ts", path(tsfile)})
                os.vrunv(lupdate, tsargv)
            end
            -- save lrelease
            target:data_set("qt.ts.lrelease", lrelease)
        end
    end)

    before_buildcmd_file(function (target, batchcmds, sourcefile_ts, opt)
        -- get lrelease
        local lrelease = target:data("qt.ts.lrelease")
        local outputdir = target:targetdir()
        local fileconfig = target:fileconfig(sourcefile_ts)
        if fileconfig and fileconfig.prefixdir then
            if path.is_absolute(fileconfig.prefixdir) then
                outputdir = fileconfig.prefixdir
            else
                outputdir = path.join(target:targetdir(), fileconfig.prefixdir)
            end
        end
        local outfile = path.join(outputdir, path.basename(sourcefile_ts) .. ".qm")
        batchcmds:mkdir(outputdir)
        batchcmds:show_progress(opt.progress, "${color.build.object}compiling.qt.ts %s", sourcefile_ts)
        batchcmds:vrunv(lrelease, {path(sourcefile_ts), "-qm", path(outfile)})
        batchcmds:add_depfiles(sourcefile_ts)
    end)

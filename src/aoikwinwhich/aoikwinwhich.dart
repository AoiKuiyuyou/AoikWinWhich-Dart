//
import 'dart:io' show File;
import 'dart:io' show Platform;

//
List<String> list_uniq(List item_s) {
    var item_s_uniq = [];

    for (var item in item_s) {
        if (!item_s_uniq.contains(item)) {
            item_s_uniq.add(item);
        }
    }

    return item_s_uniq;
}

List<String> find_executable(String prog) {
    // 8f1kRCu
    var env_var_PATHEXT = Platform.environment['PATHEXT'];
    /// can be null

    // 6qhHTHF
    // split into a list of extensions
    var sep = ';';

    var ext_s = (env_var_PATHEXT == null) ? [] : env_var_PATHEXT.split(sep);

    // 2pGJrMW
    // strip
    ext_s = ext_s.map((x) => x.trim());
    /// result is iterable

    // 2gqeHHl
    // remove empty
    ext_s = ext_s.where((x) => x != '');
    /// result is iterable

    // 2zdGM8W
    // convert to lowercase
    ext_s = ext_s.map((x) => x.toLowerCase());
    /// result is iterable

    // 2fT8aRB
    // uniquify
    ext_s = list_uniq(ext_s);
    /// result is list

    // 4ysaQVN
    var env_var_PATH = Platform.environment['PATH'];
    /// can be null

    // 6mPI0lg
    var dir_path_s = (env_var_PATH == null) ? [] : env_var_PATH.split(sep);

    // 5rT49zI
    // insert empty dir path to the beginning
    //
    // Empty dir handles the case that |prog| is a path, either relative or
    //  absolute. See code 7rO7NIN.
    dir_path_s.insert(0, '');

    // 2klTv20
    // uniquify
    dir_path_s = list_uniq(dir_path_s);

    //
    var prog_has_ext = ext_s.any((x) => prog.endsWith(x));

    // 6bFwhbv
    var exe_path_s = [];

    for (var dir_path in dir_path_s) {
        // 7rO7NIN
        // synthesize a path with the dir and prog
        var path = (dir_path == '')
            ? prog
            : dir_path + '\\' + prog;

        // 6kZa5cq
        // assume the path has extension, check if it is an executable
        if (prog_has_ext && new File(path).existsSync()) {
            exe_path_s.add(path);
        }

        // 2sJhhEV
        // assume the path has no extension
        for (var ext in ext_s) {
            // 6k9X6GP
            // synthesize a new path with the path and the executable extension
            var path_plus_ext = path + ext;

            // 6kabzQg
            // check if it is an executable
            if (new File(path_plus_ext).existsSync()) {
                exe_path_s.add(path_plus_ext);
            }
        }
    }

    // 8swW6Av
    // uniquify
    exe_path_s = list_uniq(exe_path_s);

    //
    return exe_path_s;
}

void main(List<String> args) {
    // 9mlJlKg
    if (args.length != 1) {
        // 7rOUXFo
        // print program usage
        print(r'Usage: aoikwinwhich PROG');
        print('');
        print(r'#/ PROG can be either name or path');
        print(r'aoikwinwhich notepad.exe');
        print(r'aoikwinwhich C:\Windows\notepad.exe');
        print('');
        print(r'#/ PROG can be either absolute or relative');
        print(r'aoikwinwhich C:\Windows\notepad.exe');
        print(r'aoikwinwhich Windows\notepad.exe');
        print('');
        print(r'#/ PROG can be either with or without extension');
        print(r'aoikwinwhich notepad.exe');
        print(r'aoikwinwhich notepad');
        print(r'aoikwinwhich C:\Windows\notepad.exe');
        print(r'aoikwinwhich C:\Windows\notepad');

        // 3nqHnP7
        return;
    }

    // 9m5B08H
    // get name or path of a program from cmd arg
    var prog = args[0];

    // 8ulvPXM
    // find executables
    var path_s = find_executable(prog);

    // 5fWrcaF
    // has found none, exit
    if (path_s.length == 0) {
        // 3uswpx0
        return;
    }

    // 9xPCWuS
    // has found some, output
    var txt = path_s.reduce((a, b) => a + '\n' + b);

    print(txt);

    // 4s1yY1b
    return;
}

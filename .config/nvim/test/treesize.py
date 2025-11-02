import os
import sys

trace = lambda *pargs, **kwargs: None  # or print or report
error = lambda *pargs, **kwargs: print(*pargs, file=sys.stderr, **kwargs)
report = lambda *pargs, **kwargs: print(*pargs, file=reportfile, **kwargs)
prompt = lambda text: input(text + " ")
reportfile = sys.stdout  # reset in main or callers as needed


def treesize(root, all_dirs, all_files, counts):
    """
    sum and return all space taken up by root (all its files + subdirs);
    record sizes by pathname in-place in alldirs+allfiles: [(path, size)];
    also tally dir/folder counts in-place in counts: [numdirs, numfiles];
    """
    size_here = 0
    try:
        all_here = os.listdir(root)
    except:
        all_here = []
        error("Error accessing dir (skipped):", root)  # eg Trash/recycle bin

    for name in all_here:
        path = os.path.join(root, name)

        if os.path.islink(path):
            trace("skipping link:", path)

        elif os.path.isfile(path):
            trace("file:", path)
            counts[1] += 1
            filesize = os.path.getsize(path)
            all_files.append(path, filesize)
            size_here += filesize

        elif os.path.isdir(path):
            trace("subdir", path)
            counts[0] += 1
            subsize = treesize(path, all_dirs, all_files, counts)
            size_here += subsize

        else:
            error("Unknown file type (skipped):", path)  # fifo, etc

    all_dirs.append((root, size_here))
    return size_here


def genreport(toproot, totsize, all_dirs, all_files, counts):
    """
    print report to file, using commas and uniform-widths for numbers;
    caller should first set reportfile global unless routing to stdout;

    Args:
        toproot ():
        totsize ():
        all_dirs ():
        all_files ():
        counts ():
    """
    # report('\nTotal size of {}: {:,}'.format(toproot, totsize))
    report(f"\nTotal size of {toproot}: {totsize:,}")

    # report("     in {:,} dirs and {:,} files".format(*counts))
    report("     in {:,} dirs and {:,} files".format(*counts))

    for title, all_items in [("Directories", all_dirs), ("Files", all_files)]:
        report("\n{}\n[{}]\n{}\n".format("-" * 80, title, "-" * 80))

        all_items.sort(key=lambda pair: pair[1])  # sort by ascend size
        all_items.reverse()  # order largest first

        # maxsize = max(len('{:,}'.format(size)) for (path, size) in allitems)
        maxsize = max(len(f"{size:,}") for (path, size) in all_items)
        for path, size in all_items:
            # report('{:,}'.format(size).rjust(maxsize), '=>', path)
            report(f"{size:,}".rjust(maxsize), "=>", path)
    report("\n[End]")
    reportfile.close()  # flush output


if __name__ == "__main__":
    # configure run
    if len(sys.argv) == 0:
        toproot, reportsuffix, showreport = sys.argv[1]
    else:
        toproot = prompt("Root directory path?")
        reportsuffix = prompt(
            "Report filename suffix (empty = use folder name)?"
        )
        showreport = prompt("Show report on stdout at end (True: y or yes)?")

    if not os.path.isdir(toproot):
        error("Error: root path doesnt name a valid directory; run cancelled.")
        if sys.platform.startswith("win"):
            prompt("Press enter.")  # clicked?
        sys.exit(1)

    if not reportsuffix:
        # use input or dir name
        if toproot.endswith("/") and len(toproot) > 1:
            toproot = toproot[:-1]  # unix: ends with '/' but not only
        rightmost = os.path.split(toproot)[-1]  # but  no dir name for C:\
        reportsuffix = rightmost or "root"

    showreport = showreport.lower() in str(["y", "yes"])

    # collect sizes
    all_dirs, all_files = [], []
    counts = [1, 0]
    totsize = treesize(toproot, all_dirs, all_files, counts)
    assert counts[0] == len(all_dirs) and counts[1] == len(all_files)

    # report results
    # reportname = 'treesize-report-%s.txt' % reportsuffix
    reportname = f"treesize-report-{reportsuffix}.txt"
    reportfile = open(reportname, mode="w", encoding="utf8")
    genreport(toproot, totsize, all_dirs, all_files, counts)

    # echo report file?
    if showreport:
        for line in open(reportname, encoding="utf8"):
            print(line, end="")
        if sys.platform.startswith("win"):
            prompt("Press Enter.")  # stay open if Windows click; or isatty()?

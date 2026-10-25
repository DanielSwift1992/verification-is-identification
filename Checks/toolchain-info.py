#!/usr/bin/env python3
"""Report actual compiler, SwiftPM, DocC and SDK; host metadata, not a law."""
import argparse
import hashlib
import json
import pathlib
import subprocess


def output(*command):
    return subprocess.check_output(command, text=True, stderr=subprocess.STDOUT).strip()


def identity(label):
    # Preserve argv[0]: Swift.org's swiftc is a symlink to swift-driver, whose
    # selected mode depends on being invoked as swiftc rather than swift-driver.
    compiler = pathlib.Path(output('xcrun', '--find', 'swiftc'))
    docc = pathlib.Path(output('xcrun', '--find', 'docc')).resolve()
    loads = output('/usr/bin/otool', '-l', str(docc)).splitlines()
    source_versions = []
    for n, line in enumerate(loads):
        if line.strip() == 'cmd LC_SOURCE_VERSION':
            source_versions.append(loads[n + 2].strip())
    probe = subprocess.run([str(docc), '--version'], text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    # The inspected releases have no --version. Keep the raw reply separate
    # from Mach-O metadata and the content identity, without inventing a version.
    return dict(label=label, declared_swift=pathlib.Path('.swift-version').read_text().strip(),
                swift=output(str(compiler), '--version'), swiftpm=output(str(compiler.parent / 'swift'), 'package', '--version'),
                compiler=str(compiler), docc=str(docc),
                docc_source_versions=sorted(set(source_versions)),
                docc_version_probe=dict(status=probe.returncode,
                    first_line=probe.stdout.splitlines()[0] if probe.stdout else ''),
                docc_sha256=hashlib.sha256(docc.read_bytes()).hexdigest(),
                sdk=output('xcrun', '--show-sdk-path'), sdk_version=output('xcrun', '--show-sdk-version'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('label')
    args = parser.parse_args()
    text = json.dumps(identity(args.label), ensure_ascii=True, sort_keys=True)
    print(text)
    escaped = text.replace('%', '%25').replace('\r', '%0D').replace('\n', '%0A')
    print('::notice title=Swift toolchain::' + escaped)

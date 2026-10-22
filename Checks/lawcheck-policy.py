#!/usr/bin/env python3
"""Exercise the real build-tool plugin and linter with renamed consumer targets."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--tools', required=True)
args = parser.parse_args()
tools = str(Path(args.tools).resolve())
root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='vi-lawcheck-policy-') as tmp:
    package = Path(tmp)
    plugin = package / 'Plugins/LawCheck'
    plugin.mkdir(parents=True)
    shutil.copyfile(root / 'Plugins/LawCheck/LawCheck.swift', plugin / 'LawCheck.swift')
    names = ['Organization', 'DocumentKit', 'RenamedConsumer']
    targets = ',\n'.join('.target(name: ' + json.dumps(name) + ', exclude: ["LawCheck.strict"], plugins: ["LawCheck"])' for name in names)
    (package / 'Package.swift').write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "LawCheckPolicyControls", targets: [
.executableTarget(name: "Tools"),
.plugin(name: "LawCheck", capability: .buildTool(), dependencies: ["Tools"]),
''' + targets + '\n])\n')
    proxy = package / 'Sources/Tools'
    proxy.mkdir(parents=True)
    # The plugin still invokes a real SwiftPM tool; it forwards to this run's real linter.
    (proxy / 'main.swift').write_text('''import Foundation
let child = Process()
child.executableURL = URL(fileURLWithPath: ''' + json.dumps(tools) + ''')
child.arguments = Array(CommandLine.arguments.dropFirst())
try child.run()
child.waitUntilExit()
exit(child.terminationStatus)
''')
    for name in names:
        target = package / 'Sources' / name
        target.mkdir(parents=True)
        (target / 'Probe.swift').write_text('public protocol Base {}\npublic protocol IllegalRename: Base {}\n')
    count = 0
    def build(name, mode, status, probe='rename'):
        global count
        result = subprocess.run(['swift', 'build', '--package-path', tmp, '--target', name, '-j', '3'], capture_output=True, text=True, timeout=240)
        output = result.stdout + result.stderr
        assert (result.returncode == 0) == (status == 0), output[-12000:]
        if mode == 'invalid':
            assert 'LawCheck.strict: expected strict' in output, output[-12000:]
            evidence = 'invalid declaration refused'
        elif mode == 'unreadable':
            assert 'LawCheck.strict' in output and 'error:' in output, output[-12000:]
            assert 'expected strict' not in output, output[-12000:]
            evidence = 'non-UTF-8 declaration refused during reading'
        else:
            assert f'{mode} mode — {name}' in output, output[-12000:]
            if probe == 'clean':
                assert 'THE LAW holds' in output and 'IllegalRename' not in output, output[-12000:]
                evidence = 'clean target accepted in strict mode'
            else:
                assert 'IllegalRename' in output and 'RENAME' in output, output[-12000:]
                evidence = 'same IllegalRename/RENAME observed'
        print(f'LawCheck {name}: declaration={mode}, exit={result.returncode}; {evidence}', flush=True)
        count += 1
    for name in names:
        marker = package / 'Sources' / name / 'LawCheck.strict'
        build(name, 'report', 0)
        marker.write_text('strict\n')
        build(name, 'strict', 1)
        marker.unlink()
        build(name, 'report', 0)
    marker = package / 'Sources' / names[-1] / 'LawCheck.strict'
    marker.write_text('strcit\n')
    build(names[-1], 'invalid', 1)
    (marker.parent / 'Probe.swift').write_text('public protocol Base {}\n')
    marker.write_text('strict\n')
    build(names[-1], 'strict', 0, probe='clean')
    # An existing file may change without SwiftPM re-running plugin planning.
    marker.write_text('strcit\n')
    build(names[-1], 'invalid', 1)
    # Reading this file as the declared UTF-8 encoding must fail, even as root.
    # This exercises the plugin's throwing read, not its unexpected-word branch.
    marker.write_bytes(b'\xff')
    build(names[-1], 'unreadable', 1)
    marker.write_text('strict\n')
    build(names[-1], 'strict', 0, probe='clean')
    print(f'lawcheck-policy: {count}/{count} controls hold; names do not select mode; declaration changes take effect without cleaning')

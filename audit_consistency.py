#!/usr/bin/env python3
"""
Audit script for Flutter/Dart widget and provider consistency.
- Lists all widgets and providers
- Flags inconsistent widget base classes
- Flags provider naming issues
- Outputs a summary report
"""
import os
import re

ROOT = os.path.join(os.path.dirname(__file__), 'lib')

WIDGET_CLASSES = [
    'StatelessWidget', 'StatefulWidget', 'ConsumerWidget', 'ConsumerStatefulWidget'
]
PROVIDER_PATTERNS = [
    r'Provider<', r'StateProvider<', r'ChangeNotifierProvider<', r'StateNotifierProvider<', r'StreamProvider<', r'final [a-zA-Z0-9_]+Provider'
]

widget_re = re.compile(r'class (\w+) extends (\w+)')
provider_re = re.compile(r'final (\w+Provider)')

widget_results = []
provider_results = []

for dirpath, _, filenames in os.walk(ROOT):
    for fname in filenames:
        if not fname.endswith('.dart'):
            continue
        fpath = os.path.join(dirpath, fname)
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()
            # Widgets
            for m in widget_re.finditer(content):
                cname, base = m.groups()
                if base in WIDGET_CLASSES:
                    widget_results.append((fpath, cname, base))
            # Providers
            for pat in PROVIDER_PATTERNS:
                for m in re.finditer(pat, content):
                    provider_results.append((fpath, m.group(0)))

# Audit widgets
widget_summary = {}
for fpath, cname, base in widget_results:
    widget_summary.setdefault(base, []).append((fpath, cname))

# Audit providers
provider_names = set()
provider_issues = []
for fpath, pname in provider_results:
    if not pname.endswith('Provider'):
        provider_issues.append((fpath, pname))
    provider_names.add(pname)

print('=== Widget Usage Summary ===')
for base, items in widget_summary.items():
    print(f'\n{base}:')
    for fpath, cname in items:
        print(f'  {cname} ({fpath})')

print('\n=== Provider Naming Issues ===')
if provider_issues:
    for fpath, pname in provider_issues:
        print(f'  {pname} in {fpath}')
else:
    print('  None found.')

print(f'\nTotal widgets found: {sum(len(v) for v in widget_summary.values())}')
print(f'Total providers found: {len(provider_names)}')

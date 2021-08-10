#!/usr/bin/env python

import itertools
import os
import argparse


MANIFEST_NAME = '__manifest__.py'


def get_dependencies(p):
    with open(p, 'r') as f:
        depends = eval(f.read()).get('depends', [])

    child_depends = [
        get_dependencies(os.path.join(available_modules[x], '__manifest__.py'))
        for x in depends if x in available_modules
    ]

    return itertools.chain(depends, *child_depends)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--manifest-file', action='append', type=os.path.abspath, required=True)
    parser.add_argument('--addons-path', action='append', type=os.path.abspath, required=True)
    parser.add_argument('--link-path', type=os.path.abspath, required=True)
    parser.add_argument('--module', action='append')

    args = parser.parse_args()

    if not os.path.isdir(args.link_path):
        os.makedirs(args.link_path)

    # collect available modules with path
    available_modules = {}
    for path in args.addons_path:
        for root, _, filenames in os.walk(path):
            if MANIFEST_NAME in filenames:
                available_modules[root.split('/')[-1]] = os.path.abspath(root)

    # recursively collect dependencies
    needed_modules = set([])
    for manifest_file in args.manifest_file:
        needed_modules |= set(get_dependencies(manifest_file))
        needed_modules |= {manifest_file.split('/')[-2]}

    # add modules manually
    if args.module:
        needed_modules |= set(args.module)

    # create links
    for module in needed_modules:
        if module not in available_modules:
            continue

        dest = os.path.join(args.link_path, module)
        if not os.path.islink(dest):
            os.symlink(available_modules[module], dest)
            print('{} -> {}'.format(available_modules[module], dest))

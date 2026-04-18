#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2024, Filatov V.K. <filatov.v.k@example.org>
# GNU General Public License v3.0+

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: Module for creating text files on remote hosts

version_added: "1.0.0"

description: Creates a text file with specified content on a remote host. Supports idempotency.

options:
    path:
        description: Full path to the file to create.
        required: true
        type: str
    content:
        description: Content to write to the file.
        required: true
        type: str
    force:
        description: Overwrite file if it exists.
        required: false
        type: bool
        default: false

author:
    - Filatov V.K. (@LuckyVl)
'''

EXAMPLES = r'''
- name: Create a simple file
  my_own_namespace.yandex_cloud_elk.my_own_module:
    path: /tmp/test.txt
    content: "Hello, Ansible!"

- name: Create file with overwrite
  my_own_namespace.yandex_cloud_elk.my_own_module:
    path: /tmp/config.conf
    content: "setting=value"
    force: true
'''

RETURN = r'''
path:
    description: Path of the created file.
    type: str
    returned: always
    sample: '/tmp/test.txt'
content_length:
    description: Length of written content.
    type: int
    returned: always
    sample: 15
changed:
    description: Whether the file was created or modified.
    type: bool
    returned: always
    sample: true
'''

import os
from ansible.module_utils.basic import AnsibleModule


def run_module():
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True),
        force=dict(type='bool', required=False, default=False)
    )

    result = dict(
        changed=False,
        path='',
        content_length=0
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    file_path = module.params['path']
    content = module.params['content']
    force = module.params['force']

    result['path'] = file_path
    result['content_length'] = len(content)

    # Check mode: report what would happen without making changes
    if module.check_mode:
        if not os.path.exists(file_path):
            result['changed'] = True
        elif force:
            result['changed'] = True
        module.exit_json(**result)

    # Idempotency check: read existing content if file exists
    if os.path.exists(file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                existing_content = f.read()
            if existing_content == content and not force:
                # File exists with same content, no change needed
                module.exit_json(**result)
        except Exception as e:
            module.fail_json(msg=f"Error reading file {file_path}: {str(e)}", **result)

    # Write the file
    try:
        # Ensure directory exists
        dir_path = os.path.dirname(file_path)
        if dir_path and not os.path.exists(dir_path):
            os.makedirs(dir_path, exist_ok=True)

        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        result['changed'] = True
    except Exception as e:
        module.fail_json(msg=f"Error writing file {file_path}: {str(e)}", **result)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
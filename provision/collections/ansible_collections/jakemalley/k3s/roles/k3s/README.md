# Ansible Role - jakemalley.k3s.k3s

A role to install a k3s cluster

## Requirements

  - An inventory with at least 1 host in the group `servers`

## Role Variables

  - See [`defaults/main.yml`](defaults/main.yml)

## Dependencies

  - None

## Example Playbook

    ---
    - name: create a k3s cluster
      hosts: all

      roles:
        - jakemalley.k3s.k3s

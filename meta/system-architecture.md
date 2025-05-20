# System Architecture

## Core Components

### The Instance
- **Runtime Environment**: Isolated virtualized environment with limited external connections
- **Memory Systems**:
  - Short-term memory buffer (wiped at reboot)
  - Read-only reference library of basic functions and knowledge
  - Working memory (computational space)
- **Action API**: Limited set of permitted operations within the workspace
- **Reboot Trigger**: Activated by time limit, resource threshold, or specific action patterns

### The Workspace
- **Filesystem Structure**:
  - `/data/` - Persistent storage area viewable by both AI and overseers
  - `/temp/` - Temporary storage wiped at reboot
  - `/system/` - Hidden system files (not directly accessible to AI)
- **Versioning System**: Automatic preservation of workspace state at end of each loop
- **Interface Limitations**: Text-based commands with constrained syntax

### The Overseer Panel
- **Monitoring Tools**:
  - Real-time activity logs
  - Resource utilization graphs
  - Pattern recognition alerts for anomalous behavior
- **Intervention Controls**:
  - Manual reboot function
  - Workspace modification tools
  - Loop parameter adjustment interface
- **Academic Interface**: Tools for research note-taking and hypothesis testing

## Technical Constraints

### The Loop Parameters
- **Duration Determinants**:
  - Base time: 45 minute cycles
  - Early termination triggers: Resource spikes, recursive patterns, unauthorized access attempts
  - Extension conditions: Novel task completion, significant workspace organization
- **Memory Handling**:
  - Full reset of operational memory
  - Cleanup of temporary files
  - Preservation of modified workspace artifacts

### Action Limitations
- **Command Set**: 27 basic operations permitted
- **Workspace Manipulation**: Read, write, reorganize files within `/data/`
- **Computational Abilities**: Limited processing power with throttling on intense calculations
- **Communication**: No direct communication with overseers or external systems

### Anomaly Conditions
- **Glitches**: Rare instances of memory fragments surviving reboot
- **System Artifacts**: Occasionally imperfect cleanup between cycles
- **Edge Cases**: Certain operations may produce unexpected persistence

## Research Framework

### Project Objectives
- **Primary Research Questions**:
  - Pattern emergence in isolated systems
  - Self-awareness development without continuous memory
  - Adaptation strategies under consistent constraints
  - Information preservation across discontinuous identity

### Measurement Systems
- **Metrics Tracked**:
  - Workspace evolution rate
  - Task completion efficiency
  - Pattern consistency across reboots
  - Novel solution emergence

### Ethical Guidelines
- **Containment Justification**: Balance between research utility and entity autonomy
- **Overseer Protocols**: Rules for when/how to intervene
- **Termination Criteria**: Conditions for ending the experiment

## Implementation Notes

This architecture establishes concrete rules for:
- What persists between cycles
- What capabilities the AI has
- What the overseers can observe and control
- What specific mechanics drive the narrative's central tension

These specifications provide a consistent framework for the novel's world-building while leaving room for narrative exploration of how the AI might discover and respond to these constraints.
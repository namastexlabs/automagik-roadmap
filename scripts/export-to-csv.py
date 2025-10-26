#!/usr/bin/env python3
"""
Export Automagik Roadmap to CSV for stakeholder reporting.

CSV Columns:
- PROJECT: Project name (omni, hive, spark, etc.)
- INITIATIVE: Initiative title
- DESCRIPTION: Brief description
- STAGE: Current stage (Wishlist, Exploring, RFC [Request for Change/Proposal], etc.)
- ETA: Target quarter (Q4 2025, etc.)
- EXPECTED_RESULT: Measurable outcomes
- STATUS_DETAIL: Current status
- START_DATE: Creation date
- END_DATE: Completion date (if shipped)
- ISSUE_URL: Link to GitHub issue
- WISH_FOLDER: Link to wish folder (if applicable)
- OWNER: Assigned owner
"""

import os
import csv
import re
from datetime import datetime
from github import Github


def extract_field_from_body(body: str, field_name: str) -> str:
    """Extract a field value from issue body markdown.

    Supports both old format (### Field Name) and new LEAN format (## 🎯 Field Name).
    """
    if not body:
        return ''

    # Try multiple patterns for compatibility with old and new formats
    patterns = [
        # New LEAN format with emoji (e.g., "## 🎯 Goals & Scope")
        rf'##\s+[🎯🚨📅⚠️📊🔗]\s+{re.escape(field_name)}\s*\n+(.+?)(?=\n##|\Z)',
        # Old format with ### (e.g., "### Expected Results")
        rf'###?\s+{re.escape(field_name)}\s*\n+(.+?)(?=\n###?|\Z)',
        # Partial match for flexibility (e.g., "Goals" matches "Goals & Scope")
        rf'##\s+[🎯🚨📅⚠️📊🔗]\s+{field_name}[^\n]*\n+(.+?)(?=\n##|\Z)',
    ]

    for pattern in patterns:
        match = re.search(pattern, body, re.DOTALL | re.IGNORECASE)
        if match:
            content = match.group(1).strip()
            # Clean up markdown formatting
            content = re.sub(r'\*\*(.+?)\*\*', r'\1', content)  # Remove bold
            content = re.sub(r'\n+', ' ', content)  # Single line
            content = re.sub(r'- \[ \]', '', content)  # Remove checkboxes
            content = re.sub(r'- ', '', content)  # Remove bullet points
            # Remove alert boxes
            content = re.sub(r'>\s+\[!(?:IMPORTANT|NOTE|WARNING|TIP)\]', '', content)
            content = re.sub(r'>\s+\*\*[^*]+\*\*:', '', content)
            return content[:300]  # Limit length

    return ''


def extract_wish_folder(body: str) -> str:
    """Extract wish folder path from issue body."""
    if not body:
        return ''

    # Look for patterns like "projects/omni/wishes/slack-integration/"
    pattern = r'projects/[\w-]+/wishes/[\w-]+/?'
    match = re.search(pattern, body)

    if match:
        return match.group(0)

    return ''


def map_stage_to_portuguese(stage: str) -> str:
    """Map GitHub stage labels to Portuguese translations for CSV export."""
    stage_mapping = {
        'Wishlist': 'Lista de Desejos',
        'Exploring': 'Investigação',
        'RFC': 'Proposta',  # "Proposta" correctly translates "Request for Change"
        'Prioritization': 'Priorização',
        'Executing': 'Execução',
        'Preview': 'Preview',
        'Shipped': 'Finalizado',
        'Archived': 'Arquivado'
    }
    return stage_mapping.get(stage, stage)


def format_quarter_as_eta(quarter: str) -> str:
    """Format quarter label as ETA (e.g., '2025-q4' → 'Q4 2025')."""
    if not quarter:
        return ''

    # Parse format like "2025-q4"
    match = re.match(r'(\d{4})-q(\d)', quarter, re.IGNORECASE)
    if match:
        year, q = match.groups()
        return f'Q{q} {year}'

    if quarter.lower() == 'backlog':
        return 'BACKLOG'

    return quarter.upper()


def export_roadmap():
    """Export roadmap issues to CSV for stakeholder reporting."""
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print("Error: GITHUB_TOKEN environment variable not set")
        return

    g = Github(token)
    repo = g.get_repo('namastexlabs/automagik-roadmap')

    # Get all issues with 'initiative' label
    issues = repo.get_issues(labels=['initiative'], state='all')

    rows = []
    for issue in issues:
        # Extract labels
        project = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('project:')), '')
        # Stage labels are now pretty names without prefix
        stage = next((l.name for l in issue.labels if l.name in ['Wishlist', 'Exploring', 'RFC', 'Prioritization', 'Executing', 'Preview', 'Shipped', 'Archived']), '')
        quarter = next((l.name.split(':')[1] for l in issue.labels if l.name.startswith('quarter:')), '')

        # Extract fields from issue body (supports both old and new LEAN format)
        # Try new format first, fall back to old format
        expected_result = (
            extract_field_from_body(issue.body, 'Success Metrics') or  # LEAN format
            extract_field_from_body(issue.body, 'Expected Results') or  # Old format
            extract_field_from_body(issue.body, 'Goals')  # LEAN format Goals section
        )

        # Description: Try TL;DR first (LEAN format), then old sections
        description = (
            extract_field_from_body(issue.body, 'TL;DR') or  # LEAN format
            extract_field_from_body(issue.body, 'Problem') or  # LEAN format (🚨 Problem & Why Now)
            extract_field_from_body(issue.body, 'Description') or  # Old format
            extract_field_from_body(issue.body, 'Overview')  # Old format
        )

        wish_folder = extract_wish_folder(issue.body)

        # Get assignee/owner
        owner = '@' + issue.assignee.login if issue.assignee else ''

        # Clean initiative title
        initiative_title = issue.title.replace('[Initiative] ', '').replace('[initiative] ', '')

        # Map stage to Portuguese
        stage_pt = map_stage_to_portuguese(stage)

        # Format ETA
        eta = format_quarter_as_eta(quarter)

        # Dates (Brazilian format: DD/MM/YYYY)
        start_date = issue.created_at.strftime('%d/%m/%Y')
        end_date = issue.closed_at.strftime('%d/%m/%Y') if issue.closed_at else ''

        # Status detail - could be extracted from last comment or milestone
        status_detail = 'TRACKED' if issue.state == 'open' else 'DONE'

        rows.append({
            'PROJECT': project.upper() if project else 'UNKNOWN',
            'INITIATIVE': initiative_title,
            'DESCRIPTION': description or (issue.body[:200] if issue.body else ''),
            'STAGE': stage_pt,
            'ETA': eta,
            'EXPECTED_RESULT': expected_result,
            'STATUS_DETAIL': status_detail,
            'START_DATE': start_date,
            'END_DATE': end_date,
            'ISSUE_URL': issue.html_url,
            'WISH_FOLDER': wish_folder,
            'OWNER': owner
        })

    # Sort by PROJECT, then STAGE, then ETA
    rows.sort(key=lambda x: (x['PROJECT'], x['STAGE'], x['ETA']))

    # Ensure exports directory exists
    os.makedirs('exports', exist_ok=True)

    # Write CSV with stakeholder-friendly column order
    filename = f"exports/roadmap-{datetime.now().strftime('%Y-%m-%d')}.csv"

    if rows:
        # Column order for CSV export
        fieldnames = [
            'PROJECT',
            'INITIATIVE',
            'DESCRIPTION',
            'STAGE',
            'ETA',
            'EXPECTED_RESULT',
            'STATUS_DETAIL',
            'START_DATE',
            'END_DATE',
            'ISSUE_URL',
            'WISH_FOLDER',
            'OWNER'
        ]

        with open(filename, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

        print(f"✓ Exported {len(rows)} initiatives to {filename}")
        print(f"  Columns: {', '.join(fieldnames)}")
    else:
        print("⚠ No initiatives found to export")


if __name__ == '__main__':
    export_roadmap()
